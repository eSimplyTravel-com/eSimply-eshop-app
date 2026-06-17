import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/domain/util/pagination/pagination_params.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetUserNotificationsPaginationUseCase
    extends PaginatedUseCase<UserNotificationModel, NoParams> {
  GetUserNotificationsPaginationUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  PaginationService<UserNotificationModel> paginationService =
      PaginationService<UserNotificationModel>();

  @override
  Future<void> loadNextPage(
    NoParams params,
  ) async {
    log("notification: loadNextPage: start");
    if (state.isLoading || !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoading: true);
    paginationService.changeValue(paginatedData: state);

    try {
      Resource<List<UserNotificationModel>> resource =
          await repository.getUserNotifications(
        pageIndex: state.currentPage,
        pageSize: defaultPageSize,
      );
      // Resource<List<UserNotificationModel>> resource =
      //     await FakeData.fakeNotificationList(state.currentPage);

      switch (resource.resourceType) {
        case ResourceType.success:
          final PaginatedData<UserNotificationModel> newState = paginateList(
            resource.data ?? <UserNotificationModel>[],
            PaginationParams(
              page: state.currentPage,
              pageSize: defaultPageSize,
            ),
          );
          state = newState.copyWith(isLoading: false);
          paginationService.changeValue(paginatedData: state);
        case ResourceType.error:
          final PaginatedData<UserNotificationModel> newState = state.copyWith(
            isLoading: false,
            error: resource.error.toString(),
          );
          paginationService.changeValue(paginatedData: newState);
        case ResourceType.loading:
      }
    } on Error catch (e) {
      final PaginatedData<UserNotificationModel> newState = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      paginationService.changeValue(paginatedData: newState);
    }
  }

  @override
  Future<void> refreshData(
    NoParams params,
  ) async {
    refresh();
    return loadNextPage(params);
  }
}
