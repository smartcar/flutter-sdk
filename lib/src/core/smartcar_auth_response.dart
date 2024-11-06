import 'core.dart';

/// The parent class that handles the response from Smartcar Connect.
sealed class SmartcarAuthResponse {
  const SmartcarAuthResponse();

  static SmartcarAuthResponse fromMap(Map<String, dynamic> map) {
    if (map["code"] != null) {
      return SmartcarAuthSuccess.fromMap(map);
    } else {
      return SmartcarAuthFailure.fromMap(map);
    }
  }
}

/// A class that handles the success response from Smartcar Connect.
final class SmartcarAuthSuccess extends SmartcarAuthResponse {
  const SmartcarAuthSuccess({
    required this.code,
    required this.state,
    required this.virtualKeyUrl,
  });

  /// The code received after the user grants permission.
  final String? code;

  /// If the optional `state` parameter is provided in `AuthUrlBuilder` then it will be returned.
  final String? state;

  final String? virtualKeyUrl;

  factory SmartcarAuthSuccess.fromMap(Map<String, dynamic> map) {
    return SmartcarAuthSuccess(
      code: map["code"],
      state: map["state"],
      virtualKeyUrl: map["virtualKeyUrl"],
    );
  }

  @override
  String toString() {
    return 'SmartcarAuthSuccess(\n'
        '\tcode: $code,\n'
        '\tstate: $state,\n'
        '\tvirtualKeyUrl: $virtualKeyUrl,\n'
        ')';
  }

  @override
  int get hashCode => Object.hash(code.hashCode, state.hashCode, virtualKeyUrl.hashCode);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is SmartcarAuthSuccess &&
        other.code == code &&
        other.state == state &&
        other.virtualKeyUrl == virtualKeyUrl;
  }
}

/// A class that handles the failure response from Smartcar Connect.
final class SmartcarAuthFailure extends SmartcarAuthResponse {
  const SmartcarAuthFailure({
    required this.type,
    required this.description,
  });

  /// Error type that gets created when the authorization flow exits with an error.
  final SmartcarErrorType? type;

  /// The error description.
  final String? description;

  factory SmartcarAuthFailure.fromMap(Map<String, dynamic> map) {
    return SmartcarAuthFailure(
      type: SmartcarErrorType.fromRawValue(map["type"] ?? ''),
      description: map["description"],
    );
  }

  @override
  String toString() {
    return 'SmartcarAuthFailure(\n'
        '\ttype: $type,\n'
        '\tdescription: $description,\n'
        ')';
  }

  @override
  int get hashCode => Object.hash(type, description);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is SmartcarAuthFailure && other.type == type && other.description == description;
  }
}
