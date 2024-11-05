import Flutter
import UIKit
import SmartcarAuth

public class FlutterSmartcarAuthPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    
    /// SmartcarAuth instance
    private var smartcarAuth: SmartcarAuth?
    
    /// SmartcarAuth url builder dictionary
    private let authUrlActions: [String : (_ urlBuilder: SCUrlBuilder, _ value: Any?) -> Void] = [
        "forcePrompt": { urlBuilder, value in
            let _ = urlBuilder.setForcePrompt(forcePrompt: value as! Bool)
        },
        "singleSelect": { urlBuilder, value in
            let _ = urlBuilder.setSingleSelect(singleSelect: value as! Bool)
        },
        "flags": { urlBuilder, value in
            let _ = urlBuilder.setFlags(flags: value as! [String])
        },
        "state": { urlBuilder, value in
            let _ = urlBuilder.setState(state: value as! String)
        },
        "make": { urlBuilder, value in
            let _ = urlBuilder.setMakeBypass(make: value as! String)
        },
        "vin": { urlBuilder, value in
            let _ = urlBuilder.setSingleSelectVin(vin: value as! String)
        },
        "user": { urlBuilder, value in
            let _ = urlBuilder.setUser(user: value as! String)
        },
    ]
    
    
    /// FlutterPlugin
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "smartcar/flutter_smartcar_auth", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "smartcar/flutter_smartcar_auth/events", binaryMessenger: registrar.messenger())
        let instance: FlutterSmartcarAuthPlugin = FlutterSmartcarAuthPlugin()
        eventChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setup":
            self.setup(arguments: call.arguments as! Dictionary<String, Any?>, result: result)
            break
        case "launchAuthFlow":
            self.launchAuthFlow(arguments: call.arguments as! Dictionary<String, Any?>, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    /// FlutterStreamHandler
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    /// FlutterSmartcarAuthPlugin methods used through MethodChannel
    private func setup(arguments: Dictionary<String, Any?>, result: FlutterResult) -> Void {
        self.smartcarAuth = SmartcarAuth(
            clientId: arguments["clientId"] as! String,
            redirectUri: arguments["redirectUri"] as! String,
            scope: arguments["scopes"] as! Array<String>,
            completionHandler: responseHandler,
            mode: SCMode(rawValue: arguments["mode"] as! String)
        )
        
        result(nil)
    }
    
    private func launchAuthFlow(arguments: Dictionary<String, Any?>, result: FlutterResult) -> Void {
        do {
            if (self.smartcarAuth != nil) {
                let authUrl = self.smartcarAuth!.authUrlBuilder()
                
                arguments.forEach { body in
                    authUrlActions[body.key]?(authUrl, body.value)
                }
                
                let url = authUrl.build()
                
                self.smartcarAuth!.launchAuthFlow(
                    url: url,
                    viewController: UIApplication.shared.delegate!.window!!.rootViewController!
                )
                
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "LAUNCH_AUTH_FLOW_ERROR",
                        message: "SmartcarAuth is not configured yet, please call Smartcar.setup() first.",
                        details: nil
                    )
                )
            }
        }
    }
    
    /// Method to handle the SmartcarAuth response
    private func responseHandler(
        code: String?,
        state: String?,
        virtualKeyUrl: String?,
        error: AuthorizationError?
    ) -> Void {
        if (self.eventSink != nil) {
            var data: [String : Any?]
            
            if (error == nil) {
                data = [
                    "code": code,
                    "state": state,
                    "virtualKeyUrl": virtualKeyUrl,
                ]
            } else {
                data = [
                    "type": error!.type.stringValue,
                    "description": error!.errorDescription,
                ]
            }
            
            self.eventSink!(data)
        }
        
    }
}
