import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/auth/set_auth_reload_call_back_use_case.dart";
import "package:esim_open_source/domain/use_case/auth/set_unauthorized_access_call_back_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/utils/language_currency_helper.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";
import "package:stacked/stacked.dart";

class MainViewModel extends ReactiveViewModel
    implements UnauthorizedAccessListener, AuthReloadListener {
  final AddUnauthorizedAccessCallBackUseCase
      _unauthorizedAccessCallBackUseCase =
      AddUnauthorizedAccessCallBackUseCase(locator<ApiAuthRepository>());
  final AddAuthReloadCallBackUseCase _addAuthReloadCallBackUseCase =
      AddAuthReloadCallBackUseCase(locator<ApiAuthRepository>());

  final LocalStorageService localStorageService =
      locator<LocalStorageService>();

  @override
  List<ListenableServiceMixin> get listenableServices =>
      <ListenableServiceMixin>[
        /*nativeChannelCommunication*/
      ];

  Future<void> onModelReady() async {
    _unauthorizedAccessCallBackUseCase
        .execute(UnauthorizedAccessCallBackParams(this));
    _addAuthReloadCallBackUseCase.execute(AuthReloadAccessCallBackParams(this));
  }

  Locale getDefaultLocale() {
    String languageCode = locator<LocalStorageService>().languageCode;
    return Locale(languageCode);
  }

  Locale getLocale(BuildContext context) {
    return const Locale("en");
  }

  @override
  Future<void> onUnauthorizedAccessCallBackUseCase(
    BaseResponse? response,
    Exception? e,
  ) async {
    if (response != null) {
      log(
        "onUnauthorizedAccessCallBackUseCase: status_code:${response.statusCode} request:${response.request?.url}",
      );
    }
    if (e != null) {
      log("onUnauthorizedAccessCallBackUseCase: Exception:$e}");
    }
    if (e == null && response == null) {
      log("onUnauthorizedAccessCallBackUseCase: General Error");
    }

    if(locator<UserAuthenticationService>().isUserLoggedIn) {
      logoutUser();
    }
    //_navigationService.navigateTo(ContinueWithEmailView.routeName);
  }

  Future<void> logoutUser() async {
    await locator<UserAuthenticationService>().clearUserInfo();
    locator<SocialLoginService>().logOut();
    AddDeviceUseCase(
      locator<ApiAppRepository>(),
      locator<ApiDeviceRepository>(),
    ).execute(NoParams());
  }

  // Color getColor() {
  //   return nativeChannelCommunication.themeColor;
  // }

  @override
  Future<void> onAuthReloadListenerCallBackUseCase(
      AuthResponseModel? authResponse,
      ) async {
    if (authResponse != null) {
      await syncLanguageAndCurrencyCode(
        languageCode: authResponse.userInfo?.language,
        currencyCode: authResponse.userInfo?.currencyCode,
      );
    }
  }

  List<Locale> getLocaleList() {
    return LanguageEnum.values
        .map((LanguageEnum item) => Locale(item.code))
        .toList();
  }
}
