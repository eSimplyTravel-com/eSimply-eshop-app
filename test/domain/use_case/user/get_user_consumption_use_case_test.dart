import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_consumption_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetUserConsumptionUseCase
/// Tests retrieval of user data consumption by ICCID
Future<void> main() async {
  await prepareTest();

  late GetUserConsumptionUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetUserConsumptionUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetUserConsumptionUseCase Tests", () {
    test("execute returns success with consumption data", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final UserConsumptionParam params =
          UserConsumptionParam(iccID: testIccID);

      final UserBundleConsumptionResponse mockConsumption =
          UserBundleConsumptionResponse(
        dataAllocated: 5000,
        dataUsed: 2500,
        dataRemaining: 2500,
        dataAllocatedDisplay: "5 GB",
        dataUsedDisplay: "2.5 GB",
        dataRemainingDisplay: "2.5 GB",
        planStatus: "active",
        expiryDate: "2024-12-31",
      );

      final Resource<UserBundleConsumptionResponse?> expectedResponse =
      Resource<UserBundleConsumptionResponse?>.success(mockConsumption, message: "Success");

      when(mockRepository.getUserConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<UserBundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.dataUsed, equals(2500));
      expect(result.data?.dataRemaining, equals(2500));
      expect(result.data?.planStatus, equals("active"));

      verify(mockRepository.getUserConsumption(iccID: testIccID)).called(1);
    });

    test("execute returns error when fetching consumption fails", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final UserConsumptionParam params =
          UserConsumptionParam(iccID: testIccID);

      final Resource<UserBundleConsumptionResponse?> expectedResponse =
      Resource<UserBundleConsumptionResponse?>.error("Failed to fetch consumption data");

      when(mockRepository.getUserConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<UserBundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch consumption data"));
      expect(result.data, isNull);

      verify(mockRepository.getUserConsumption(iccID: testIccID)).called(1);
    });

    test("execute handles zero consumption", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final UserConsumptionParam params =
          UserConsumptionParam(iccID: testIccID);

      final UserBundleConsumptionResponse mockConsumption =
          UserBundleConsumptionResponse(
        dataAllocated: 5000,
        dataUsed: 0,
        dataRemaining: 5000,
        dataAllocatedDisplay: "5 GB",
        dataUsedDisplay: "0 GB",
        dataRemainingDisplay: "5 GB",
        planStatus: "active",
      );

      final Resource<UserBundleConsumptionResponse?> expectedResponse =
      Resource<UserBundleConsumptionResponse?>.success(mockConsumption, message: null);

      when(mockRepository.getUserConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<UserBundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.dataUsed, equals(0));
      expect(result.data?.dataRemaining, equals(5000));
    });

    test("execute handles full consumption", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final UserConsumptionParam params =
          UserConsumptionParam(iccID: testIccID);

      final UserBundleConsumptionResponse mockConsumption =
          UserBundleConsumptionResponse(
        dataAllocated: 5000,
        dataUsed: 5000,
        dataRemaining: 0,
        dataAllocatedDisplay: "5 GB",
        dataUsedDisplay: "5 GB",
        dataRemainingDisplay: "0 GB",
        planStatus: "expired",
      );

      final Resource<UserBundleConsumptionResponse?> expectedResponse =
      Resource<UserBundleConsumptionResponse?>.success(mockConsumption, message: null);

      when(mockRepository.getUserConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<UserBundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.data?.dataUsed, equals(5000));
      expect(result.data?.dataRemaining, equals(0));
      expect(result.data?.planStatus, equals("expired"));
    });

    test("execute handles different ICCID formats", () async {
      // Arrange
      final List<String> testIccIDs = <String>[
        "89012345678901234567",
        "8901-2345-6789-0123-4567",
        "8901 2345 6789 0123 4567",
      ];

      for (final String iccID in testIccIDs) {
        final UserConsumptionParam params = UserConsumptionParam(iccID: iccID);

        final UserBundleConsumptionResponse mockConsumption =
            UserBundleConsumptionResponse(
          dataAllocated: 5000,
          dataUsed: 1000,
          dataRemaining: 4000,
        );

        final Resource<UserBundleConsumptionResponse?> expectedResponse =
        Resource<UserBundleConsumptionResponse?>.success(mockConsumption, message: null);

        when(mockRepository.getUserConsumption(iccID: iccID))
            .thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<UserBundleConsumptionResponse?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        verify(mockRepository.getUserConsumption(iccID: iccID)).called(1);
      }
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final UserConsumptionParam params =
          UserConsumptionParam(iccID: testIccID);

      when(mockRepository.getUserConsumption(iccID: testIccID))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.getUserConsumption(iccID: testIccID)).called(1);
    });

    test("execute handles empty ICCID", () async {
      // Arrange
      const String emptyIccID = "";
      final UserConsumptionParam params = UserConsumptionParam(iccID: emptyIccID);

      final Resource<UserBundleConsumptionResponse?> expectedResponse =
      Resource<UserBundleConsumptionResponse?>.error("Invalid ICCID");

      when(mockRepository.getUserConsumption(iccID: emptyIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<UserBundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid ICCID"));
    });

    test("execute returns null data when consumption not available", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      final UserConsumptionParam params =
          UserConsumptionParam(iccID: testIccID);

      final Resource<UserBundleConsumptionResponse?> expectedResponse =
      Resource<UserBundleConsumptionResponse?>.success(null, message: "No consumption data available");

      when(mockRepository.getUserConsumption(iccID: testIccID))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<UserBundleConsumptionResponse?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
