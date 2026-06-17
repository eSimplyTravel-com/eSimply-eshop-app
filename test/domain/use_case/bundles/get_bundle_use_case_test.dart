import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/use_case/bundles/get_bundle_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetBundleUseCase
/// Tests retrieving a specific bundle by code
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetBundleUseCase useCase;
  late MockApiBundlesRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiBundlesRepository>() as MockApiBundlesRepository;
    useCase = GetBundleUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("GetBundleUseCase Tests", () {
    test("execute returns success resource with bundle data", () async {
      // Arrange
      const String bundleCode = "EUROPE_5GB";
      final BundleParams params = BundleParams(code: bundleCode);

      final BundleResponseModel mockBundle = BundleResponseModel(
        bundleCode: bundleCode,
        displayTitle: "Europe 5GB Plan",
        price: 29.99,
        validity: 30,
        currencyCode: "USD",
      );

      final Resource<BundleResponseModel?> expectedResponse =
      Resource<BundleResponseModel?>.success(mockBundle, message: "Success");

      when(mockRepository.getBundle(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.bundleCode, equals(bundleCode));
      expect(result.data?.displayTitle, equals("Europe 5GB Plan"));
      expect(result.data?.price, equals(29.99));

      verify(mockRepository.getBundle(code: bundleCode)).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      const String bundleCode = "INVALID_CODE";
      final BundleParams params = BundleParams(code: bundleCode);

      final Resource<BundleResponseModel?> expectedResponse =
      Resource<BundleResponseModel?>.error("Bundle not found");

      when(mockRepository.getBundle(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Bundle not found"));
      expect(result.data, isNull);

      verify(mockRepository.getBundle(code: bundleCode)).called(1);
    });

    test("execute returns null data when bundle not found", () async {
      // Arrange
      const String bundleCode = "NON_EXISTENT";
      final BundleParams params = BundleParams(code: bundleCode);

      final Resource<BundleResponseModel?> expectedResponse =
      Resource<BundleResponseModel?>.success(null, message: "Bundle not found");

      when(mockRepository.getBundle(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);

      verify(mockRepository.getBundle(code: bundleCode)).called(1);
    });

    test("execute handles different bundle codes", () async {
      // Arrange
      final List<String> bundleCodes = <String>[
        "EUROPE_5GB",
        "ASIA_10GB",
        "GLOBAL_UNLIMITED",
        "CRUISE_7DAY",
      ];

      for (final String code in bundleCodes) {
        final BundleParams params = BundleParams(code: code);

        final BundleResponseModel mockBundle = BundleResponseModel(
          bundleCode: code,
          displayTitle: "$code Plan",
        );

        final Resource<BundleResponseModel?> expectedResponse =
        Resource<BundleResponseModel?>.success(mockBundle, message: null);

        when(mockRepository.getBundle(code: code))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<BundleResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.bundleCode, equals(code));
        verify(mockRepository.getBundle(code: code)).called(1);
      }
    });

    test("execute returns bundle with all properties populated", () async {
      // Arrange
      const String bundleCode = "PREMIUM_PLAN";
      final BundleParams params = BundleParams(code: bundleCode);

      final BundleResponseModel mockBundle = BundleResponseModel(
        bundleCode: bundleCode,
        displayTitle: "Premium Plan",
        displaySubtitle: "Unlimited Data",
        bundleName: "premium_unlimited",
        bundleMarketingName: "Premium Unlimited Package",
        price: 99.99,
        priceDisplay: r"$99.99",
        validity: 30,
        validityLabel: "days",
        currencyCode: "USD",
        unlimited: true,
        gprsLimitDisplay: "Unlimited",
        countCountries: 150,
      );

      final Resource<BundleResponseModel?> expectedResponse =
      Resource<BundleResponseModel?>.success(mockBundle, message: "Success");

      when(mockRepository.getBundle(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.data?.bundleCode, equals(bundleCode));
      expect(result.data?.displayTitle, equals("Premium Plan"));
      expect(result.data?.price, equals(99.99));
      expect(result.data?.unlimited, equals(true));
      expect(result.data?.countCountries, equals(150));
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String bundleCode = "ERROR_BUNDLE";
      final BundleParams params = BundleParams(code: bundleCode);

      when(mockRepository.getBundle(code: bundleCode))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getBundle(code: bundleCode)).called(1);
    });

    test("execute with empty bundle code", () async {
      // Arrange
      const String emptyCode = "";
      final BundleParams params = BundleParams(code: emptyCode);

      final Resource<BundleResponseModel?> expectedResponse =
      Resource<BundleResponseModel?>.error("Invalid bundle code");

      when(mockRepository.getBundle(code: emptyCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      verify(mockRepository.getBundle(code: emptyCode)).called(1);
    });

    test("execute handles special characters in bundle code", () async {
      // Arrange
      const String bundleCode = "BUNDLE_2024-Q1";
      final BundleParams params = BundleParams(code: bundleCode);

      final BundleResponseModel mockBundle = BundleResponseModel(
        bundleCode: bundleCode,
        displayTitle: "Q1 2024 Special",
      );

      final Resource<BundleResponseModel?> expectedResponse =
      Resource<BundleResponseModel?>.success(mockBundle, message: null);

      when(mockRepository.getBundle(code: bundleCode))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.bundleCode, equals(bundleCode));
    });
  });
}
