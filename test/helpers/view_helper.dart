import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/theme/my_theme_builder.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:stacked_themes/stacked_themes.dart";

import "../locator_test.dart";
import "firebase_helper.dart";
import "flutter_esim_helper.dart";
import "fluttertoast_helper.dart";
import "haptic_helper.dart";
import "package_info_helper.dart";
import "share_plus_helper.dart";
// ignore_for_file: type=lint

Widget createTestableWidget(Widget child) {
  return EasyLocalization(
    supportedLocales: const <Locale>[Locale("en")],
    path: "assets/translations/open_source",
    fallbackLocale: const Locale("en"),
    child: MyThemeBuilder(
      // statusBarColorBuilder: (theme) => model.getColor(),
      // defaultThemeMode: ThemeMode.light,
      themes: getThemes(),
      builder: (
        BuildContext context,
        ThemeData? regularTheme,
        ThemeData? darkTheme,
        ThemeMode? themeMode,
      ) =>
          MaterialApp(
        theme: regularTheme,
        darkTheme: darkTheme,
        home: KeyboardVisibilityProvider(
          child: child,
        ),
      ),
    ),
  );
}

Future<void> prepareTest() async {
  // ensure system up
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  await EasyLocalization.ensureInitialized();
  await ThemeManager.initialise();
  // Setup haptic feedback mock early to intercept calls
  HapticHelperTest.implementHaptic();
}

Future<void> setupTest() async {
  await setupTestLocator();
  HapticHelperTest.implementHaptic();
  FirebaseHelper.initFirebaseMock();
  PackageInfoHelperTest.initPackageInfo();
  AppEnvironment.setupEnvironment();
  FluttertoastHelperTest.implementFluttertoast();
  SharePlusHelper.implementSharePlus();
  FlutterEsimHelperTest.implementFlutterEsim();
  when(locator<ReferralInfoService>().getReferralAmountAndCurrency)
      .thenReturn("5 \$");
  when(locator<AppConfigurationService>().getLoginType)
      .thenReturn(LoginType.email);
}

Future<void> tearDownTest() async {
  await locator.reset();
  resetMockitoState();
}

Future<void> tearDownAllTest() async {
  HapticHelperTest.deInitHaptic();
  PackageInfoHelperTest.deInitPackageInfo();
  FirebaseHelper.deInitFirebaseMock();
  FluttertoastHelperTest.deInitFluttertoast();
  SharePlusHelper.deInitSharePlus();
  FlutterEsimHelperTest.deInitFlutterEsim();
}

// Empty main function to prevent Flutter test runner from treating this as a test file
void main() {}
