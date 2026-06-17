import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/set_notifications_read_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for SetNotificationsReadUseCase
/// Tests marking notifications as read
Future<void> main() async {
  await prepareTest();

  late SetNotificationsReadUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = SetNotificationsReadUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("SetNotificationsReadUseCase Tests", () {
    test("execute returns success when notifications marked as read", () async {
      // Arrange
      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: "Notifications marked as read");

      when(mockRepository.setNotificationsRead())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.message, equals("Notifications marked as read"));

      verify(mockRepository.setNotificationsRead()).called(1);
    });

    test("execute returns error when operation fails", () async {
      // Arrange
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Failed to mark notifications as read");

      when(mockRepository.setNotificationsRead())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to mark notifications as read"));
      expect(result.data, isNull);

      verify(mockRepository.setNotificationsRead()).called(1);
    });

    test("execute handles repository exception", () async {
      // Arrange
      when(mockRepository.setNotificationsRead())
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(NoParams()),
        throwsException,
      );

      verify(mockRepository.setNotificationsRead()).called(1);
    });

    test("execute returns null data when no response", () async {
      // Arrange
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(null, message: "Success");

      when(mockRepository.setNotificationsRead())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });

    test("execute with NoParams works consistently", () async {
      // Arrange
      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: null);

      when(mockRepository.setNotificationsRead())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result1 = await useCase.execute(NoParams());
      final Resource<EmptyResponse?> result2 = await useCase.execute(null);

      // Assert
      expect(result1.resourceType, equals(ResourceType.success));
      expect(result2.resourceType, equals(ResourceType.success));
      verify(mockRepository.setNotificationsRead()).called(2);
    });

    test("execute can be called multiple times", () async {
      // Arrange
      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: null);

      when(mockRepository.setNotificationsRead())
          .thenAnswer((_) async => expectedResponse);

      // Act
      await useCase.execute(NoParams());
      await useCase.execute(NoParams());
      await useCase.execute(NoParams());

      // Assert
      verify(mockRepository.setNotificationsRead()).called(3);
    });

    test("execute handles no unread notifications scenario", () async {
      // Arrange
      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: "No unread notifications");

      when(mockRepository.setNotificationsRead())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.message, equals("No unread notifications"));
    });

    test("execute handles unauthorized error", () async {
      // Arrange
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Unauthorized");

      when(mockRepository.setNotificationsRead())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Unauthorized"));
    });
  });
}
