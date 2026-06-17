import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:crypto/crypto.dart";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/auth/refresh_token_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";

class StartUpViewModel extends BaseModel {
  final RefreshTokenUseCase refreshTokenUseCase =
      RefreshTokenUseCase(locator<ApiAuthRepository>());
  final PushNotificationService pushNotificationService =
      locator<PushNotificationService>();

  Future<void> handleStartUpLogic(BuildContext context) async {
    unawaited(_initializePushServices());

    unawaited(_initializeConfigurations());

    setViewState(ViewState.busy);

    await Future<void>.delayed(const Duration(seconds: 2));

    if (Environment.isProdEnv) {
      log("Running on prod env checking device compatible");
      if (context.mounted && await checkIfDeviceCompatible(context)) {
        return;
      }
    }

    if (isUserLoggedIn) {
      unawaited(refreshTokenTrigger());
    }

    redirectionsHandlerService.handleInitialRedirection(getInitialRoute);
  }

  @visibleForTesting
  Future<void> showDeviceCompromisedDialog(BuildContext context) async {
    if (context.mounted) {
      showNativeDialog(
        params: NativeDialogParams(
          context: context,
          titleText: "Warning",
          contentText: "Your device is compromised",
        ),
      );
    }
  }

  //Tested
  Future<bool> checkIfDeviceCompatible(BuildContext context) async {
    DeviceInfoService deviceInfo = locator<DeviceInfoService>();
    if (await deviceInfo.isRooted ||
        await deviceInfo.isDevelopmentModeEnable ||
        !await deviceInfo.isPhysicalDevice) {
      log("Device compromised");
      if (context.mounted) {
        showDeviceCompromisedDialog(context);
        return true;
      }
    }
    return false;
  }

  Future<void> getInitialRoute() async {
    if (Platform.isAndroid &&
        !(localStorageService.getBool(LocalStorageKeys.hasPreviouslyStarted) ??
            false)) {
      navigationService.navigateTo(DeviceCompabilityCheckView.routeName);
      return;
    }
    if (AppEnvironment.isFromAppClip) {
      navigationService.replaceWith(AppClipSelectionView.routeName);
      return;
    }
    navigateToHomePager();
  }

  //Tested
  Future<void> refreshTokenTrigger() async {
    setViewState(ViewState.busy);

    try {
      Resource<AuthResponseModel> response =
          await refreshTokenUseCase.execute(NoParams());

      switch (response.resourceType) {
        case ResourceType.success:
          final String email = userEmailAddress;
          if (email.isNotEmpty) {
            final String hashedEmail = _hashEmail(email);
            await analyticsService.setUserId(hashedEmail);
          }
          setViewState(ViewState.idle);

        case ResourceType.error:
          // await showErrorMessageDialog(
          //   response.error?.message,
          //   iconType: DialogIconType.warningRed,
          //   cancelText: LocaleKeys.ok.tr(),
          // );
          setViewState(ViewState.idle);
        //await navigationService.replaceWith(ContinueWithEmailView.routeName);
        case ResourceType.loading:
          setViewState(ViewState.busy);
      }
    } on Exception catch (e) {
      log(e.toString());
      // await navigationService.replaceWith(ContinueWithEmailView.routeName);
    }
    setViewState(ViewState.idle);
    //redirectionsHandlerService.handleInitialRedirection(navigateToHomePager);
  }

  Future<void>? _initializeConfigurations() async {
    await locator<SocialLoginService>().initialise(
      url: await locator<AppConfigurationService>().getSupabaseUrl,
      anonKey: await locator<AppConfigurationService>().getSupabaseAnon,
    );
    locator<ReferralInfoService>();
  }

  Future<void>? _initializePushServices() async {
    // Get and print the Firebase project settings
    log("Firebase project settings: ${Firebase.app().options}");
    try {
      await pushNotificationService.initialise(
        handlePushData:
            redirectionsHandlerService.serialiseAndRedirectNotification,
      );
      String? fcmToken = await pushNotificationService.getFcmToken();
      await localStorageService.setString(
        LocalStorageKeys.fcmToken,
        fcmToken ?? "",
      );

      await addDeviceUseCase.execute(NoParams());
    } on Object catch (e) {
      log(e.toString());
    }
  }

  String _hashEmail(String email) {
    final List<int> bytes = utf8.encode(email.toLowerCase());
    return sha256.convert(bytes).toString();
  }
}
