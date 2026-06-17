import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/apply_referral_code_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/utils/language_currency_helper.dart";

class VerifyOtpParams {
  VerifyOtpParams({
    this.email,
    this.phoneNumber,
    this.pinCode = "",
    this.providerToken = "",
    this.providerType = "",
  });

  final String? email;
  final String? phoneNumber;
  final String pinCode;
  final String providerType;

  final String providerToken;
}

class VerifyOtpUseCase
    implements UseCase<Resource<AuthResponseModel>, VerifyOtpParams> {
  VerifyOtpUseCase(this.repository);

  final ApiAuthRepository repository;

  final UserAuthenticationService userAuthenticationService =
      locator<UserAuthenticationService>();

  final AddDeviceUseCase addDeviceUseCase = AddDeviceUseCase(
    locator<ApiAppRepository>(),
    locator<ApiDeviceRepository>(),
  );

  final LocalStorageService localStorageService =
      locator<LocalStorageService>();
  final ApplyReferralCodeUseCase applyReferralCodeUseCase =
      ApplyReferralCodeUseCase(
    locator<ApiPromotionRepository>(),
  );

  @override
  FutureOr<Resource<AuthResponseModel>> execute(VerifyOtpParams params) async {
    Resource<AuthResponseModel> response = await repository.verifyOtp(
      email: params.email,
      phoneNumber: params.phoneNumber,
      pinCode: params.pinCode,
      providerType: params.providerType,
      providerToken: params.providerToken,
    );

    if (response.resourceType == ResourceType.success) {
      await userAuthenticationService.saveUserResponse(response.data);
      await syncLanguageAndCurrencyCode(
        languageCode: response.data?.userInfo?.language,
        currencyCode: response.data?.userInfo?.currencyCode,
      );
      String referralCode =
          localStorageService.getString(LocalStorageKeys.referralCode) ?? "";
      log("Referral code from otp use case: $referralCode");

      if (referralCode.isNotEmpty) {
        await applyReferralCodeUseCase.execute(
          ApplyReferralCodeUserCaseParams(referralCode: referralCode),
        );
      }
      addDeviceUseCase.execute(NoParams());
    }
    return response;
  }
}
