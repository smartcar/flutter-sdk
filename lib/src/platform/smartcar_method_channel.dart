import 'package:flutter/services.dart';

import '../core/core.dart';
import 'smartcar_platform_interface.dart';

class SmartcarMethodChannel extends SmartcarPlatformInterface {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel('smartcar/flutter_smartcar_auth');

  /// The event channel used to receive changes from the native platform.
  final EventChannel _eventChannel = const EventChannel('smartcar/flutter_smartcar_auth/events');

  /// A broadcast stream from the native platform
  @override
  Stream<SmartcarAuthResponse> get onEvent => _eventChannel.receiveBroadcastStream().map(
        (event) => SmartcarAuthResponse.fromMap(Map<String, dynamic>.from(event)),
      );

  /// Creates the `SmartcarAuth` instance with the given values in `SmartcarConfig` class
  @override
  Future<void> setup({required SmartcarConfig configuration}) async {
    await _channel.invokeMethod('setup', configuration.toMap());
  }

  /// Launches the authenticacion flow for Smartcar
  @override
  Future<void> launchAuthFlow({AuthUrlBuilder authUrlBuilder = const AuthUrlBuilder()}) async {
    await _channel.invokeMethod('launchAuthFlow', authUrlBuilder.toMap());
  }
}
