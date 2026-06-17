import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_order_history_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetOrderHistoryUseCase
/// Tests retrieval of user's complete order history
Future<void> main() async {
  await prepareTest();

  late GetOrderHistoryUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetOrderHistoryUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetOrderHistoryUseCase Tests", () {
    test("execute returns success with list of orders", () async {
      // Arrange
      final List<OrderHistoryResponseModel> mockOrders =
          <OrderHistoryResponseModel>[
        OrderHistoryResponseModel(
          orderNumber: "ORDER001",
          orderStatus: "completed",
          orderAmount: 29.99,
          orderCurrency: "USD",
          orderDate: "2024-01-15",
          orderType: "bundle_purchase",
          orderDisplayPrice: r"$29.99",
          quantity: 1,
        ),
        OrderHistoryResponseModel(
          orderNumber: "ORDER002",
          orderStatus: "pending",
          orderAmount: 49.99,
          orderCurrency: "USD",
          orderDate: "2024-01-20",
          orderType: "topup",
          orderDisplayPrice: r"$49.99",
          quantity: 1,
        ),
      ];

      final Resource<List<OrderHistoryResponseModel>?> expectedResponse =
      Resource<List<OrderHistoryResponseModel>?>.success(mockOrders, message: "Success");

      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<OrderHistoryResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(2));
      expect(result.data?[0].orderNumber, equals("ORDER001"));
      expect(result.data?[1].orderStatus, equals("pending"));

      verify(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .called(1);
    });

    test("execute returns error when fetching order history fails", () async {
      // Arrange
      final Resource<List<OrderHistoryResponseModel>?> expectedResponse =
      Resource<List<OrderHistoryResponseModel>?>.error("Failed to fetch order history");

      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<OrderHistoryResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch order history"));
      expect(result.data, isNull);

      verify(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .called(1);
    });

    test("execute returns empty list when no orders exist", () async {
      // Arrange
      final List<OrderHistoryResponseModel> emptyList =
          <OrderHistoryResponseModel>[];

      final Resource<List<OrderHistoryResponseModel>?> expectedResponse =
      Resource<List<OrderHistoryResponseModel>?>.success(emptyList, message: "No orders found");

      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<OrderHistoryResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data, isEmpty);

      verify(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .called(1);
    });

    test("execute handles large order history", () async {
      // Arrange
      final List<OrderHistoryResponseModel> largeList =
          List<OrderHistoryResponseModel>.generate(
        100,
        (int index) => OrderHistoryResponseModel(
          orderNumber: "ORDER${index.toString().padLeft(3, '0')}",
          orderStatus: index.isEven ? "completed" : "pending",
          orderAmount: 29.99 + index,
          orderCurrency: "USD",
          orderDate: "2024-01-01",
        ),
      );

      final Resource<List<OrderHistoryResponseModel>?> expectedResponse =
      Resource<List<OrderHistoryResponseModel>?>.success(largeList, message: null);

      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<OrderHistoryResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.length, equals(100));
      expect(result.data?.first.orderNumber, equals("ORDER000"));
      expect(result.data?.last.orderNumber, equals("ORDER099"));
    });

    test("execute handles orders with different statuses", () async {
      // Arrange
      final List<OrderHistoryResponseModel> mockOrders =
          <OrderHistoryResponseModel>[
        OrderHistoryResponseModel(
          orderNumber: "ORDER001",
          orderStatus: "completed",
        ),
        OrderHistoryResponseModel(
          orderNumber: "ORDER002",
          orderStatus: "pending",
        ),
        OrderHistoryResponseModel(
          orderNumber: "ORDER003",
          orderStatus: "cancelled",
        ),
        OrderHistoryResponseModel(
          orderNumber: "ORDER004",
          orderStatus: "refunded",
        ),
      ];

      final Resource<List<OrderHistoryResponseModel>?> expectedResponse =
      Resource<List<OrderHistoryResponseModel>?>.success(mockOrders, message: null);

      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<OrderHistoryResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.length, equals(4));
      final Set<String?>? statuses = result.data?.map((OrderHistoryResponseModel e) => e.orderStatus).toSet();
      expect(statuses?.contains("completed"), isTrue);
      expect(statuses?.contains("pending"), isTrue);
      expect(statuses?.contains("cancelled"), isTrue);
      expect(statuses?.contains("refunded"), isTrue);
    });

    test("execute handles repository exception", () async {
      // Arrange
      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(NoParams()),
        throwsException,
      );

      verify(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .called(1);
    });

    test("execute returns null data when no history available", () async {
      // Arrange
      final Resource<List<OrderHistoryResponseModel>?> expectedResponse =
      Resource<List<OrderHistoryResponseModel>?>.success(null, message: "No data available");

      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<OrderHistoryResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });

    test("execute with NoParams works consistently", () async {
      // Arrange
      final List<OrderHistoryResponseModel> mockOrders =
          <OrderHistoryResponseModel>[
        OrderHistoryResponseModel(orderNumber: "ORDER001"),
      ];

      final Resource<List<OrderHistoryResponseModel>?> expectedResponse =
      Resource<List<OrderHistoryResponseModel>?>.success(mockOrders, message: null);

      when(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<OrderHistoryResponseModel>?> result1 = await useCase.execute(NoParams());
      final Resource<List<OrderHistoryResponseModel>?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.data?.length, equals(1));
      expect(result2.data?.length, equals(1));
      verify(mockRepository.getOrderHistory(pageIndex: 1, pageSize: 1000))
          .called(2);
    });
  });
}
