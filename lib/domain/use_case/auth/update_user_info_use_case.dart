import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/data/params/update_user_info_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";

class UpdateUserInfoParams {
  UpdateUserInfoParams({
    this.email,
    this.msisdn,
    this.firstName,
    this.lastName,
    this.currencyCode,
    this.languageCode,
  });

  final String? email;
  final String? msisdn;
  final String? firstName;
  final String? lastName;
  final String? currencyCode;
  final String? languageCode;
}

class UpdateUserInfoUseCase
    implements UseCase<Resource<AuthResponseModel>, UpdateUserInfoParams> {
  UpdateUserInfoUseCase(this.repository);

  final ApiAuthRepository repository;

  final UserAuthenticationService userAuthenticationService =
      locator<UserAuthenticationService>();

  final AddDeviceUseCase addDeviceUseCase = AddDeviceUseCase(
    locator<ApiAppRepository>(),
    locator<ApiDeviceRepository>(),
  );

  @override
  FutureOr<Resource<AuthResponseModel>> execute(
    UpdateUserInfoParams params,
  ) async {
    String? email;

    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        email = null;
      case LoginType.phoneNumber:
        email = params.email;
    }

    String? msisdn;

    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
      case LoginType.emailAndPhoneAndEmailVerification:
        msisdn = params.msisdn;
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndBothVerification:
      case LoginType.phoneNumber:
        msisdn = null;
    }

    Resource<AuthResponseModel> response = await repository.updateUserInfo(
      request: UpdateUserInfoRequest(
        email: email,
        msisdn: msisdn,
        firstName: params.firstName,
        lastName: params.lastName,
        currencyCode: params.currencyCode,
        languageCode: params.languageCode,
      ),
    );

    await userAuthenticationService.updateUserResponse(response.data);

    return response;
  }
}
