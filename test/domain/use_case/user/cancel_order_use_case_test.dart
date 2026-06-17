import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/cancel_order_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for CancelOrderUseCase
/// Tests order cancellation functionality
Future<void> main() async {
  await prepareTest();

  late CancelOrderUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = CancelOrderUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("CancelOrderUseCase Tests", () {
    test("execute returns success when order is cancelled", () async {
      // Arrange
      const String orderID = "order_123";
      final CancelOrderUseCaseParams params =
          CancelOrderUseCaseParams(orderID: orderID);

      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: "Order cancelled successfully");

      when(mockRepository.cancelOrder(orderID: orderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.message, equals("Order cancelled successfully"));

      verify(mockRepository.cancelOrder(orderID: orderID)).called(1);
    });

    test("execute returns error when order cancellation fails", () async {
      // Arrange
      const String orderID = "invalid_order";
      final CancelOrderUseCaseParams params =
          CancelOrderUseCaseParams(orderID: orderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Order not found");

      when(mockRepository.cancelOrder(orderID: orderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Order not found"));
      expect(result.data, isNull);

      verify(mockRepository.cancelOrder(orderID: orderID)).called(1);
    });

    test("execute handles different order IDs", () async {
      // Arrange
      final List<String> orderIDs = <String>[
        "order_001",
        "order_002",
        "order_003",
        "379d20c2-8c55-4b59-ad82-6cd06398ddd0",
      ];

      for (final String orderID in orderIDs) {
        final CancelOrderUseCaseParams params =
            CancelOrderUseCaseParams(orderID: orderID);

        final EmptyResponse mockResponse = EmptyResponse();
        final Resource<EmptyResponse?> expectedResponse =
        Resource<EmptyResponse?>.success(mockResponse, message: null);

        when(mockRepository.cancelOrder(orderID: orderID))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<EmptyResponse?> result = await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        verify(mockRepository.cancelOrder(orderID: orderID)).called(1);
      }
    });

    test("execute handles order already cancelled error", () async {
      // Arrange
      const String orderID = "order_cancelled";
      final CancelOrderUseCaseParams params =
          CancelOrderUseCaseParams(orderID: orderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Order already cancelled");

      when(mockRepository.cancelOrder(orderID: orderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Order already cancelled"));
    });

    test("execute handles order cannot be cancelled error", () async {
      // Arrange
      const String orderID = "order_active";
      final CancelOrderUseCaseParams params =
          CancelOrderUseCaseParams(orderID: orderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Order cannot be cancelled - eSIM already activated");

      when(mockRepository.cancelOrder(orderID: orderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(
        result.message,
        equals("Order cannot be cancelled - eSIM already activated"),
      );
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String orderID = "order_exception";
      final CancelOrderUseCaseParams params =
          CancelOrderUseCaseParams(orderID: orderID);

      when(mockRepository.cancelOrder(orderID: orderID))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.cancelOrder(orderID: orderID)).called(1);
    });

    test("execute handles empty order ID", () async {
      // Arrange
      const String emptyOrderID = "";
      final CancelOrderUseCaseParams params =
          CancelOrderUseCaseParams(orderID: emptyOrderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Invalid order ID");

      when(mockRepository.cancelOrder(orderID: emptyOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid order ID"));
    });

    test("execute handles null response data", () async {
      // Arrange
      const String orderID = "order_null";
      final CancelOrderUseCaseParams params =
          CancelOrderUseCaseParams(orderID: orderID);

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(null, message: "Cancelled");

      when(mockRepository.cancelOrder(orderID: orderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
