import "package:esim_open_source/domain/data/response/bundles/bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/use_case/bundles/get_bundle_consumption_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetBundleConsumptionUseCase
/// Tests retrieving bundle consumption data by ICCID
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetBundleConsumptionUseCase useCase;
  late MockApiBundlesRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiBundlesRepository>() as MockApiBundlesRepository;
    useCase = GetBundleConsumptionUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("GetBundleConsumptionUseCase Tests", () {
    test("execute returns success resource with consumption data", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final BundleConsumptionParams params = BundleConsumptionParams(
        iccID: testIccID,
      );

      final BundleConsumptionResponse mockConsumption =
          BundleConsumptionResponse(
        consumption: 2500.0,
        unit: "MB",
        displayConsumption: "2.5 GB / 5 GB",
      );

      final Resource<BundleConsumptionResponse?> expectedResponse =
      Resource<BundleConsumptionResponse?>.success(mockConsumption, message: "Success");

      when(mockRepository.getBundleConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.consumption, equals(2500.0));
      expect(result.data?.unit, equals("MB"));
      expect(result.data?.displayConsumption, equals("2.5 GB / 5 GB"));

      verify(mockRepository.getBundleConsumption(iccID: testIccID)).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final BundleConsumptionParams params = BundleConsumptionParams(
        iccID: testIccID,
      );

      final Resource<BundleConsumptionResponse?> expectedResponse =
      Resource<BundleConsumptionResponse?>.error("Failed to fetch consumption data");

      when(mockRepository.getBundleConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch consumption data"));
      expect(result.data, isNull);

      verify(mockRepository.getBundleConsumption(iccID: testIccID)).called(1);
    });

    test("execute returns null data when no consumption found", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final BundleConsumptionParams params = BundleConsumptionParams(
        iccID: testIccID,
      );

      final Resource<BundleConsumptionResponse?> expectedResponse =
      Resource<BundleConsumptionResponse?>.success(null, message: "No consumption data found");

      when(mockRepository.getBundleConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
      expect(result.message, equals("No consumption data found"));

      verify(mockRepository.getBundleConsumption(iccID: testIccID)).called(1);
    });

    test("execute handles different ICCID formats", () async {
      // Arrange
      final List<String> testIccIDs = <String>[
        "89012345678901234567",
        "8901-2345-6789-0123-4567",
        "8901 2345 6789 0123 4567",
      ];

      for (final String iccID in testIccIDs) {
        final BundleConsumptionParams params = BundleConsumptionParams(
          iccID: iccID,
        );

        final BundleConsumptionResponse mockConsumption =
            BundleConsumptionResponse(
          consumption: 1000.0,
          unit: "MB",
          displayConsumption: "1 GB / 5 GB",
        );

        final Resource<BundleConsumptionResponse?> expectedResponse =
        Resource<BundleConsumptionResponse?>.success(mockConsumption, message: null);

        when(mockRepository.getBundleConsumption(iccID: iccID))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<BundleConsumptionResponse?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        verify(mockRepository.getBundleConsumption(iccID: iccID)).called(1);
      }
    });

    test("execute handles zero consumption", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final BundleConsumptionParams params = BundleConsumptionParams(
        iccID: testIccID,
      );

      final BundleConsumptionResponse mockConsumption =
          BundleConsumptionResponse(
        consumption: 0.0,
        unit: "MB",
        displayConsumption: "0 GB / 5 GB",
      );

      final Resource<BundleConsumptionResponse?> expectedResponse =
      Resource<BundleConsumptionResponse?>.success(mockConsumption, message: null);

      when(mockRepository.getBundleConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.consumption, equals(0.0));
      expect(result.data?.unit, equals("MB"));
      expect(result.data?.displayConsumption, equals("0 GB / 5 GB"));
    });

    test("execute handles full consumption", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final BundleConsumptionParams params = BundleConsumptionParams(
        iccID: testIccID,
      );

      final BundleConsumptionResponse mockConsumption =
          BundleConsumptionResponse(
        consumption: 5000.0,
        unit: "MB",
        displayConsumption: "5 GB / 5 GB",
      );

      final Resource<BundleConsumptionResponse?> expectedResponse =
      Resource<BundleConsumptionResponse?>.success(mockConsumption, message: null);

      when(mockRepository.getBundleConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.consumption, equals(5000.0));
      expect(result.data?.unit, equals("MB"));
      expect(result.data?.displayConsumption, equals("5 GB / 5 GB"));
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final BundleConsumptionParams params = BundleConsumptionParams(
        iccID: testIccID,
      );

      when(mockRepository.getBundleConsumption(iccID: testIccID))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getBundleConsumption(iccID: testIccID)).called(1);
    });

    test("execute with empty ICCID", () async {
      // Arrange
      const String emptyIccID = "";
      final BundleConsumptionParams params = BundleConsumptionParams(
        iccID: emptyIccID,
      );

      final Resource<BundleConsumptionResponse?> expectedResponse =
      Resource<BundleConsumptionResponse?>.error("Invalid ICCID");

      when(mockRepository.getBundleConsumption(iccID: emptyIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      verify(mockRepository.getBundleConsumption(iccID: emptyIccID)).called(1);
    });
  });
}
