import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/app/config/app_config.dart';
import 'package:rainbow_app/core/network/api_client.dart';
import 'package:rainbow_app/core/network/api_failure.dart';
import 'package:rainbow_app/core/network/api_response.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  late FakeApi api;
  late ApiClient client;
  late List<String> unauthorizedCalls;

  ApiClient buildClient({String? token}) {
    final ApiClient built = ApiClient(
      config: const AppConfig(
        flavor: AppFlavor.development,
        apiBaseUrl: 'https://rainbow.test',
        enableNetworkLogging: false,
      ),
      readToken: () async => token,
      onUnauthorized: () async => unauthorizedCalls.add('called'),
    );
    built.dio.httpClientAdapter = api;
    return built;
  }

  setUp(() {
    api = FakeApi();
    unauthorizedCalls = <String>[];
    client = buildClient(token: 'test-token');
  });

  group('successful responses', () {
    test('unwraps the {success, message, data} envelope', () async {
      api.on('/orders-ready', const FakeResponse(Fixtures.ordersReady));

      final ApiResponse<List<Map<String, Object?>>> response = await client
          .get<List<Map<String, Object?>>>(
            '/api/v1/guard/orders-ready',
            decode: asJsonList,
          );

      expect(response.data, hasLength(2));
      expect(response.data.first['order_no'], 'SO-20260818-786E');
    });

    test('carries the server message through', () async {
      api.on(
        '/gate-in',
        const FakeResponse(Fixtures.gateInCreated, statusCode: 201),
      );

      final ApiResponse<Map<String, Object?>> response = await client
          .post<Map<String, Object?>>(
            '/api/v1/guard/vehicles/gate-in',
            decode: asJsonMap,
          );

      expect(response.message, contains('registered'));
    });

    test('drops null and empty optional query parameters', () async {
      api.on('/gate-in', const FakeResponse(Fixtures.gateInCreated));

      await client.post<Map<String, Object?>>(
        '/api/v1/guard/vehicles/gate-in',
        query: <String, Object?>{
          'vehicle_no': 'KA 01 ZZ 7777',
          'driver_phone': null,
          'transporter_name': '',
        },
        decode: asJsonMap,
      );

      final Map<String, Object?>? sent = api.lastRequest?.queryParameters;
      expect(sent, isNotNull);
      expect(sent!.keys, <String>['vehicle_no']);
    });
  });

  group('failure mapping', () {
    test(
      '401 becomes UnauthorizedFailure and reports the expired session',
      () async {
        api.on(
          '/guard/vehicles',
          const FakeResponse(Fixtures.unauthorized, statusCode: 401),
        );

        await expectLater(
          client.get<Map<String, Object?>>(
            '/api/v1/guard/vehicles',
            decode: asJsonMap,
          ),
          throwsA(isA<UnauthorizedFailure>()),
        );
        expect(unauthorizedCalls, hasLength(1));
      },
    );

    test('a failed sign-in does not end the session', () async {
      api.on(
        '/auth/login',
        const FakeResponse(Fixtures.unauthorized, statusCode: 401),
      );

      await expectLater(
        client.post<Map<String, Object?>>(
          '/api/v1/auth/login',
          decode: asJsonMap,
        ),
        throwsA(isA<UnauthorizedFailure>()),
      );
      // Wrong password is a form error, not an expired token.
      expect(unauthorizedCalls, isEmpty);
    });

    test(
      '422 with an errors map becomes a field-level ValidationFailure',
      () async {
        api.on(
          '/gate-in',
          const FakeResponse(Fixtures.validationError, statusCode: 422),
        );

        try {
          await client.post<Map<String, Object?>>(
            '/api/v1/guard/vehicles/gate-in',
            decode: asJsonMap,
          );
          fail('expected a ValidationFailure');
        } on ValidationFailure catch (failure) {
          expect(failure.isWorkflowRule, isFalse);
          expect(
            failure.errorFor('vehicle_no'),
            'The vehicle no field is required.',
          );
          expect(failure.errorFor('sales_order_id'), isNotNull);
        }
      },
    );

    test('422 without an errors map is treated as a workflow rule', () async {
      api.on(
        '/gate-out',
        const FakeResponse(Fixtures.workflowError, statusCode: 422),
      );

      try {
        await client.post<Map<String, Object?>>(
          '/api/v1/guard/vehicles/1/gate-out',
          decode: asJsonMap,
        );
        fail('expected a ValidationFailure');
      } on ValidationFailure catch (failure) {
        expect(failure.isWorkflowRule, isTrue);
        // The server's explanation is state-specific, so it is shown as-is.
        final AppLocalizations l10n = await AppLocalizations.delegate.load(
          const Locale('en'),
        );
        expect(failure.localizedMessage(l10n), contains('must be in'));
      }
    });

    test('5xx becomes ServerFailure', () async {
      api.on(
        '/guard/vehicles',
        const FakeResponse(<String, Object?>{
          'message': 'Server Error',
        }, statusCode: 503),
      );

      await expectLater(
        client.get<Map<String, Object?>>(
          '/api/v1/guard/vehicles',
          decode: asJsonMap,
        ),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('a connection error becomes NetworkFailure', () async {
      api.on(
        '/guard/vehicles',
        FakeResponse.failure(
          DioException.connectionError(
            requestOptions: RequestOptions(path: '/api/v1/guard/vehicles'),
            reason: 'offline',
          ),
        ),
      );

      await expectLater(
        client.get<Map<String, Object?>>(
          '/api/v1/guard/vehicles',
          decode: asJsonMap,
        ),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('a timeout becomes TimeoutFailure', () async {
      api.on(
        '/guard/vehicles',
        FakeResponse.failure(
          DioException.receiveTimeout(
            timeout: const Duration(seconds: 1),
            requestOptions: RequestOptions(path: '/api/v1/guard/vehicles'),
          ),
        ),
      );

      await expectLater(
        client.get<Map<String, Object?>>(
          '/api/v1/guard/vehicles',
          decode: asJsonMap,
        ),
        throwsA(isA<TimeoutFailure>()),
      );
    });
  });

  group('authentication header', () {
    test('attaches the bearer token to protected calls', () async {
      api.on('/guard/vehicles', const FakeResponse(Fixtures.guardVehicles));

      await client.get<Map<String, Object?>>(
        '/api/v1/guard/vehicles',
        decode: asJsonMap,
      );

      expect(api.lastRequest?.headers['Authorization'], 'Bearer test-token');
    });

    test('never sends a token to the sign-in endpoint', () async {
      api.on('/auth/login', const FakeResponse(Fixtures.loginGuard));

      await client.post<Map<String, Object?>>(
        '/api/v1/auth/login',
        decode: asJsonMap,
      );

      expect(api.lastRequest?.headers.containsKey('Authorization'), isFalse);
    });

    test('omits the header entirely when signed out', () async {
      client = buildClient();
      api.on('/guard/vehicles', const FakeResponse(Fixtures.guardVehicles));

      await client.get<Map<String, Object?>>(
        '/api/v1/guard/vehicles',
        decode: asJsonMap,
      );

      expect(api.lastRequest?.headers.containsKey('Authorization'), isFalse);
    });
  });
}
