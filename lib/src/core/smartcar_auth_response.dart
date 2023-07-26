/// A class that handles the response from Smartcar Connect.
class SmartcarAuthResponse {
  const SmartcarAuthResponse({
    required this.code,
    required this.error,
    required this.state,
    required this.errorDescription,
  });

  /// The code received after the user grants permission.
  final String? code;

  /// Error that gets created when the authorization flow exits with an error.
  final String? error;

  /// If the optional `state` parameter is provided in `AuthUrlBuilder`<br>
  /// then it will be returned.
  final String? state;

  /// The error description.
  final String? errorDescription;

  factory SmartcarAuthResponse.fromMap(dynamic map) {
    return SmartcarAuthResponse(
      code: map["code"],
      error: map["error"],
      state: map["state"],
      errorDescription: map["errorDescription"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "code": code,
      "error": error,
      "state": state,
      "errorDescription": errorDescription,
    };
  }

  @override
  String toString() =>
      "SmartcarAuthResponse(\ncode: $code,\nerror: $error,\nstate: $state,\nerrorDescription: $errorDescription\n}\n)";

  @override
  int get hashCode => code.hashCode ^ error.hashCode ^ state.hashCode ^ errorDescription.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is SmartcarAuthResponse &&
        other.code == code &&
        other.error == error &&
        other.state == state &&
        other.errorDescription == errorDescription;
  }
}
