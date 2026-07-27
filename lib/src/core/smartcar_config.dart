import 'core.dart';

/// This class provides the needed arguments to create a `SmartcarAuth` instance
final class SmartcarConfig {
  /// The client's ID
  final String clientId;

  /// The application's redirect URI
  ///
  /// Required when [responseType] is [SmartcarResponseType.code], which is the default: the native
  /// SDKs use it to intercept the redirect, and both reject a `code` flow without one. Omit it only
  /// when [responseType] is [SmartcarResponseType.none], where Connect completes the flow without a
  /// redirect. `Smartcar.setup` throws an [ArgumentError] on the unsupported combination.
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
