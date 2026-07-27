import 'core.dart';

/// This class provides the needed arguments to create a `SmartcarAuth` instance
final class SmartcarConfig {
  /// The client's ID
  final String clientId;

  /// The application's redirect URI
  ///
  /// Optional. When [responseType] is [SmartcarResponseType.code] and this is omitted, Smartcar
  /// Connect falls back to the default redirect URI configured on the Smartcar developer
  /// dashboard. When [responseType] is [SmartcarResponseType.none], no redirect URI is needed and
  /// no fallback occurs.
  final String? redirectUri;

  /// An array of authorization scopes
  ///
  /// Example: `[SmartcarPermission.readTires, SmartcarPermission.readOdometer]`
  final List<SmartcarPermission> scopes;

  /// Determine what mode Smartcar Connect should be launched in. Should be one of `test`, `live` or `simulated`.
  ///
  /// Defaults to `live` mode.
  final SmartcarMode mode;

  /// Determines whether Connect completes the flow via redirect (`code`) or without one (`none`).
  ///
  /// Defaults to [SmartcarResponseType.code].
  final SmartcarResponseType responseType;

  const SmartcarConfig({
    required this.clientId,
    this.redirectUri,
    required this.scopes,
    this.mode = SmartcarMode.live,
    this.responseType = SmartcarResponseType.code,
  });

  Map<String, dynamic> toMap() {
    return {
      "clientId": clientId,
      if (redirectUri != null) "redirectUri": redirectUri,
      "scopes": scopes.map((e) => e.value).toList(),
      "mode": mode.name,
      "responseType": responseType.value,
    };
  }

  @override
  String toString() {
    return 'SmartcarConfig(\n'
        '\tclientId: $clientId,\n'
        '\tredirectUri: $redirectUri,\n'
        '\tscopes: $scopes,\n'
        '\tmode: $mode,\n'
        '\tresponseType: $responseType\n'
        ')';
  }

  @override
  int get hashCode =>
      Object.hash(clientId.hashCode, redirectUri.hashCode, scopes.hashCode, mode.hashCode, responseType.hashCode);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is SmartcarConfig &&
        other.clientId == clientId &&
        other.redirectUri == redirectUri &&
        other.scopes == scopes &&
        other.mode == mode &&
        other.responseType == responseType;
  }
}
