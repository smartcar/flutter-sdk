import 'package:flutter/services.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    test('parses a responseType none success, which carries no code', () {
      final response = SmartcarAuthResponse.fromMap({
        'code': null,
        'state': 'test-state',
        'virtualKeyUrl': null,
        'userId': 'test-user-id',
        'externalId': 'test-external-id',
      });

      expect(
        response,
        const SmartcarAuthSuccess(
          code: null,
          state: 'test-state',
          virtualKeyUrl: null,
          userId: 'test-user-id',
          externalId: 'test-external-id',
        ),
      );
    });

    test('parses a code flow that returned no code as missingAuthCode', () {
      final response = SmartcarAuthResponse.fromMap({
        'type': 'missing_auth_code',
        'description': 'Unable to fetch code. Please try again',
      });

      expect(
        response,
        const SmartcarAuthFailure(
          type: SmartcarErrorType.missingAuthCode,
          description: 'Unable to fetch code. Please try again',
        ),
      );
    });
  });

  group('Smartcar.setup', () {
    const channel = MethodChannel('smartcar/flutter_smartcar_auth');
    final calls = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (call) async {
          calls.add(call);
          return null;
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      calls.clear();
    });

    test('rejects a code flow without a redirectUri', () async {
      await expectLater(
        Smartcar.setup(
          configuration: const SmartcarConfig(clientId: 'test-client-id', scopes: []),
        ),
        throwsArgumentError,
      );

      expect(calls, isEmpty);
    });

    test('rejects a code flow with an empty redirectUri', () async {
      await expectLater(
        Smartcar.setup(
          configuration: const SmartcarConfig(
            clientId: 'test-client-id',
            redirectUri: '',
            scopes: [],
          ),
        ),
        throwsArgumentError,
      );

      expect(calls, isEmpty);
    });

    test('allows a none flow without a redirectUri', () async {
      await Smartcar.setup(
        configuration: const SmartcarConfig(
          clientId: 'test-client-id',
          scopes: [SmartcarPermission.readOdometer],
          responseType: SmartcarResponseType.none,
        ),
      );

      expect(calls, hasLength(1));
      expect(calls.single.method, 'setup');
      expect(calls.single.arguments, {
        'clientId': 'test-client-id',
        'scopes': [SmartcarPermission.readOdometer.value],
        'mode': 'live',
        'responseType': 'none',
      });
    });

    test('passes a code flow through with its redirectUri', () async {
      await Smartcar.setup(
        configuration: const SmartcarConfig(
          clientId: 'test-client-id',
          redirectUri: 'sc-test://example',
          scopes: [],
        ),
      );

      expect(calls.single.arguments, containsPair('redirectUri', 'sc-test://example'));
      expect(calls.single.arguments, containsPair('responseType', 'code'));
    });
  });
}
