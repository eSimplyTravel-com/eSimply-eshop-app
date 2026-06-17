import "dart:async";

import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/otp_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/resend_otp_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/data/api_auth.dart";
import "package:esim_open_source/domain/data/params/update_user_info_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiAuthRepositoryImpl implements ApiAuthRepository {
  ApiAuthRepositoryImpl(this.apiAuth);

  final APIAuth apiAuth;

  @override
  FutureOr<Resource<OtpResponseModel?>> login({
    required String? email,
    required String? phoneNumber,
    String? otpChannel,
  }) async {
    return responseToResource<OtpResponseModelDto, OtpResponseModel?>(
      apiAuth.login(email: email, phoneNumber: phoneNumber, otpChannel: otpChannel),
        (OtpResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse>> logout() async {
    return responseToResource<EmptyResponseDto, EmptyResponse>(
      apiAuth.logout(),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> resendOtp({
    required String email,
  }) async {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiAuth.resendOtp(email: email),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<AuthResponseModel>> verifyOtp({
    String? email,
    String? phoneNumber,
    String pinCode = "",
    String providerToken = "",
    String providerType = "",
  }) async {
    return responseToResource<AuthResponseModelDto, AuthResponseModel>(
      apiAuth.verifyOtp(
        email: email,
        phoneNumber: phoneNumber,
        pinCode: pinCode,
        providerToken: providerToken,
        providerType: providerType,
      ),
        (AuthResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse>> deleteAccount() async {
    return responseToResource<EmptyResponseDto, EmptyResponse>(
      apiAuth.deleteAccount(),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<AuthResponseModel>> updateUserInfo({
    required UpdateUserInfoRequest request,
  }) async {
    return responseToResource<AuthResponseModelDto, AuthResponseModel>(
      apiAuth.updateUserInfo(
        request: request,
      ),
        (AuthResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<AuthResponseModel>> getUserInfo({
    String? bearerToken,
  }) async {
    return responseToResource<AuthResponseModelDto, AuthResponseModel>(
      apiAuth.getUserInfo(bearerToken: bearerToken),
        (AuthResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<AuthResponseModel>> refreshTokenAPITrigger() async {
    return responseToResource<AuthResponseModelDto, AuthResponseModel>(
        apiAuth.refreshTokenAPITrigger(),
        (AuthResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  void addUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    apiAuth.addUnauthorizedAccessListener(unauthorizedAccessCallBack);
  }

  @override
  void removeUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    apiAuth.removeUnauthorizedAccessListener(unauthorizedAccessCallBack);
  }

  @override
  void addAuthReloadListenerCallBack(AuthReloadListener authReloadListener) {
    apiAuth.addAuthReloadListenerCallBack(authReloadListener);
  }

  @override
  void removeAuthReloadListenerCallBack(AuthReloadListener authReloadListener) {
    apiAuth.removeAuthReloadListenerCallBack(authReloadListener);
  }

  @override
  FutureOr<Resource<AuthResponseModel?>> tmpLogin({
    required String? email,
    required String? phone,
  }) async {
    return responseToResource<AuthResponseModelDto, AuthResponseModel?>(
      apiAuth.tmpLogin(
        email: email,
        phone: phone,
      ),
        (AuthResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<ResendOtpResponseModel?>> resendOtpNewChannel({
    required String? email,
    required String? phone,
    required String otpChannel,
  }) async {
    return responseToResource<ResendOtpResponseModelDto, ResendOtpResponseModel?>(
      apiAuth.resendOtpNewChannel(
        email: email,
        phone: phone,
        otpChannel: otpChannel,
      ),
        (ResendOtpResponseModelDto dto) => dto.toDomain(),
    );
  }
}
