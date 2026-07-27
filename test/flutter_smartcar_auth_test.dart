import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SmartcarErrorType.fromRawValue', () {
    test('resolves the error type names reported by iOS', () {
      for (final type in SmartcarErrorType.values) {
        expect(SmartcarErrorType.fromRawValue(type.name), type);
      }
    });

    test("resolves Connect's raw error codes reported by Android", () {
      expect(SmartcarErrorType.fromRawValue('access_denied'), SmartcarErrorType.accessDenied);
      expect(
        SmartcarErrorType.fromRawValue('vehicle_incompatible'),
        SmartcarErrorType.vehicleIncompatible,
      );
      expect(
        SmartcarErrorType.fromRawValue('invalid_subscription'),
        SmartcarErrorType.invalidSubscription,
      );
      expect(SmartcarErrorType.fromRawValue('no_vehicles'), SmartcarErrorType.noVehicles);
      expect(
        SmartcarErrorType.fromRawValue('configuration_error'),
        SmartcarErrorType.configurationError,
      );
      expect(SmartcarErrorType.fromRawValue('server_error'), SmartcarErrorType.serverError);
    });

    test('resolves every user cancellation code to userExitedFlow', () {
      expect(SmartcarErrorType.fromRawValue('user_exited'), SmartcarErrorType.userExitedFlow);
      expect(SmartcarErrorType.fromRawValue('user_cancelled'), SmartcarErrorType.userExitedFlow);
      expect(
        SmartcarErrorType.fromRawValue('user_manually_returned_to_application'),
        SmartcarErrorType.userExitedFlow,
      );
    });

    test('falls back to unknownError', () {
      expect(SmartcarErrorType.fromRawValue(''), SmartcarErrorType.unknownError);
      expect(SmartcarErrorType.fromRawValue('not_a_smartcar_error'), SmartcarErrorType.unknownError);
      expect(SmartcarErrorType.fromRawValue('ACCESS_DENIED'), SmartcarErrorType.unknownError);
    });
  });

  group('SmartcarAuthResponse.fromMap', () {
    test('parses a success response', () {
      final response = SmartcarAuthResponse.fromMap({
        'code': 'test-code',
        'state': 'test-state',
        'virtualKeyUrl': 'https://example.com/virtual-key',
      });

      expect(
        response,
        const SmartcarAuthSuccess(
          code: 'test-code',
          state: 'test-state',
          virtualKeyUrl: 'https://example.com/virtual-key',
        ),
      );
    });

    test('parses the user dismissal reported by Android', () {
      final response = SmartcarAuthResponse.fromMap({
        'type': 'user_exited',
        'description': 'User exited Smartcar Connect before completing the flow',
      });

      expect(
        response,
        const SmartcarAuthFailure(
          type: SmartcarErrorType.userExitedFlow,
          description: 'User exited Smartcar Connect before completing the flow',
        ),
      );
    });

    test('parses the user dismissal reported by iOS', () {
      final response = SmartcarAuthResponse.fromMap({
        'type': 'userExitedFlow',
        'description': null,
      });

      expect(
        response,
        const SmartcarAuthFailure(type: SmartcarErrorType.userExitedFlow, description: null),
      );
    });

    test('parses a failure response with a missing type', () {
      final response = SmartcarAuthResponse.fromMap({'description': 'Something went wrong'});

      expect(
        response,
        const SmartcarAuthFailure(
          type: SmartcarErrorType.unknownError,
          description: 'Something went wrong',
        ),
      );
    });
  });
}
