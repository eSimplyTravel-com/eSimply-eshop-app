import "dart:async";

import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetOrderByIdParams {
  GetOrderByIdParams({required this.orderID});

  final String orderID;
}

class GetOrderByIdUseCase
    implements
        UseCase<Resource<OrderHistoryResponseModel?>, GetOrderByIdParams> {
  GetOrderByIdUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<OrderHistoryResponseModel?>> execute(
    GetOrderByIdParams params,
  ) async {
    return await repository.getOrderByID(
      orderID: params.orderID,
    );
  }
}
