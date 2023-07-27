import Flutter
import UIKit
import SmartcarAuth

public class FlutterSmartcarAuthPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
  private var eventSink: FlutterEventSink?

  /// SmartcarAuth instance
  private var smartcarAuth: SmartcarAuth?


  /// FlutterPlugin
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "geekbears/flutter_smartcar_auth", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "geekbears/flutter_smartcar_auth/events", binaryMessenger: registrar.messenger())
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
    do {
      try self.smartcarAuth = SmartcarAuth(
        clientId: arguments["clientId"] as! String,
        redirectUri: arguments["redirectUri"] as! String,
        scope: arguments["scopes"] as! Array<String>,
        completionHandler: responseHandler,
        testMode: arguments["testMode"] as! Bool
      )

      result(nil)
    } catch {
      result(
        FlutterError(
          code: "SETUP_SMARTCAR_ERROR",
          message: "\(error)",
          details: nil
        )
      )
    }
  }

  private func launchAuthFlow(arguments: Dictionary<String, Any?>, result: FlutterResult) -> Void {
    do {
      if (self.smartcarAuth != nil) {
        let authUrl = self.smartcarAuth!.authUrlBuilder()

        if (arguments.keys.contains("forcePrompt")) {
          authUrl.setForcePrompt(forcePrompt: arguments["forcePrompt"] as! Bool)
        }

        if (arguments.keys.contains("singleSelect")) {
          authUrl.setSingleSelect(singleSelect: arguments["singleSelect"] as! Bool)
        }

        if (arguments["state"] != nil && arguments["state"] is String) {
          authUrl.setState(state: arguments["state"] as! String)
        }

        if (arguments["make"] != nil && arguments["make"] is String) {
          authUrl.setMakeBypass(make: arguments["make"] as! String)
        }

        if (arguments["vin"] != nil && arguments["vin"] is String) {
          authUrl.setSingleSelectVin(vin: arguments["vin"] as! String)
        }

        try self.smartcarAuth!.launchAuthFlow(url: authUrl.build())

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
    } catch {
      result(
        FlutterError(
          code: "LAUNCH_AUTH_FLOW_ERROR",
          message: "\(error)",
          details: nil
        )
      )
    }

  }

  /// Method to handle the SmartcarAuth response

  private func responseHandler(code: String?, state: String?, error: AuthorizationError?) -> Void {
    do {
      if (eventSink != nil) {
        let data: [String : Any?] = [
          "code": code,
          "state": state,
          "error": error?.description,
        ]
        try eventSink!(data)
      }
    } catch {
      
    }
  }
}
