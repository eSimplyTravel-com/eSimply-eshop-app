import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_purchased_esims_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetUserPurchasedEsimsUseCase
/// Tests retrieving user's purchased eSIMs
Future<void> main() async {
  await prepareTest();

  late GetUserPurchasedEsimsUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetUserPurchasedEsimsUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetUserPurchasedEsimsUseCase Tests", () {
    test("execute returns success with list of eSIMs", () async {
      // Arrange
      final List<PurchaseEsimBundleResponseModel> mockEsims =
          <PurchaseEsimBundleResponseModel>[
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER001",
          orderStatus: "active",
        ),
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER002",
          orderStatus: "expired",
        ),
      ];

      final Resource<List<PurchaseEsimBundleResponseModel>?> expectedResponse =
      Resource<List<PurchaseEsimBundleResponseModel>?>.success(mockEsims, message: "Success");

      when(mockRepository.getMyEsims()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<PurchaseEsimBundleResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(2));

      verify(mockRepository.getMyEsims()).called(1);
    });

    test("execute returns error when repository fails", () async {
      // Arrange
      final Resource<List<PurchaseEsimBundleResponseModel>?> expectedResponse =
      Resource<List<PurchaseEsimBundleResponseModel>?>.error("Failed to fetch eSIMs");

      when(mockRepository.getMyEsims()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<PurchaseEsimBundleResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch eSIMs"));
      expect(result.data, isNull);

      verify(mockRepository.getMyEsims()).called(1);
    });

    test("execute returns empty list when no eSIMs purchased", () async {
      // Arrange
      final List<PurchaseEsimBundleResponseModel> emptyList =
          <PurchaseEsimBundleResponseModel>[];

      final Resource<List<PurchaseEsimBundleResponseModel>?> expectedResponse =
      Resource<List<PurchaseEsimBundleResponseModel>?>.success(emptyList, message: "No eSIMs found");

      when(mockRepository.getMyEsims()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<PurchaseEsimBundleResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data, isEmpty);

      verify(mockRepository.getMyEsims()).called(1);
    });

    test("execute returns null when data not available", () async {
      // Arrange
      final Resource<List<PurchaseEsimBundleResponseModel>?> expectedResponse =
      Resource<List<PurchaseEsimBundleResponseModel>?>.success(null, message: null);

      when(mockRepository.getMyEsims()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<PurchaseEsimBundleResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });

    test("execute handles repository exception", () async {
      // Arrange
      when(mockRepository.getMyEsims()).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(NoParams()),
        throwsException,
      );

      verify(mockRepository.getMyEsims()).called(1);
    });

    test("execute with multiple active eSIMs", () async {
      // Arrange
      final List<PurchaseEsimBundleResponseModel> mockEsims =
          <PurchaseEsimBundleResponseModel>[
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER001",
          orderStatus: "active",
        ),
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER002",
          orderStatus: "active",
        ),
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER003",
          orderStatus: "active",
        ),
      ];

      final Resource<List<PurchaseEsimBundleResponseModel>?> expectedResponse =
      Resource<List<PurchaseEsimBundleResponseModel>?>.success(mockEsims, message: null);

      when(mockRepository.getMyEsims()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<PurchaseEsimBundleResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.length, equals(3));
      expect(result.data?.every((PurchaseEsimBundleResponseModel e) => e.orderStatus == "active"), isTrue);
    });

    test("execute handles mixed status eSIMs", () async {
      // Arrange
      final List<PurchaseEsimBundleResponseModel> mockEsims =
          <PurchaseEsimBundleResponseModel>[
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER001",
          orderStatus: "active",
        ),
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER002",
          orderStatus: "expired",
        ),
        TestDataFactory.createPurchaseEsimBundle(
          orderNumber: "ORDER003",
          orderStatus: "pending",
        ),
      ];

      final Resource<List<PurchaseEsimBundleResponseModel>?> expectedResponse =
      Resource<List<PurchaseEsimBundleResponseModel>?>.success(mockEsims, message: null);

      when(mockRepository.getMyEsims()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<PurchaseEsimBundleResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.length, equals(3));
      final Set<String?>? statuses = result.data?.map((PurchaseEsimBundleResponseModel e) => e.orderStatus).toSet();
      expect(statuses?.contains("active"), isTrue);
      expect(statuses?.contains("expired"), isTrue);
      expect(statuses?.contains("pending"), isTrue);
    });

    test("execute with NoParams works consistently", () async {
      // Arrange
      final List<PurchaseEsimBundleResponseModel> mockEsims =
          <PurchaseEsimBundleResponseModel>[
        TestDataFactory.createPurchaseEsimBundle(orderNumber: "ORDER001"),
      ];

      final Resource<List<PurchaseEsimBundleResponseModel>?> expectedResponse =
      Resource<List<PurchaseEsimBundleResponseModel>?>.success(mockEsims, message: null);

      when(mockRepository.getMyEsims()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<PurchaseEsimBundleResponseModel>?> result1 = await useCase.execute(NoParams());
      final Resource<List<PurchaseEsimBundleResponseModel>?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.data?.length, equals(1));
      expect(result2.data?.length, equals(1));
      verify(mockRepository.getMyEsims()).called(2);
    });
  });
}
