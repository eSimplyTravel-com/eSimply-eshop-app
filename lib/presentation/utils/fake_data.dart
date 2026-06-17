import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/util/resource.dart";

class FakeData {
  static FutureOr<Resource<List<UserNotificationModel>>> fakeNotificationList(
    int pageIndex,
  ) async {
    log("fakeNotificationList: pageIndex: $pageIndex");
    if (pageIndex == 20) {
      return Resource<List<UserNotificationModel>>.success(
        <UserNotificationModel>[],
        message: "",
      );
    }

    List<UserNotificationModel> list = List<UserNotificationModel>.generate(
      100,
      (int i) => UserNotificationModel(
        content: "Notification $i",
        datetime: "2025-02-02 10:00:00",
      ),
    );

    int start = (pageIndex - 1) * 10;
    int end = (start + 10).clamp(0, list.length);
    await Future<void>.delayed(const Duration(seconds: 2));
    return Resource<List<UserNotificationModel>>.success(
      list.sublist(start, end),
      message: "",
    );
  }
}
