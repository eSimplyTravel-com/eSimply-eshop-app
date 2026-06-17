import "package:esim_open_source/domain/data/response/bundles/bundle_exists_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_exists_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetBundleExistsUseCase
/// Tests checking if a bundle exists by code
Future<void> main() async {
  await prepareTest();

  late GetBundleExistsUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetBundleExistsUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetBundleExistsUseCase Tests", () {
    test("execute returns true when bundle exists", () async {
      // Arrange
      const String bundleCode = "EUROPE_5GB";
      final BundleExistsParams params = BundleExistsParams(code: bundleCode);

      final Resource<BundleExistsResponse?> expectedResponse =
          Resource<BundleExistsResponse?>.success(
        BundleExistsResponse(exists: true),
        message: "Bundle exists",
      );

      when(mockRepository.getBundleExists(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleExistsResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.exists, equals(true));
      expect(result.message, equals("Bundle exists"));

      verify(mockRepository.getBundleExists(code: bundleCode)).called(1);
    });

    test("execute returns false when bundle does not exist", () async {
      // Arrange
      const String bundleCode = "INVALID_BUNDLE";
      final BundleExistsParams params = BundleExistsParams(code: bundleCode);

      final Resource<BundleExistsResponse?> expectedResponse =
          Resource<BundleExistsResponse?>.success(
        BundleExistsResponse(exists: false),
        message: "Bundle does not exist",
      );

      when(mockRepository.getBundleExists(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleExistsResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.exists, equals(false));

      verify(mockRepository.getBundleExists(code: bundleCode)).called(1);
    });

    test("execute returns error when repository fails", () async {
      // Arrange
      const String bundleCode = "ERROR_BUNDLE";
      final BundleExistsParams params = BundleExistsParams(code: bundleCode);

      final Resource<BundleExistsResponse?> expectedResponse =
          Resource<BundleExistsResponse?>.error(
        "Failed to check bundle existence",
      );

      when(mockRepository.getBundleExists(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleExistsResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to check bundle existence"));
      expect(result.data, isNull);

      verify(mockRepository.getBundleExists(code: bundleCode)).called(1);
    });

    test("execute handles different bundle codes", () async {
      // Arrange
      final List<Map<String, dynamic>> testCases = <Map<String, dynamic>>[
        <String, dynamic>{"code": "EUROPE_5GB", "exists": true},
        <String, dynamic>{"code": "ASIA_10GB", "exists": true},
        <String, dynamic>{"code": "INVALID_CODE", "exists": false},
        <String, dynamic>{"code": "EXPIRED_BUNDLE", "exists": false},
      ];

      for (final Map<String, dynamic> testCase in testCases) {
        final String code = testCase["code"] as String;
        final bool exists = testCase["exists"] as bool;

        final BundleExistsParams params = BundleExistsParams(code: code);

        final Resource<BundleExistsResponse?> expectedResponse =
            Resource<BundleExistsResponse?>.success(
          BundleExistsResponse(exists: exists),
          message: null,
        );

        when(mockRepository.getBundleExists(code: code))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<BundleExistsResponse?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.exists, equals(exists));
        verify(mockRepository.getBundleExists(code: code)).called(1);
      }
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String bundleCode = "EXCEPTION_BUNDLE";
      final BundleExistsParams params = BundleExistsParams(code: bundleCode);

      when(mockRepository.getBundleExists(code: bundleCode))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getBundleExists(code: bundleCode)).called(1);
    });

    test("execute handles empty bundle code", () async {
      // Arrange
      const String emptyCode = "";
      final BundleExistsParams params = BundleExistsParams(code: emptyCode);

      final Resource<BundleExistsResponse?> expectedResponse =
          Resource<BundleExistsResponse?>.error("Invalid bundle code");

      when(mockRepository.getBundleExists(code: emptyCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleExistsResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid bundle code"));
    });

    test("execute returns null when data not available", () async {
      // Arrange
      const String bundleCode = "NULL_DATA_BUNDLE";
      final BundleExistsParams params = BundleExistsParams(code: bundleCode);

      final Resource<BundleExistsResponse?> expectedResponse =
          Resource<BundleExistsResponse?>.success(
        null,
        message: "No data available",
      );

      when(mockRepository.getBundleExists(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleExistsResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });

    test("execute handles bundle codes with special characters", () async {
      // Arrange
      const String specialCode = "BUNDLE_2024-Q1_SPECIAL";
      final BundleExistsParams params = BundleExistsParams(code: specialCode);

      final Resource<BundleExistsResponse?> expectedResponse =
          Resource<BundleExistsResponse?>.success(
        BundleExistsResponse(exists: true),
        message: null,
      );

      when(mockRepository.getBundleExists(code: specialCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleExistsResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.exists, equals(true));
    });
  });
}
