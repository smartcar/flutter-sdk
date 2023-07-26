import '../platform/smartcar_platform_interface.dart';
import 'auth_url_builder.dart';
import 'smartcar_auth_response.dart';
import 'smartcar_config.dart';

/// Provides **SmartcarAuth** drop in functionality.
class Smartcar {
  static SmartcarPlatformInterface get _platform => SmartcarPlatformInterface.instance;

  /// A broadcast stream to listen for Smartcar Connect response<br>
  /// when the authentication flow is launched.
  static Stream<SmartcarAuthResponse> get onSmartcarResponse => _platform.onEvent;

  /// Creates the `SmartcarAuth` instance with the given values in `SmartcarConfig` class
  static Future<void> setup({required SmartcarConfig configuration}) async =>
      _platform.setup(configuration: configuration);

  /// Launches the authenticacion flow for Smartcar
  static Future<void> launchAuthFlow({AuthUrlBuilder authUrlBuilder = const AuthUrlBuilder()}) async =>
      _platform.launchAuthFlow(authUrlBuilder: authUrlBuilder);
}
