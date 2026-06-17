import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/resend_order_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for ResendOrderOtpUseCase
/// Tests OTP resend functionality for orders
Future<void> main() async {
  await prepareTest();

  late ResendOrderOtpUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = ResendOrderOtpUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("ResendOrderOtpUseCase Tests", () {
    test("execute returns success when OTP is resent", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final ResendOrderOtpParam params =
          ResendOrderOtpParam(orderID: testOrderID);

      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: "OTP sent successfully");

      when(mockRepository.resendOrderOtp(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.message, equals("OTP sent successfully"));

      verify(mockRepository.resendOrderOtp(orderID: testOrderID)).called(1);
    });

    test("execute returns error when order not found", () async {
      // Arrange
      const String invalidOrderID = "INVALID_ORDER";
      final ResendOrderOtpParam params =
          ResendOrderOtpParam(orderID: invalidOrderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Order not found");

      when(mockRepository.resendOrderOtp(orderID: invalidOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Order not found"));
      expect(result.data, isNull);

      verify(mockRepository.resendOrderOtp(orderID: invalidOrderID)).called(1);
    });

    test("execute handles different order IDs", () async {
      // Arrange
      final List<String> orderIDs = <String>[
        "ORDER001",
        "ORDER002",
        "379d20c2-8c55-4b59-ad82-6cd06398ddd0",
      ];

      for (final String orderID in orderIDs) {
        final ResendOrderOtpParam params =
            ResendOrderOtpParam(orderID: orderID);

        final EmptyResponse mockResponse = EmptyResponse();
        final Resource<EmptyResponse?> expectedResponse =
        Resource<EmptyResponse?>.success(mockResponse, message: null);

        when(mockRepository.resendOrderOtp(orderID: orderID))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<EmptyResponse?> result = await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        verify(mockRepository.resendOrderOtp(orderID: orderID)).called(1);
      }
    });

    test("execute handles rate limit error", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final ResendOrderOtpParam params =
          ResendOrderOtpParam(orderID: testOrderID);

      final Resource<EmptyResponse?> expectedResponse = Resource<EmptyResponse?>.error(
        "Too many requests. Please wait before requesting another OTP",
      );

      when(mockRepository.resendOrderOtp(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(
        result.message,
        equals("Too many requests. Please wait before requesting another OTP"),
      );
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final ResendOrderOtpParam params =
          ResendOrderOtpParam(orderID: testOrderID);

      when(mockRepository.resendOrderOtp(orderID: testOrderID))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.resendOrderOtp(orderID: testOrderID)).called(1);
    });

    test("execute handles empty order ID", () async {
      // Arrange
      const String emptyOrderID = "";
      final ResendOrderOtpParam params =
          ResendOrderOtpParam(orderID: emptyOrderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Invalid order ID");

      when(mockRepository.resendOrderOtp(orderID: emptyOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid order ID"));
    });

    test("execute handles order already verified", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final ResendOrderOtpParam params =
          ResendOrderOtpParam(orderID: testOrderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Order already verified");

      when(mockRepository.resendOrderOtp(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Order already verified"));
    });

    test("execute returns null data on successful resend", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final ResendOrderOtpParam params =
          ResendOrderOtpParam(orderID: testOrderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(null, message: "OTP sent");

      when(mockRepository.resendOrderOtp(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
