import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../core/auth_url_builder.dart';
import '../core/smartcar_auth_response.dart';
import '../core/smartcar_config.dart';
import 'smartcar_method_channel.dart';

abstract class SmartcarPlatformInterface extends PlatformInterface {
  /// Contructor
  SmartcarPlatformInterface() : super(token: _token);

  /// Token
  static final Object _token = Object();

  /// Singleton instance
  static SmartcarPlatformInterface _instance = SmartcarMethodChannel();

  /// Default instance to use.
  static SmartcarPlatformInterface get instance => _instance;

  static set instance(SmartcarPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// A broadcast stream from the native platform
  Stream<SmartcarAuthResponse> get onEvent {
    throw UnimplementedError('onEvent has not been implemented.');
  }

  /// Creates the `SmartcarAuth` instance with the given values in `SmartcarConfig` class
  Future<void> setup({required SmartcarConfig configuration}) async {
    throw UnimplementedError('setup() has not been implemented.');
  }

  /// Launches the authenticacion flow for Smartcar
  Future<void> launchAuthFlow({AuthUrlBuilder authUrlBuilder = const AuthUrlBuilder()}) async {
    throw UnimplementedError('launchAuthFlow() has not been implemented.');
  }
}
