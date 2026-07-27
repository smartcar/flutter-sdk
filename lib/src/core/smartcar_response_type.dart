/// Determines how Smartcar Connect delivers the result of the authorization flow.
enum SmartcarResponseType {
  /// Connect completes the flow via redirect, returning an authorization `code`.
  ///
  /// Requires a `redirectUri` to be set on `SmartcarConfig`.
  code("code"),

  /// Connect completes the flow without a redirect.
  ///
  /// Allows `redirectUri` to be omitted from `SmartcarConfig`.
  none("none");

  const SmartcarResponseType(this.value);

  /// The translated value for the Smartcar SDK.
  final String value;
}
