import "dart:async";

import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetOrderHistoryUseCase
    implements UseCase<Resource<List<OrderHistoryResponseModel>?>, NoParams> {
  GetOrderHistoryUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<List<OrderHistoryResponseModel>?>> execute(
    NoParams params,
  ) async {
    return await repository.getOrderHistory(pageIndex: 1, pageSize: 1000);
  }
}
