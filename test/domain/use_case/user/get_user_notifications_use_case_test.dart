import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_notifications_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetUserNotificationsUseCase
/// Tests retrieval and caching of user notifications
Future<void> main() async {
  await prepareTest();

  late GetUserNotificationsUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = GetUserNotificationsUseCase(mockRepository);
    // Reset cached data before each test
    GetUserNotificationsUseCase.resetCachedData();
  });

  tearDown(() async {
    await tearDownTest();
    GetUserNotificationsUseCase.resetCachedData();
  });

  group("GetUserNotificationsUseCase Tests", () {
    test("execute returns success with list of notifications", () async {
      // Arrange
      final List<UserNotificationModel> mockNotifications =
          <UserNotificationModel>[
        UserNotificationModel(
          notificationId: 1,
          title: "New eSIM Activated",
          content: "Your eSIM has been successfully activated",
          status: false,
          datetime: "2024-01-15T10:00:00Z",
        ),
        UserNotificationModel(
          notificationId: 2,
          title: "Data Usage Alert",
          content: "You have used 80% of your data",
          status: false,
          datetime: "2024-01-14T15:30:00Z",
        ),
      ];

      final Resource<List<UserNotificationModel>> expectedResponse =
      Resource<List<UserNotificationModel>>.success(mockNotifications, message: "Success");

      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<UserNotificationModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(2));
      expect(result.data?[0].title, equals("New eSIM Activated"));

      verify(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .called(1);
    });

    test("execute returns cached data on subsequent calls", () async {
      // Arrange
      final List<UserNotificationModel> mockNotifications =
          <UserNotificationModel>[
        UserNotificationModel(
          notificationId: 1,
          title: "Test Notification",
        ),
      ];

      final Resource<List<UserNotificationModel>> expectedResponse =
      Resource<List<UserNotificationModel>>.success(mockNotifications, message: "Success");

      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<UserNotificationModel>> result1 = await useCase.execute(NoParams());
      final Resource<List<UserNotificationModel>> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.data?.length, equals(1));
      expect(result2.data?.length, equals(1));
      // Repository should only be called once due to caching
      verify(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .called(1);
    });

    test("execute returns error when repository fails", () async {
      // Arrange
      final Resource<List<UserNotificationModel>> expectedResponse =
      Resource<List<UserNotificationModel>>.error("Failed to fetch notifications");

      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<UserNotificationModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch notifications"));

      verify(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .called(1);
    });

    test("execute returns empty list when no notifications exist", () async {
      // Arrange
      final List<UserNotificationModel> emptyList = <UserNotificationModel>[];

      final Resource<List<UserNotificationModel>> expectedResponse =
      Resource<List<UserNotificationModel>>.success(emptyList, message: "No notifications");

      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<UserNotificationModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data, isEmpty);
    });

    test("execute handles read and unread notifications", () async {
      // Arrange
      final List<UserNotificationModel> mockNotifications =
          <UserNotificationModel>[
        UserNotificationModel(
          notificationId: 1,
          title: "Read Notification",
          status: true,
        ),
        UserNotificationModel(
          notificationId: 2,
          title: "Unread Notification",
          status: false,
        ),
      ];

      final Resource<List<UserNotificationModel>> expectedResponse =
      Resource<List<UserNotificationModel>>.success(mockNotifications, message: null);

      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<UserNotificationModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.length, equals(2));
      expect(result.data?[0].status, equals(true));
      expect(result.data?[1].status, equals(false));
    });

    test("resetCachedData clears cached notifications", () async {
      // Arrange
      final List<UserNotificationModel> mockNotifications =
          <UserNotificationModel>[
        UserNotificationModel(notificationId: 1, title: "Test"),
      ];

      final Resource<List<UserNotificationModel>> expectedResponse =
      Resource<List<UserNotificationModel>>.success(mockNotifications, message: null);

      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenAnswer((_) async => expectedResponse);

      // Act
      await useCase.execute(NoParams()); // First call - fetches from repo
      GetUserNotificationsUseCase.resetCachedData(); // Clear cache
      await useCase.execute(NoParams()); // Second call - should fetch again

      // Assert
      // Repository should be called twice because cache was cleared
      verify(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .called(2);
    });

    test("execute handles repository exception", () async {
      // Arrange
      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(NoParams()),
        throwsException,
      );

      verify(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .called(1);
    });

    test("execute with NoParams works consistently", () async {
      // Arrange
      final List<UserNotificationModel> mockNotifications =
          <UserNotificationModel>[
        UserNotificationModel(notificationId: 1),
      ];

      final Resource<List<UserNotificationModel>> expectedResponse =
      Resource<List<UserNotificationModel>>.success(mockNotifications, message: null);

      when(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<UserNotificationModel>> result1 = await useCase.execute(NoParams());
      final Resource<List<UserNotificationModel>> result2 = await useCase.execute(null); // Can also pass null

      // Assert
      expect(result1.data?.length, equals(1));
      expect(result2.data?.length, equals(1));
      verify(mockRepository.getUserNotifications(pageSize: 1, pageIndex: 10))
          .called(1); // Only called once due to caching
    });
  });
}
