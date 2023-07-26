import 'smartcar_permission.dart';

/// This class provides the needed arguments to create a `SmartcarAuth` instance
class SmartcarConfig {
  /// The client's ID
  final String clientId;

  /// The application’s redirect URI
  final String redirectUri;

  /// An array of authorization scopes
  ///
  /// Example: `[SmartcarPermission.readTires, SmartcarPermission.readOdometer]`
  final List<SmartcarPermission> scopes;

  /// Launch the Smartcar auth flow in test mode when set to `true`. Defaults to `false`
  final bool testMode;

  const SmartcarConfig({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    this.testMode = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "clientId": clientId,
      "redirectUri": redirectUri,
      "scopes": scopes.map((e) => e.value).toList(),
      "testMode": testMode,
    };
  }

  @override
  String toString() =>
      "SmartcarConfig(\nclientId: $clientId,\nredirectUri: $redirectUri,\nscopes: $scopes,\ntestMode: $testMode\n)";

  @override
  int get hashCode => clientId.hashCode ^ redirectUri.hashCode ^ scopes.hashCode ^ testMode.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is SmartcarConfig &&
        other.clientId == clientId &&
        other.redirectUri == redirectUri &&
        other.scopes == scopes &&
        other.testMode == testMode;
  }
}
