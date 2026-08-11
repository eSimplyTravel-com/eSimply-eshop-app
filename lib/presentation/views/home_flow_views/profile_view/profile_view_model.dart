import "dart:async";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/extensions/navigation_service_extensions.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";

class ProfileViewModel extends BaseModel {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  String _appVersion = "";

  String get appVersion => _appVersion;
  String _buildNumber = "";

  String get buildNumber => _buildNumber;

  bool? get analyticsConsent => _analyticsService.analyticsConsent;

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPackageInfo();
      notifyListeners();
    });
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _appVersion = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  Future<void> loginButtonTapped() async {
    navigationService.navigateToLoginScreen();
  }

  Future<void> setAnalyticsConsent({required bool granted}) async {
    await _analyticsService.setAnalyticsConsent(granted: granted);
    notifyListeners();
  }

  String getUserName() {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
      case LoginType.emailAndPhoneAndEmailVerification:
        return userEmailAddress;
      case LoginType.phoneNumber:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndBothVerification:
        return userMsisdn;
    }
  }
}
