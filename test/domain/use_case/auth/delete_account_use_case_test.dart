import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/delete_account_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for DeleteAccountUseCase
/// Tests the account deletion functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late DeleteAccountUseCase useCase;
  late MockApiAuthRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    useCase = DeleteAccountUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("DeleteAccountUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final EmptyResponse emptyResponse = EmptyResponse();

      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createSuccessResource<EmptyResponse>(
        data: emptyResponse,
        message: "Account deleted successfully",
      );

      when(mockRepository.deleteAccount()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.message, equals("Account deleted successfully"));

      verify(mockRepository.deleteAccount()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Failed to delete account",
      );

      when(mockRepository.deleteAccount()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to delete account"));

      verify(mockRepository.deleteAccount()).called(1);
    });

    test("execute returns error for unauthorized access", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Unauthorized",
        code: 401,
      );

      when(mockRepository.deleteAccount()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Unauthorized"));
      expect(result.error?.errorCode, equals(401));
    });

    test("execute returns error for forbidden action", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Cannot delete account with active subscriptions",
        code: 403,
      );

      when(mockRepository.deleteAccount()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Cannot delete account with active subscriptions"));
      expect(result.error?.errorCode, equals(403));
    });

    test("execute returns error for network error", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Network error",
        code: 500,
      );

      when(mockRepository.deleteAccount()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Network error"));
      expect(result.error?.errorCode, equals(500));
    });

    test("execute works with null params", () async {
      // Arrange
      final EmptyResponse emptyResponse = EmptyResponse();

      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createSuccessResource<EmptyResponse>(
        data: emptyResponse,
      );

      when(mockRepository.deleteAccount()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.deleteAccount()).called(1);
    });
  });
}
