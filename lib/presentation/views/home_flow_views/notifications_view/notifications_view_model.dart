import "dart:async";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_notifications_pagination_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_notifications_use_case.dart";
import "package:esim_open_source/domain/use_case/user/set_notifications_read_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/presentation/shared/redirections_helper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";

class NotificationsViewModel extends BaseModel {
  //#region UseCases

  GetUserNotificationsPaginationUseCase getUserNotificationsPaginationUseCase =
      GetUserNotificationsPaginationUseCase(locator<ApiUserRepository>());

  final SetNotificationsReadUseCase setNotificationsReadUseCase =
      SetNotificationsReadUseCase(locator<ApiUserRepository>());

  //#endregion

  //#region Variables
  PaginationService<UserNotificationModel> get notificationPaginationService =>
      getUserNotificationsPaginationUseCase.paginationService;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    // super.onViewModelReady();
    unawaited(setNotificationsRead());
    // unawaited(getNotifications());
    GetUserNotificationsUseCase.resetCachedData();
  }

  @override
  void onDispose() {
    getUserNotificationsPaginationUseCase.dispose();
    super.onDispose();
  }

  void onNotificationCLicked(UserNotificationModel notification) {
    RedirectionCategoryType redirectionCategoryType =
        RedirectionsHelper.fromNotificationValue(
      categoryID: notification.category ?? "0",
      iccID: notification.iccid,
    );
    if (redirectionCategoryType is ConsumptionBundleDetail) {
      redirectionsHandlerService.notificationInboxRedirections(
        iccID: notification.iccid ?? "",
        category: notification.category ?? "",
        isUnlimitedData: false,
      );
    }
  }

  //#endregion

  //#region Apis
  Future<void> setNotificationsRead() async {
    setNotificationsReadUseCase.execute(NoParams());
  }

  Future<void> getNotifications() async {
    await getUserNotificationsPaginationUseCase.loadNextPage(NoParams());
  }

  Future<void> refreshNotifications() async {
    await getUserNotificationsPaginationUseCase.refreshData(NoParams());
  }

//#endregion
}
