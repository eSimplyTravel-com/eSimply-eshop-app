import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/domain/util/pagination/pagination_params.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetOrderHistoryPaginationUseCase
    extends PaginatedUseCase<OrderHistoryResponseModel, NoParams> {
  GetOrderHistoryPaginationUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  PaginationService<OrderHistoryResponseModel> paginationService =
      PaginationService<OrderHistoryResponseModel>();

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
      Resource<List<OrderHistoryResponseModel>?> resource =
          await repository.getOrderHistory(
        pageIndex: state.currentPage,
        pageSize: defaultPageSize,
      );
      switch (resource.resourceType) {
        case ResourceType.success:
          final PaginatedData<OrderHistoryResponseModel> newState =
              paginateList(
            resource.data ?? <OrderHistoryResponseModel>[],
            PaginationParams(
              page: state.currentPage,
              pageSize: defaultPageSize,
            ),
          );
          state = newState.copyWith(isLoading: false);
          paginationService.changeValue(paginatedData: state);
        case ResourceType.error:
          final PaginatedData<OrderHistoryResponseModel> newState =
              state.copyWith(
            isLoading: false,
            error: resource.error.toString(),
          );
          paginationService.changeValue(paginatedData: newState);
        case ResourceType.loading:
      }
    } on Error catch (e) {
      final PaginatedData<OrderHistoryResponseModel> newState = state.copyWith(
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
