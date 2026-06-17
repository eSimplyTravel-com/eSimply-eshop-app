import "dart:async";

import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ResendOtpParams {
  ResendOtpParams({
    required this.email,
    required this.phoneNumber,
    this.otpChannel,
  });

  final String? email;
  final String? phoneNumber;
  final String? otpChannel;
}

class ResendOtpUseCase
    implements UseCase<Resource<OtpResponseModel?>, ResendOtpParams> {
  ResendOtpUseCase(this.repository);

  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<OtpResponseModel?>> execute(ResendOtpParams params) async {
    return await repository.login(
      email: params.email,
      phoneNumber: params.phoneNumber,
      otpChannel: params.otpChannel,
    );
  }
}

class ResendOtpNewChannelParams {
  ResendOtpNewChannelParams({
    required this.email,
    required this.phoneNumber,
    required this.otpChannel,
  });

  final String? email;
  final String? phoneNumber;
  final String otpChannel;
}

class ResendOtpNewChannelUseCase
    implements UseCase<Resource<ResendOtpResponseModel?>, ResendOtpNewChannelParams> {
  ResendOtpNewChannelUseCase(this.repository);

  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<ResendOtpResponseModel?>> execute(
    ResendOtpNewChannelParams params,
  ) async {
    return await repository.resendOtpNewChannel(
      email: params.email,
      phone: params.phoneNumber,
      otpChannel: params.otpChannel,
    );
  }
}
