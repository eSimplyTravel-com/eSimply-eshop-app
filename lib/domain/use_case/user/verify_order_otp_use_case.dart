import "dart:async";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class VerifyOrderOtpUseCase
    implements UseCase<Resource<EmptyResponse?>, VerifyOrderOtpParam> {
  VerifyOrderOtpUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(
    VerifyOrderOtpParam params,
  ) async {
    return await repository.verifyOrderOtp(
      otp: params.otp,
      iccid: params.iccid,
      orderID: params.orderID,
    );
  }
}

class VerifyOrderOtpParam {
  VerifyOrderOtpParam({
    required this.otp,
    required this.iccid,
    required this.orderID,
  });

  final String otp;
  final String iccid;
  final String orderID;
}
