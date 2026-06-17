import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_order_by_id.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetOrderByIdUseCase
/// Tests retrieval of specific order by ID
Future<void> main() async {
  await prepareTest();

  late GetOrderByIdUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetOrderByIdUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetOrderByIdUseCase Tests", () {
    test("execute returns success with order details", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetOrderByIdParams params = GetOrderByIdParams(orderID: testOrderID);

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: testOrderID,
        orderStatus: "completed",
        orderAmount: 49.99,
        orderCurrency: "USD",
        orderDate: "2024-01-15",
        orderType: "bundle_purchase",
        orderDisplayPrice: r"$49.99",
        quantity: 1,
        companyName: "Monty Mobile",
      );

      final Resource<OrderHistoryResponseModel?> expectedResponse =
      Resource<OrderHistoryResponseModel?>.success(mockOrder, message: "Success");

      when(mockRepository.getOrderByID(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OrderHistoryResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.orderNumber, equals(testOrderID));
      expect(result.data?.orderStatus, equals("completed"));
      expect(result.data?.orderAmount, equals(49.99));

      verify(mockRepository.getOrderByID(orderID: testOrderID)).called(1);
    });

    test("execute returns error when order not found", () async {
      // Arrange
      const String testOrderID = "INVALID_ORDER";
      final GetOrderByIdParams params = GetOrderByIdParams(orderID: testOrderID);

      final Resource<OrderHistoryResponseModel?> expectedResponse =
      Resource<OrderHistoryResponseModel?>.error("Order not found");

      when(mockRepository.getOrderByID(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OrderHistoryResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Order not found"));
      expect(result.data, isNull);

      verify(mockRepository.getOrderByID(orderID: testOrderID)).called(1);
    });

    test("execute handles different order IDs", () async {
      // Arrange
      final List<String> orderIDs = <String>[
        "ORDER001",
        "ORDER002",
        "379d20c2-8c55-4b59-ad82-6cd06398ddd0",
      ];

      for (final String orderID in orderIDs) {
        final GetOrderByIdParams params = GetOrderByIdParams(orderID: orderID);

        final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
          orderNumber: orderID,
          orderStatus: "completed",
        );

        final Resource<OrderHistoryResponseModel?> expectedResponse =
        Resource<OrderHistoryResponseModel?>.success(mockOrder, message: null);

        when(mockRepository.getOrderByID(orderID: orderID))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<OrderHistoryResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.orderNumber, equals(orderID));
        verify(mockRepository.getOrderByID(orderID: orderID)).called(1);
      }
    });

    test("execute returns order with complete details", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetOrderByIdParams params = GetOrderByIdParams(orderID: testOrderID);

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: testOrderID,
        orderStatus: "completed",
        orderAmount: 99.99,
        orderCurrency: "USD",
        orderDate: "2024-01-15T10:30:00Z",
        orderType: "bundle_purchase",
        quantity: 2,
        companyName: "Monty Mobile",
        companyAddress: "123 Main St",
        companyPhone: "+1234567890",
        companyEmail: "support@example.com",
        orderDisplayPrice: r"$99.99",
      );

      final Resource<OrderHistoryResponseModel?> expectedResponse =
      Resource<OrderHistoryResponseModel?>.success(mockOrder, message: null);

      when(mockRepository.getOrderByID(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OrderHistoryResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.orderNumber, equals(testOrderID));
      expect(result.data?.orderAmount, equals(99.99));
      expect(result.data?.quantity, equals(2));
      expect(result.data?.companyName, equals("Monty Mobile"));
    });

    test("execute handles different order statuses", () async {
      // Arrange
      final List<String> statuses = <String>[
        "completed",
        "pending",
        "cancelled",
        "processing",
      ];

      for (final String status in statuses) {
        final GetOrderByIdParams params =
            GetOrderByIdParams(orderID: "ORDER_$status");

        final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
          orderNumber: "ORDER_$status",
          orderStatus: status,
        );

        final Resource<OrderHistoryResponseModel?> expectedResponse =
        Resource<OrderHistoryResponseModel?>.success(mockOrder, message: null);

        when(mockRepository.getOrderByID(orderID: "ORDER_$status"))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<OrderHistoryResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.data?.orderStatus, equals(status));
        verify(mockRepository.getOrderByID(orderID: "ORDER_$status")).called(1);
      }
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetOrderByIdParams params = GetOrderByIdParams(orderID: testOrderID);

      when(mockRepository.getOrderByID(orderID: testOrderID))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getOrderByID(orderID: testOrderID)).called(1);
    });

    test("execute handles empty order ID", () async {
      // Arrange
      const String emptyOrderID = "";
      final GetOrderByIdParams params = GetOrderByIdParams(orderID: emptyOrderID);

      final Resource<OrderHistoryResponseModel?> expectedResponse =
      Resource<OrderHistoryResponseModel?>.error("Invalid order ID");

      when(mockRepository.getOrderByID(orderID: emptyOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OrderHistoryResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid order ID"));
    });

    test("execute returns null data when order not available", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetOrderByIdParams params = GetOrderByIdParams(orderID: testOrderID);

      final Resource<OrderHistoryResponseModel?> expectedResponse =
      Resource<OrderHistoryResponseModel?>.success(null, message: "No data available");

      when(mockRepository.getOrderByID(orderID: testOrderID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OrderHistoryResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
