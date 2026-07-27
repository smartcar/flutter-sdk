import 'core.dart';

/// The parent class that handles the response from Smartcar Connect.
sealed class SmartcarAuthResponse {
  const SmartcarAuthResponse();

  static SmartcarAuthResponse fromMap(Map<String, dynamic> map) {
    if (map["type"] != null) {
      return SmartcarAuthFailure.fromMap(map);
    } else {
      return SmartcarAuthSuccess.fromMap(map);
    }
  }
}

/// A class that handles the success response from Smartcar Connect.
final class SmartcarAuthSuccess extends SmartcarAuthResponse {
  const SmartcarAuthSuccess({
    required this.code,
    required this.state,
    required this.virtualKeyUrl,
    this.userId,
    this.externalId,
  });

  /// The code received after the user grants permission.
  ///
  /// Not present when `responseType` is `SmartcarResponseType.none`.
  final String? code;

  /// If the optional `state` parameter is provided in `AuthUrlBuilder` then it will be returned.
  final String? state;

  final String? virtualKeyUrl;

  /// The Smartcar user ID of the user who granted access.
  final String? userId;

  /// The `externalId` provided in `AuthUrlBuilder`, if any.
  final String? externalId;

  factory SmartcarAuthSuccess.fromMap(Map<String, dynamic> map) {
    return SmartcarAuthSuccess(
      code: map["code"],
      state: map["state"],
      virtualKeyUrl: map["virtualKeyUrl"],
      userId: map["userId"],
      externalId: map["externalId"],
    );
  }

  @override
  String toString() {
    return 'SmartcarAuthSuccess(\n'
        '\tcode: $code,\n'
        '\tstate: $state,\n'
        '\tvirtualKeyUrl: $virtualKeyUrl,\n'
        '\tuserId: $userId,\n'
        '\texternalId: $externalId,\n'
        ')';
  }

  @override
  int get hashCode =>
      Object.hash(code.hashCode, state.hashCode, virtualKeyUrl.hashCode, userId.hashCode, externalId.hashCode);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;

    return other is SmartcarAuthSuccess &&
        other.code == code &&
        other.state == state &&
        other.virtualKeyUrl == virtualKeyUrl &&
        other.userId == userId &&
        other.externalId == externalId;
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
