import "dart:async";

import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetUserNotificationsUseCase
    implements UseCase<Resource<List<UserNotificationModel>?>, NoParams> {
  GetUserNotificationsUseCase(this.repository);

  static List<UserNotificationModel> userNotificationList =
      <UserNotificationModel>[];
  final ApiUserRepository repository;

  static void resetCachedData() {
    userNotificationList = <UserNotificationModel>[];
  }

  @override
  FutureOr<Resource<List<UserNotificationModel>>> execute(
    NoParams? params,
  ) async {
    if (userNotificationList.isEmpty) {
      Resource<List<UserNotificationModel>> result =
          await repository.getUserNotifications(pageSize: 1, pageIndex: 10);
      if (result.resourceType == ResourceType.success) {
        userNotificationList = result.data ?? <UserNotificationModel>[];
      }
      return result;
    } else {
      return Resource<List<UserNotificationModel>>.success(
        userNotificationList,
        message: "",
      );
    }
  }
}
