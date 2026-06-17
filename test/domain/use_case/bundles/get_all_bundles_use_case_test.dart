import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/bundles/get_all_bundles_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetAllBundlesUseCase
/// Tests retrieving all available bundles from the repository
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetAllBundlesUseCase useCase;
  late MockApiBundlesRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiBundlesRepository>() as MockApiBundlesRepository;
    useCase = GetAllBundlesUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("GetAllBundlesUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "BUNDLE001",
          displayTitle: "Europe 5GB",
          price: 29.99,
          validity: 30,
        ),
        BundleResponseModel(
          bundleCode: "BUNDLE002",
          displayTitle: "Asia 10GB",
          price: 49.99,
          validity: 30,
        ),
      ];

      final Resource<List<BundleResponseModel>> expectedResponse =
      Resource<List<BundleResponseModel>>.success(mockBundles, message: "Success");

      when(mockRepository.getAllBundles())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(2));
      expect(result.data?[0].bundleCode, equals("BUNDLE001"));
      expect(result.data?[1].bundleCode, equals("BUNDLE002"));

      verify(mockRepository.getAllBundles()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final Resource<List<BundleResponseModel>> expectedResponse =
      Resource<List<BundleResponseModel>>.error("Failed to fetch bundles");

      when(mockRepository.getAllBundles())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch bundles"));
      expect(result.data, isNull);

      verify(mockRepository.getAllBundles()).called(1);
    });

    test("execute returns empty list when no bundles available", () async {
      // Arrange
      final List<BundleResponseModel> emptyBundles = <BundleResponseModel>[];

      final Resource<List<BundleResponseModel>> expectedResponse =
      Resource<List<BundleResponseModel>>.success(emptyBundles, message: "No bundles found");

      when(mockRepository.getAllBundles())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data, isEmpty);

      verify(mockRepository.getAllBundles()).called(1);
    });

    test("execute handles repository exception gracefully", () async {
      // Arrange
      when(mockRepository.getAllBundles())
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(NoParams()),
        throwsException,
      );

      verify(mockRepository.getAllBundles()).called(1);
    });

    test("execute returns loading resource", () async {
      // Arrange
      final Resource<List<BundleResponseModel>> expectedResponse =
      Resource<List<BundleResponseModel>>.loading();

      when(mockRepository.getAllBundles())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.loading));
    });

    test("execute with NoParams works correctly", () async {
      // Arrange
      final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "TEST"),
      ];

      final Resource<List<BundleResponseModel>> expectedResponse =
      Resource<List<BundleResponseModel>>.success(mockBundles, message: null);

      when(mockRepository.getAllBundles())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>> result1 =
          await useCase.execute(NoParams());
      final Resource<List<BundleResponseModel>> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.data?.length, equals(1));
      expect(result2.data?.length, equals(1));
      verify(mockRepository.getAllBundles()).called(2);
    });

    test("execute returns bundles with all properties", () async {
      // Arrange
      final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "PREMIUM001",
          displayTitle: "Premium Europe",
          displaySubtitle: "Unlimited Data",
          bundleName: "premium_europe_unlimited",
          bundleMarketingName: "Premium Europe Package",
          price: 99.99,
          priceDisplay: r"$99.99",
          validity: 30,
          validityLabel: "days",
          currencyCode: "USD",
          unlimited: true,
          gprsLimitDisplay: "Unlimited",
        ),
      ];

      final Resource<List<BundleResponseModel>> expectedResponse =
      Resource<List<BundleResponseModel>>.success(mockBundles, message: "Success");

      when(mockRepository.getAllBundles())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?[0].bundleCode, equals("PREMIUM001"));
      expect(result.data?[0].displayTitle, equals("Premium Europe"));
      expect(result.data?[0].price, equals(99.99));
      expect(result.data?[0].unlimited, equals(true));
    });

    test("execute handles multiple bundles with different properties", () async {
      // Arrange
      final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "BASIC",
          displayTitle: "Basic Plan",
          price: 9.99,
          unlimited: false,
        ),
        BundleResponseModel(
          bundleCode: "PREMIUM",
          displayTitle: "Premium Plan",
          price: 49.99,
          unlimited: true,
        ),
        BundleResponseModel(
          bundleCode: "ENTERPRISE",
          displayTitle: "Enterprise Plan",
          price: 199.99,
          unlimited: true,
        ),
      ];

      final Resource<List<BundleResponseModel>> expectedResponse =
      Resource<List<BundleResponseModel>>.success(mockBundles, message: "Success");

      when(mockRepository.getAllBundles())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<BundleResponseModel>> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.length, equals(3));
      expect(result.data?[0].price, equals(9.99));
      expect(result.data?[1].unlimited, equals(true));
      expect(result.data?[2].bundleCode, equals("ENTERPRISE"));
    });
  });
}
