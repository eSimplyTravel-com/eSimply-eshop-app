import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_related_topup_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetRelatedTopupUseCase
/// Tests retrieval of related top-up bundles for a user's eSIM
Future<void> main() async {
  await prepareTest();

  late GetRelatedTopupUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetRelatedTopupUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetRelatedTopupUseCase Tests", () {
    test("execute returns success with list of top-up bundles", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "EUROPE_5GB";

      final GetRelatedTopupParam params = GetRelatedTopupParam(
        iccID: testIccID,
        bundleCode: bundleCode,
      );

      final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "TOPUP_1GB",
          displayTitle: "Top-up 1GB",
          price: 10,
        ),
        BundleResponseModel(
          bundleCode: "TOPUP_5GB",
          displayTitle: "Top-up 5GB",
          price: 40,
        ),
      ];

      final Resource<List<BundleResponseModel>?> expectedResponse =
      Resource<List<BundleResponseModel>?>.success(mockBundles, message: "Success");

      when(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(2));
      expect(result.data?[0].bundleCode, equals("TOPUP_1GB"));
      expect(result.data?[1].bundleCode, equals("TOPUP_5GB"));

      verify(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).called(1);
    });

    test("execute returns error when fetching top-ups fails", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "EUROPE_5GB";

      final GetRelatedTopupParam params = GetRelatedTopupParam(
        iccID: testIccID,
        bundleCode: bundleCode,
      );

      final Resource<List<BundleResponseModel>?> expectedResponse =
      Resource<List<BundleResponseModel>?>.error("Failed to fetch related top-ups");

      when(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch related top-ups"));
      expect(result.data, isNull);

      verify(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).called(1);
    });

    test("execute returns empty list when no top-ups available", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "EUROPE_5GB";

      final GetRelatedTopupParam params = GetRelatedTopupParam(
        iccID: testIccID,
        bundleCode: bundleCode,
      );

      final List<BundleResponseModel> emptyList = <BundleResponseModel>[];

      final Resource<List<BundleResponseModel>?> expectedResponse =
      Resource<List<BundleResponseModel>?>.success(emptyList, message: "No top-ups available");

      when(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data, isEmpty);

      verify(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).called(1);
    });

    test("execute handles multiple related top-up bundles", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "EUROPE_5GB";

      final GetRelatedTopupParam params = GetRelatedTopupParam(
        iccID: testIccID,
        bundleCode: bundleCode,
      );

      final List<BundleResponseModel> mockBundles =
          List<BundleResponseModel>.generate(
        5,
        (int index) => BundleResponseModel(
          bundleCode: "TOPUP_${index + 1}GB",
          displayTitle: "Top-up ${index + 1}GB",
          price: 10.0 * (index + 1),
        ),
      );

      final Resource<List<BundleResponseModel>?> expectedResponse =
      Resource<List<BundleResponseModel>?>.success(mockBundles, message: null);

      when(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.length, equals(5));
      expect(result.data?.first.bundleCode, equals("TOPUP_1GB"));
      expect(result.data?.last.bundleCode, equals("TOPUP_5GB"));
    });

    test("execute handles different bundle codes", () async {
      // Arrange
      const String testIccID = "89012345678901234567";

      final List<String> bundleCodes = <String>[
        "EUROPE_5GB",
        "ASIA_10GB",
        "GLOBAL_20GB",
      ];

      for (final String bundleCode in bundleCodes) {
        final GetRelatedTopupParam params = GetRelatedTopupParam(
          iccID: testIccID,
          bundleCode: bundleCode,
        );

        final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
          BundleResponseModel(bundleCode: "TOPUP_$bundleCode"),
        ];

        final Resource<List<BundleResponseModel>?> expectedResponse =
        Resource<List<BundleResponseModel>?>.success(mockBundles, message: null);

        when(mockRepository.getRelatedTopUp(
          iccID: testIccID,
          bundleCode: bundleCode,
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<List<BundleResponseModel>?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.length, equals(1));
        verify(mockRepository.getRelatedTopUp(
          iccID: testIccID,
          bundleCode: bundleCode,
        ),).called(1);
      }
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "EUROPE_5GB";

      final GetRelatedTopupParam params = GetRelatedTopupParam(
        iccID: testIccID,
        bundleCode: bundleCode,
      );

      when(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).called(1);
    });

    test("execute handles invalid ICCID", () async {
      // Arrange
      const String invalidIccID = "INVALID";
      const String bundleCode = "EUROPE_5GB";

      final GetRelatedTopupParam params = GetRelatedTopupParam(
        iccID: invalidIccID,
        bundleCode: bundleCode,
      );

      final Resource<List<BundleResponseModel>?> expectedResponse =
      Resource<List<BundleResponseModel>?>.error("Invalid ICCID");

      when(mockRepository.getRelatedTopUp(
        iccID: invalidIccID,
        bundleCode: bundleCode,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid ICCID"));
    });

    test("execute returns null data when top-ups not available", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "EUROPE_5GB";

      final GetRelatedTopupParam params = GetRelatedTopupParam(
        iccID: testIccID,
        bundleCode: bundleCode,
      );

      final Resource<List<BundleResponseModel>?> expectedResponse =
      Resource<List<BundleResponseModel>?>.success(null, message: "No data available");

      when(mockRepository.getRelatedTopUp(
        iccID: testIccID,
        bundleCode: bundleCode,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
