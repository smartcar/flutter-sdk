package smartcar.com.flutter_smartcar_auth

import android.content.Context
import com.smartcar.sdk.SmartcarAuth
import com.smartcar.sdk.SmartcarAuth.AuthUrlBuilder
import com.smartcar.sdk.SmartcarCallback
import com.smartcar.sdk.SmartcarResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** FlutterSmartcarAuthPlugin */
class FlutterSmartcarAuthPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private val METHOD_CHANNEL_NAME = "smartcar/flutter_smartcar_auth"
    private val EVENT_CHANNEL_NAME = "smartcar/flutter_smartcar_auth/events"

    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventSink? = null

    /** SmartcarAuth instance */
    private lateinit var smartcarAuth: SmartcarAuth

    private val authUrlActions: HashMap<String, (urlBuilder: AuthUrlBuilder, value: Any?) -> Unit> =
        hashMapOf(
            "forcePrompt" to { urlBuilder, value ->
                urlBuilder.setForcePrompt(value as Boolean)
            },
            "singleSelect" to { urlBuilder, value ->
                urlBuilder.setSingleSelect(value as Boolean)
            },
            "state" to { urlBuilder, value ->
                urlBuilder.setState(value!!.toString())
            },
            "flags" to { urlBuilder, value ->
                urlBuilder.setFlags((value as ArrayList<*>).map { it.toString() }.toTypedArray())
            },
            "make" to { urlBuilder, value ->
                urlBuilder.setMakeBypass(value!!.toString())
            },
            "vin" to { urlBuilder, value ->
                urlBuilder.setSingleSelectVin(value!!.toString())
            },
            "user" to { urlBuilder, value ->
                urlBuilder.setUser(value!!.toString())
            },
        )

    /** FlutterPlugin */
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    /** MethodCallHandler */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        when (call.method) {
            ("setup") -> setup(call.arguments as HashMap<String, Any>, result)
            ("launchAuthFlow") -> launchAuthFlow(call.arguments as HashMap<String, Any>, result)
            else -> result.notImplemented()
        }
    }

    /** EventChannel.StreamHandler */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    /** FlutterSmartcarPlugin methods used through MethodChannel */
    private fun setup(arguments: HashMap<String, Any>, result: MethodChannel.Result) {
        try {
            @Suppress("UNCHECKED_CAST")
            smartcarAuth =
                SmartcarAuth(
                    arguments["clientId"].toString(),
                    arguments["redirectUri"].toString(),
                    (arguments["scopes"] as List<String>).toTypedArray(),
                    arguments["mode"].toString() != "live",
                    { responseHandler(it) }
                )

            result.success(null)
        } catch (error: Exception) {
            result.error("SETUP_SMARTCAR_ERROR", error.message, error.localizedMessage)
        }
    }

    private fun launchAuthFlow(arguments: HashMap<String, Any>, result: MethodChannel.Result) {
        try {
            if (this::smartcarAuth.isInitialized) {
                val authUrl = smartcarAuth.authUrlBuilder()

                arguments.forEach { key, value ->
                    authUrlActions[key]!!(authUrl, value)
                }

                val url: String = authUrl.build()

                smartcarAuth.launchAuthFlow(context, url)

                result.success(null)
            } else {
                result.error(
                    "LAUNCH_AUTH_FLOW_ERROR",
                    "SmartcarAuth is not configured yet, please call Smartcar.setup() first.",
                    null
                )
            }
        } catch (error: Exception) {
            result.error("LAUNCH_AUTH_FLOW_ERROR", error.message, error.localizedMessage)
        }
    }

    private fun responseHandler(smartcarResponse: SmartcarResponse) {
        if (eventSink != null) {
            val data: HashMap<String, Any> = hashMapOf()

            if (smartcarResponse.code.isNotEmpty()) {
                data.putAll(
                    hashMapOf(
                        "code" to smartcarResponse.code,
                        "virtualKeyUrl" to smartcarResponse.virtualKeyUrl,
                        "state" to smartcarResponse.state
                    )
                )
            } else {
                data.putAll(
                    hashMapOf(
                        "type" to smartcarResponse.error,
                        "description" to smartcarResponse.errorDescription
                    )
                )
            }

            eventSink!!.success(data)
        }
    }
}
