import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/auth_apis/auth_apis.dart";
import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/http_request.dart";
import "package:esim_open_source/data/remote/request/auth/update_user_info_params_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/otp_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/resend_otp_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/data/api_auth.dart";
import "package:esim_open_source/domain/data/params/update_user_info_params.dart";

class APIAuthImpl extends APIService implements APIAuth {
  APIAuthImpl._privateConstructor() : super.privateConstructor();

  static APIAuthImpl? _instance;

  static APIAuthImpl get instance {
    if (_instance == null) {
      _instance = APIAuthImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMainDto<OtpResponseModelDto?>> login({
    required String? email,
    required String? phoneNumber,
    String? otpChannel,
  }) async {
    Map<String, String> params = <String, String>{
      if (email != null) "email": email,
      if (phoneNumber != null) "phone": phoneNumber,
      if (otpChannel != null) "otp_channel": otpChannel,
    };

    ResponseMainDto<OtpResponseModelDto?> loginResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.login,
        parameters: params,
      ),
      fromJson: OtpResponseModelDto.fromJson,
    );

    return loginResponse;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto>> logout() async {
    ResponseMainDto<EmptyResponseDto> emptyResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.logout,
      ),
      fromJson: EmptyResponseDto.fromJson,
    );

    return emptyResponse;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> resendOtp({
    required String email,
  }) async {
    Map<String, String> params = <String, String>{
      "email": email,
    };

    ResponseMainDto<EmptyResponseDto?> resendOtpResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.resendOtp,
        parameters: params,
      ),
      fromJson: EmptyResponseDto.fromJson,
    );

    return resendOtpResponse;
  }

  @override
  FutureOr<ResponseMainDto<ResendOtpResponseModelDto?>> resendOtpNewChannel({
    required String? email,
    required String? phone,
    required String otpChannel,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      "otp_channel": otpChannel,
    };

    ResponseMainDto<ResendOtpResponseModelDto?> resendOtpResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.resendOtpNewChannel,
        parameters: params,
      ),
      fromJson: ResendOtpResponseModelDto.fromJson,
    );

    return resendOtpResponse;
  }

  @override
  FutureOr<ResponseMainDto<AuthResponseModelDto>> verifyOtp({
    String? email,
    String? phoneNumber,
    String pinCode = "",
    String providerToken = "",
    String providerType = "",
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      if (email != null) "user_email": email,
      if (phoneNumber != null) "phone": phoneNumber,
      "verification_pin": pinCode,
      "provider_token": providerToken,
      "provider_type": providerType,
    };

    ResponseMainDto<AuthResponseModelDto> authResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.verifyOtp,
        parameters: params,
      ),
      fromJson: AuthResponseModelDto.fromAPIJson,
    );

    return authResponse;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto>> deleteAccount() async {
    ResponseMainDto<EmptyResponseDto> emptyResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.deleteAccount,
      ),
      fromJson: EmptyResponseDto.fromJson,
    );

    return emptyResponse;
  }

  @override
  FutureOr<ResponseMainDto<AuthResponseModelDto>> updateUserInfo({
    required UpdateUserInfoRequest request,
  }) async {
    UpdateUserInfoRequestDto requestDto =
        UpdateUserInfoRequestDto.fromDomain(request);

    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer ${requestDto.bearerToken}",
    };

    ResponseMainDto<AuthResponseModelDto> authResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        parameters: requestDto.toJson(),
        endPoint: AuthApis.updateUserInfo,
        additionalHeaders:
            (requestDto.bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: AuthResponseModelDto.fromAPIJson,
    );

    return authResponse;
  }

  @override
  FutureOr<ResponseMainDto<AuthResponseModelDto>> getUserInfo({
    String? bearerToken,
  }) async {
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $bearerToken",
    };

    ResponseMainDto<AuthResponseModelDto> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.userInfo,
        additionalHeaders:
            (bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: AuthResponseModelDto.fromAPIJson,
    );

    return response;
  }

  @override
  FutureOr<dynamic> refreshTokenAPITrigger() async {
    return refreshTokenAPI();
  }

  @override
  void addUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    HttpRequest.addUnauthorizedAccessCallBackListener(
      unauthorizedAccessCallBack,
    );
  }

  @override
  void removeUnauthorizedAccessListener(
    UnauthorizedAccessListener unauthorizedAccessCallBack,
  ) {
    HttpRequest.removeUnauthorizedAccessCallBackListener(
      unauthorizedAccessCallBack,
    );
  }

  @override
  void addAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  ) {
    HttpRequest.addAuthReloadListenerCallBack(
      authReloadListener,
    );
  }

  @override
  void removeAuthReloadListenerCallBack(
    AuthReloadListener authReloadListener,
  ) {
    HttpRequest.removeAuthReloadListenerCallBack(
      authReloadListener,
    );
  }

  @override
  FutureOr<ResponseMainDto<AuthResponseModelDto?>> tmpLogin({
    required String? email,
    required String? phone,
  }) async {
    Map<String, String> params = <String, String>{
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
    };

    ResponseMainDto<AuthResponseModelDto?> tmpLoginResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AuthApis.tmpLogin,
        parameters: params,
      ),
      fromJson: AuthResponseModelDto.fromAPIJson,
    );

    return tmpLoginResponse;
  }
}
