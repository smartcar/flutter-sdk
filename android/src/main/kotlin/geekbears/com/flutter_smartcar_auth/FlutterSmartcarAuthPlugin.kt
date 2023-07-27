package geekbears.com.flutter_smartcar_auth

import android.content.Context
import com.smartcar.sdk.SmartcarAuth
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** FlutterSmartcarAuthPlugin */
class FlutterSmartcarAuthPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private val METHOD_CHANNEL_NAME = "geekbears/flutter_smartcar_auth"
    private val EVENT_CHANNEL_NAME = "geekbears/flutter_smartcar_auth/events"

    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventSink? = null

    /// SmartcarAuth instance
    private lateinit var smartcarAuth: SmartcarAuth

    /// FlutterPlugin

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

    /// MethodCallHandler

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        when (call.method) {
            ("setup") -> setup(call.arguments as HashMap<String, Any>, result)
            ("launchAuthFlow") -> launchAuthFlow(call.arguments as HashMap<String, Any>, result)
            else -> result.notImplemented()
        }
    }

    /// EventChannel.StreamHandler

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    /// FlutterSmartcarPlugin methods used through MethodChannel

    private fun setup(arguments: HashMap<String, Any>, result: MethodChannel.Result) {
        try {
            @Suppress("UNCHECKED_CAST")
            smartcarAuth = SmartcarAuth(
                arguments["clientId"].toString(),
                arguments["redirectUri"].toString(),
                (arguments["scopes"] as List<String>).toTypedArray(),
                arguments["testMode"] as Boolean
            )
            // Create a callback to handle the redirect response
            {
                if (eventSink != null) {
                    val data: HashMap<String, Any> = hashMapOf(
                        "code" to it.code,
                        "state" to it.state,
                        "error" to it.error,
                        "errorDescription" to it.errorDescription
                    )

                    if (it.vehicleInfo != null) {
                        data["vehicleInfo"] = hashMapOf(
                            "vin" to it.vehicleInfo.vin,
                            "make" to it.vehicleInfo.make,
                            "model" to it.vehicleInfo.model,
                            "year" to it.vehicleInfo.year
                        )
                    }

                    eventSink!!.success(data)
                }
            }

            result.success(null)
        } catch (error: Exception) {
            result.error("SETUP_SMARTCAR_ERROR", error.message, error.localizedMessage)
        }
    }

    private fun launchAuthFlow(arguments: HashMap<String, Any>, result: MethodChannel.Result) {
        try {
            if (this::smartcarAuth.isInitialized) {
                val authUrl = smartcarAuth.authUrlBuilder()

                if (arguments.containsKey("forcePrompt")) {
                    authUrl.setForcePrompt(arguments["forcePrompt"] as Boolean)
                }

                if (arguments.containsKey("singleSelect")) {
                    authUrl.setSingleSelect(arguments["singleSelect"] as Boolean)
                }

                if (arguments["state"] != null) {
                    authUrl.setState(arguments["state"].toString())
                }

                if (arguments["make"] != null) {
                    authUrl.setMakeBypass(arguments["make"].toString())
                }

                if (arguments["vin"] != null) {
                    authUrl.setSingleSelectVin(arguments["vin"].toString())
                }

                smartcarAuth.launchAuthFlow(context, authUrl.build())

                result.success(null)
            } else {
                result.error("LAUNCH_AUTH_FLOW_ERROR", "SmartcarAuth is not configured yet, please call Smartcar.setup() first.", null)
            }

        } catch (error: Exception) {
            result.error("LAUNCH_AUTH_FLOW_ERROR", error.message, error.localizedMessage)
        }

    }
}

