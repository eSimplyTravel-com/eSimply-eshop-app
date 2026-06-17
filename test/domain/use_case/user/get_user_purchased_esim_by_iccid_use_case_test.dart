import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_purchased_esim_by_iccid_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetUserPurchasedEsimByIccidUseCase
/// Tests retrieval of specific eSIM by ICCID
Future<void> main() async {
  await prepareTest();

  late GetUserPurchasedEsimByIccidUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetUserPurchasedEsimByIccidUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetUserPurchasedEsimByIccidUseCase Tests", () {
    test("execute returns success with eSIM details", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final GetUserPurchasedEsimByIccidParam params =
          GetUserPurchasedEsimByIccidParam(iccID: testIccID);

      final PurchaseEsimBundleResponseModel mockEsim =
          TestDataFactory.createPurchaseEsimBundle(
        iccid: testIccID,
        orderNumber: "ORDER123",
        orderStatus: "active",
      );

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: "Success");

      when(mockRepository.getMyEsimByIccID(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.iccid, equals(testIccID));
      expect(result.data?.orderNumber, equals("ORDER123"));

      verify(mockRepository.getMyEsimByIccID(iccID: testIccID)).called(1);
    });

    test("execute returns error when eSIM not found", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final GetUserPurchasedEsimByIccidParam params =
          GetUserPurchasedEsimByIccidParam(iccID: testIccID);

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.error("eSIM not found");

      when(mockRepository.getMyEsimByIccID(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("eSIM not found"));
      expect(result.data, isNull);

      verify(mockRepository.getMyEsimByIccID(iccID: testIccID)).called(1);
    });

    test("execute handles different ICCID formats", () async {
      // Arrange
      final List<String> testIccIDs = <String>[
        "89012345678901234567",
        "8901-2345-6789-0123-4567",
        "8901 2345 6789 0123 4567",
      ];

      for (final String iccID in testIccIDs) {
        final GetUserPurchasedEsimByIccidParam params =
            GetUserPurchasedEsimByIccidParam(iccID: iccID);

        final PurchaseEsimBundleResponseModel mockEsim =
            TestDataFactory.createPurchaseEsimBundle(
          iccid: iccID,
        );

        final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
        Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: null);

        when(mockRepository.getMyEsimByIccID(iccID: iccID))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<PurchaseEsimBundleResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.iccid, equals(iccID));
        verify(mockRepository.getMyEsimByIccID(iccID: iccID)).called(1);
      }
    });

    test("execute returns eSIM with active status", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final GetUserPurchasedEsimByIccidParam params =
          GetUserPurchasedEsimByIccidParam(iccID: testIccID);

      final PurchaseEsimBundleResponseModel mockEsim =
          TestDataFactory.createPurchaseEsimBundle(
        iccid: testIccID,
        orderStatus: "active",
      );

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: null);

      when(mockRepository.getMyEsimByIccID(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.orderStatus, equals("active"));
    });

    test("execute returns eSIM with expired status", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final GetUserPurchasedEsimByIccidParam params =
          GetUserPurchasedEsimByIccidParam(iccID: testIccID);

      final PurchaseEsimBundleResponseModel mockEsim =
          TestDataFactory.createPurchaseEsimBundle(
        iccid: testIccID,
        orderStatus: "expired",
      );

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(mockEsim, message: null);

      when(mockRepository.getMyEsimByIccID(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.orderStatus, equals("expired"));
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final GetUserPurchasedEsimByIccidParam params =
          GetUserPurchasedEsimByIccidParam(iccID: testIccID);

      when(mockRepository.getMyEsimByIccID(iccID: testIccID))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getMyEsimByIccID(iccID: testIccID)).called(1);
    });

    test("execute handles empty ICCID", () async {
      // Arrange
      const String emptyIccID = "";
      final GetUserPurchasedEsimByIccidParam params =
          GetUserPurchasedEsimByIccidParam(iccID: emptyIccID);

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.error("Invalid ICCID");

      when(mockRepository.getMyEsimByIccID(iccID: emptyIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid ICCID"));
    });

    test("execute returns null data when eSIM not available", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final GetUserPurchasedEsimByIccidParam params =
          GetUserPurchasedEsimByIccidParam(iccID: testIccID);

      final Resource<PurchaseEsimBundleResponseModel?> expectedResponse =
      Resource<PurchaseEsimBundleResponseModel?>.success(null, message: "No data available");

      when(mockRepository.getMyEsimByIccID(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<PurchaseEsimBundleResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
