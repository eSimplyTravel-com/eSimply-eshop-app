import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_label_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetBundleLabelUseCase
/// Tests setting/getting bundle labels by ICCID
Future<void> main() async {
  await prepareTest();

  late GetBundleLabelUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetBundleLabelUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetBundleLabelUseCase Tests", () {
    test("execute returns success when label is set", () async {
      // Arrange
      const String testIccid = "89012345678901234567";
      const String testLabel = "My Work eSIM";

      final BundleLabelParams params = BundleLabelParams(
        iccid: testIccid,
        label: testLabel,
      );

      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: "Label set successfully");

      when(mockRepository.getBundleLabel(
        iccid: testIccid,
        label: testLabel,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);

      verify(mockRepository.getBundleLabel(
        iccid: testIccid,
        label: testLabel,
      ),).called(1);
    });

    test("execute returns error when operation fails", () async {
      // Arrange
      const String testIccid = "89012345678901234567";
      const String testLabel = "My eSIM";

      final BundleLabelParams params = BundleLabelParams(
        iccid: testIccid,
        label: testLabel,
      );

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Failed to set label");

      when(mockRepository.getBundleLabel(
        iccid: testIccid,
        label: testLabel,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to set label"));
    });

    test("execute handles different labels", () async {
      // Arrange
      const String testIccid = "89012345678901234567";
      final List<String> labels = <String>[
        "Work eSIM",
        "Travel eSIM",
        "Personal",
        "USA Trip 2024",
      ];

      for (final String label in labels) {
        final BundleLabelParams params = BundleLabelParams(
          iccid: testIccid,
          label: label,
        );

        final EmptyResponse mockResponse = EmptyResponse();
        final Resource<EmptyResponse?> expectedResponse =
        Resource<EmptyResponse?>.success(mockResponse, message: null);

        when(mockRepository.getBundleLabel(
          iccid: testIccid,
          label: label,
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<EmptyResponse?> result = await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        verify(mockRepository.getBundleLabel(
          iccid: testIccid,
          label: label,
        ),).called(1);
      }
    });

    test("execute handles empty label", () async {
      // Arrange
      const String testIccid = "89012345678901234567";
      const String emptyLabel = "";

      final BundleLabelParams params = BundleLabelParams(
        iccid: testIccid,
        label: emptyLabel,
      );

      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: null);

      when(mockRepository.getBundleLabel(
        iccid: testIccid,
        label: emptyLabel,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
    });

    test("execute handles invalid ICCID", () async {
      // Arrange
      const String invalidIccid = "INVALID";
      const String testLabel = "Label";

      final BundleLabelParams params = BundleLabelParams(
        iccid: invalidIccid,
        label: testLabel,
      );

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Invalid ICCID");

      when(mockRepository.getBundleLabel(
        iccid: invalidIccid,
        label: testLabel,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid ICCID"));
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testIccid = "89012345678901234567";
      const String testLabel = "Label";

      final BundleLabelParams params = BundleLabelParams(
        iccid: testIccid,
        label: testLabel,
      );

      when(mockRepository.getBundleLabel(
        iccid: testIccid,
        label: testLabel,
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );
    });

    test("execute handles long labels", () async {
      // Arrange
      const String testIccid = "89012345678901234567";
      const String longLabel = "This is a very long label for my eSIM bundle";

      final BundleLabelParams params = BundleLabelParams(
        iccid: testIccid,
        label: longLabel,
      );

      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: null);

      when(mockRepository.getBundleLabel(
        iccid: testIccid,
        label: longLabel,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
    });
  });
}
