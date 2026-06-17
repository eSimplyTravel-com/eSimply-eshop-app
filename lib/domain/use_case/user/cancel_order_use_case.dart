import "dart:async";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class CancelOrderUseCaseParams {
  CancelOrderUseCaseParams({required this.orderID});

  final String orderID;
}

class CancelOrderUseCase
    implements UseCase<Resource<EmptyResponse?>, CancelOrderUseCaseParams> {
  CancelOrderUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(
    CancelOrderUseCaseParams params,
  ) async {
    return await repository.cancelOrder(
      orderID: params.orderID,
    );
  }
}
