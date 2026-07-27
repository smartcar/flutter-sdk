import '../platform/smartcar_platform_interface.dart';
import 'auth_url_builder.dart';
import 'smartcar_auth_response.dart';
import 'smartcar_config.dart';
import 'smartcar_response_type.dart';

/// Provides **SmartcarAuth** drop in functionality.
abstract final class Smartcar {
  static SmartcarPlatformInterface get _platform => SmartcarPlatformInterface.instance;

  /// A broadcast stream to listen for Smartcar Connect response<br>
  /// when the authentication flow is launched.
  static Stream<SmartcarAuthResponse> get onSmartcarResponse => _platform.onEvent;

  /// Creates the `SmartcarAuth` instance with the given values in `SmartcarConfig` class
  ///
  /// Throws an [ArgumentError] when [SmartcarConfig.redirectUri] is missing on a
  /// [SmartcarResponseType.code] flow. The native SDKs reject that combination themselves, and on
  /// iOS they do it with a `precondition` that terminates the app, so it is caught here first.
  static Future<void> setup({required SmartcarConfig configuration}) async {
    final redirectUri = configuration.redirectUri;

    if (configuration.responseType == SmartcarResponseType.code && (redirectUri == null || redirectUri.isEmpty)) {
      throw ArgumentError.value(
        redirectUri,
        'configuration.redirectUri',
        'A redirectUri is required when responseType is SmartcarResponseType.code',
      );
    }

    return _platform.setup(configuration: configuration);
  }

  /// Launches the authenticacion flow for Smartcar
  static Future<void> launchAuthFlow({AuthUrlBuilder authUrlBuilder = const AuthUrlBuilder()}) async =>
      _platform.launchAuthFlow(authUrlBuilder: authUrlBuilder);
}
