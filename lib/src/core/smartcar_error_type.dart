import 'package:collection/collection.dart';

/// Error type that gets created when the authorization flow exits with an error.
enum SmartcarErrorType {
  missingQueryParameters,
  missingAuthCode,
  accessDenied,
  vehicleIncompatible,
  invalidSubscription,
  userExitedFlow,
  unknownError;

  static SmartcarErrorType fromRawValue(String raw) {
    return values.firstWhereOrNull((e) => e.name == raw) ?? SmartcarErrorType.unknownError;
  }
}
