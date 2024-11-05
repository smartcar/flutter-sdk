import 'core.dart';

/// This class provides the needed arguments to create a `SmartcarAuth` instance
final class SmartcarConfig {
  /// The client's ID
  final String clientId;

  /// The application’s redirect URI
  final String redirectUri;

  /// An array of authorization scopes
  ///
  /// Example: `[SmartcarPermission.readTires, SmartcarPermission.readOdometer]`
  final List<SmartcarPermission> scopes;

  /// Determine what mode Smartcar Connect should be launched in. Should be one of `test`, `live` or `simulated`.
  ///
  /// Defaults to `live` mode.
  final SmartcarMode mode;

  const SmartcarConfig({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    this.mode = SmartcarMode.live,
  });

  Map<String, dynamic> toMap() {
    return {
      "clientId": clientId,
      "redirectUri": redirectUri,
      "scopes": scopes.map((e) => e.value).toList(),
      "mode": mode.name,
    };
  }

  @override
  String toString() {
    return 'SmartcarConfig(\n'
        '\tclientId: $clientId,\n'
        '\tredirectUri: $redirectUri,\n'
        '\tscopes: $scopes,\n'
        '\tmode: $mode\n'
        ')';
  }

  @override
  int get hashCode => Object.hash(clientId.hashCode, redirectUri.hashCode, scopes.hashCode, mode.hashCode);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is SmartcarConfig &&
        other.clientId == clientId &&
        other.redirectUri == redirectUri &&
        other.scopes == scopes &&
        other.mode == mode;
  }
}
