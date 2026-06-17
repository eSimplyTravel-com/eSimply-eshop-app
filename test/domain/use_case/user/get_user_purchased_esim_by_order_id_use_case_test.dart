import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_purchased_esim_by_order_id_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetUserPurchasedEsimByOrderIdUseCase
/// Tests retrieval of specific eSIM by order ID
Future<void> main() async {
  await prepareTest();

  late GetUserPurchasedEsimByOrderIdUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetUserPurchasedEsimByOrderIdUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetUserPurchasedEsimByOrderIdUseCase Tests", () {
    test("execute returns success with eSIM details", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetUserPurchasedEsimByOrderIdParam params =
          GetUserPurchasedEsimByOrderIdParam(orderID: testOrderID);

      final PurchaseEsimBundleResponseModel mockEsim =
          TestDataFactory.createPurchaseEsimBundle(
        orderNumber: testOrderID,
        orderStatus: "active",
      );

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: "Success");

      when(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.orderNumber, equals(testOrderID));
      expect(result.data?.orderStatus, equals("active"));

      verify(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).called(1);
    });

    test("execute returns error when eSIM not found", () async {
      // Arrange
      const String testOrderID = "INVALID_ORDER";
      final GetUserPurchasedEsimByOrderIdParam params =
          GetUserPurchasedEsimByOrderIdParam(orderID: testOrderID);

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.error("Order not found");

      when(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Order not found"));
      expect(result.data, isNull);

      verify(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).called(1);
    });

    test("execute handles bearer token for authenticated requests", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      const String bearerToken = "Bearer token_123";
      final GetUserPurchasedEsimByOrderIdParam params =
          GetUserPurchasedEsimByOrderIdParam(
        orderID: testOrderID,
        bearerToken: bearerToken,
      );

      final PurchaseEsimBundleResponseModel mockEsim =
          TestDataFactory.createPurchaseEsimBundle(
        orderNumber: testOrderID,
      );

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: null);

      when(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
        bearerToken: bearerToken,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
        bearerToken: bearerToken,
      ),).called(1);
    });

    test("execute handles different order ID formats", () async {
      // Arrange
      final List<String> testOrderIDs = <String>[
        "ORDER001",
        "379d20c2-8c55-4b59-ad82-6cd06398ddd0",
        "order_12345",
      ];

      for (final String orderID in testOrderIDs) {
        final GetUserPurchasedEsimByOrderIdParam params =
            GetUserPurchasedEsimByOrderIdParam(orderID: orderID);

        final PurchaseEsimBundleResponseModel mockEsim =
            TestDataFactory.createPurchaseEsimBundle(
          orderNumber: orderID,
        );

        final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
        Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: null);

        when(mockRepository.getMyEsimByOrder(
          orderID: orderID,
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<PurchaseEsimBundleResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.orderNumber, equals(orderID));
        verify(mockRepository.getMyEsimByOrder(
          orderID: orderID,
        ),).called(1);
      }
    });

    test("execute returns eSIM with complete details", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetUserPurchasedEsimByOrderIdParam params =
          GetUserPurchasedEsimByOrderIdParam(orderID: testOrderID);

      final PurchaseEsimBundleResponseModel mockEsim =
          TestDataFactory.createPurchaseEsimBundle(
        orderNumber: testOrderID,
        orderStatus: "active",
        iccid: "89012345678901234567",
        activationCode: "activation_code_123",
      );

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: null);

      when(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.orderNumber, equals(testOrderID));
      expect(result.data?.iccid, equals("89012345678901234567"));
      expect(result.data?.activationCode, equals("activation_code_123"));
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetUserPurchasedEsimByOrderIdParam params =
          GetUserPurchasedEsimByOrderIdParam(orderID: testOrderID);

      when(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).called(1);
    });

    test("execute handles empty order ID", () async {
      // Arrange
      const String emptyOrderID = "";
      final GetUserPurchasedEsimByOrderIdParam params =
          GetUserPurchasedEsimByOrderIdParam(orderID: emptyOrderID);

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.error("Invalid order ID");

      when(mockRepository.getMyEsimByOrder(
        orderID: emptyOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid order ID"));
    });

    test("execute returns null data when order not available", () async {
      // Arrange
      const String testOrderID = "ORDER123";
      final GetUserPurchasedEsimByOrderIdParam params =
          GetUserPurchasedEsimByOrderIdParam(orderID: testOrderID);

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(null, message: "No data available");

      when(mockRepository.getMyEsimByOrder(
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
