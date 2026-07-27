import 'package:collection/collection.dart';

/// Smartcar Connect's raw `error` query parameter values mapped onto [SmartcarErrorType].
///
/// The Android SDK forwards the parameter verbatim, so these are the values the Android side of the
/// plugin reports. The iOS SDK resolves them to a typed error before the plugin sees them.
/// `user_exited` is the exception: it is not a Connect parameter, the Android SDK synthesizes it
/// when the user dismisses Connect.
const Map<String, SmartcarErrorType> _connectErrorCodes = {
  'access_denied': SmartcarErrorType.accessDenied,
  'vehicle_incompatible': SmartcarErrorType.vehicleIncompatible,
  'invalid_subscription': SmartcarErrorType.invalidSubscription,
  'no_vehicles': SmartcarErrorType.noVehicles,
  'configuration_error': SmartcarErrorType.configurationError,
  'server_error': SmartcarErrorType.serverError,
  'user_exited': SmartcarErrorType.userExitedFlow,
  'user_cancelled': SmartcarErrorType.userExitedFlow,
  'user_manually_returned_to_application': SmartcarErrorType.userExitedFlow,
};

/// Error type that gets created when the authorization flow exits with an error.
enum SmartcarErrorType {
  missingQueryParameters,
  missingAuthCode,
  accessDenied,
  vehicleIncompatible,
  invalidSubscription,
  userExitedFlow,
  configurationError,
  noVehicles,
  serverError,
  unknownError;

  /// Resolves the error type reported by the platform side of the plugin.
  ///
  /// iOS reports a typed error, so the value is the name of this enum. Android reports Smartcar
  /// Connect's raw `error` code, so the value is snake_case (for example `access_denied`). Both
  /// forms resolve here; anything unrecognized resolves to [unknownError].
  static SmartcarErrorType fromRawValue(String raw) {
    return _connectErrorCodes[raw] ??
        values.firstWhereOrNull((e) => e.name == raw) ??
        SmartcarErrorType.unknownError;
  }
}
