import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/// A class that handles the response from Smartcar Connect.
class SmartcarAuthResponse {
  const SmartcarAuthResponse({
    required this.code,
    required this.error,
    required this.state,
    required this.errorDescription,
    this.virtualKeyUrl,
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

  /// virtualKeyUrl
  final String? virtualKeyUrl;

  @override
  String toString() {
    return 'SmartcarAuthResponse(code: $code, error: $error, state: $state, errorDescription: $errorDescription, virtualKeyUrl: $virtualKeyUrl)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'error': error,
      'state': state,
      'errorDescription': errorDescription,
      'virtualKeyUrl': virtualKeyUrl,
    };
  }

  factory SmartcarAuthResponse.fromMap(dynamic map) {
    return SmartcarAuthResponse(
      code: map['code'] != null ? map['code'] as String : null,
      error: map['error'] != null ? map['error'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      errorDescription: map['errorDescription'] != null ? map['errorDescription'] as String : null,
      virtualKeyUrl: map['virtualKeyUrl'] != null ? map['virtualKeyUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SmartcarAuthResponse.fromJson(String source) =>
      SmartcarAuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
