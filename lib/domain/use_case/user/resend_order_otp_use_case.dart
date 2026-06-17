import "dart:async";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ResendOrderOtpUseCase
    implements UseCase<Resource<EmptyResponse?>, ResendOrderOtpParam> {
  ResendOrderOtpUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(
    ResendOrderOtpParam params,
  ) async {
    return await repository.resendOrderOtp(
      orderID: params.orderID,
    );
  }
}

class ResendOrderOtpParam {
  ResendOrderOtpParam({
    required this.orderID,
  });

  final String orderID;
}
