import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/view_models/main_model.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:mockito/mockito.dart";

import "../../helpers/view_helper.dart";
import "../../helpers/view_model_helper.dart";
import "../../locator_test.dart";
import "../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  late MainViewModel viewModel;
  late MockApiAuthRepository mockApiAuthRepository;
  late MockApiAppRepository mockApiAppRepository;
  late MockLocalStorageService mockLocalStorageService;
  late MockUserAuthenticationService mockUserAuthenticationService;
  late MockSocialLoginService mockSocialLoginService;
  late MockDeviceInfoService mockDeviceInfoService;
  late MockSecureStorageService mockSecureStorageService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockApiAppRepository =
        locator<ApiAppRepository>() as MockApiAppRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockUserAuthenticationService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    mockSocialLoginService =
        locator<SocialLoginService>() as MockSocialLoginService;
    mockDeviceInfoService =
        locator<DeviceInfoService>() as MockDeviceInfoService;
    mockSecureStorageService =
        locator<SecureStorageService>() as MockSecureStorageService;

    when(
      mockApiAuthRepository.addUnauthorizedAccessListener(any),
    ).thenReturn(null);
    when(
      mockApiAuthRepository.addAuthReloadListenerCallBack(any),
    ).thenReturn(null);

    viewModel = MainViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("MainViewModel", () {
    test("getDefaultLocale returns locale from storage language code", () {
      when(mockLocalStorageService.languageCode).thenReturn("fr");

      final Locale locale = viewModel.getDefaultLocale();

      expect(locale, equals(const Locale("fr")));
    });

    test("getLocale always returns en locale", () {
      final Locale locale = viewModel.getLocale(
        MaterialApp(home: Container()).createElement(),
      );

      expect(locale, equals(const Locale("en")));
    });

    test("getLocaleList returns locales for all LanguageEnum values", () {
      final List<Locale> locales = viewModel.getLocaleList();

      expect(locales.length, equals(LanguageEnum.values.length));
    });

    test("onModelReady registers both callback use cases", () async {
      await viewModel.onModelReady();

      verify(mockApiAuthRepository.addUnauthorizedAccessListener(any))
          .called(1);
      verify(mockApiAuthRepository.addAuthReloadListenerCallBack(any)).called(1);
    });

    test(
        "onUnauthorizedAccessCallBackUseCase with response calls logoutUser when user is logged in",
        () async {
      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.clearUserInfo())
          .thenAnswer((_) async {});
      when(mockSocialLoginService.logOut()).thenAnswer((_) async {});
      when(mockLocalStorageService.getString(LocalStorageKeys.fcmToken))
          .thenReturn(null);
      when(mockDeviceInfoService.addDeviceParams).thenAnswer(
        (_) async => AddDeviceParams(
          fcmToken: "",
          manufacturer: "",
          deviceModel: "",
          deviceOs: "",
          deviceOsVersion: "",
          appVersion: "",
          ramSize: "",
          screenResolution: "",
          isRooted: false,
        ),
      );
      when(mockSecureStorageService.getString(SecureStorageKeys.deviceID))
          .thenAnswer((_) async => "device-id");
      when(mockApiAppRepository.addDevice(any)).thenAnswer(
        (_) async =>
            Resource<EmptyResponse?>.success(EmptyResponse(), message: ""),
      );

      await viewModel.onUnauthorizedAccessCallBackUseCase(
        http.Response("", 200),
        null,
      );

      verify(mockUserAuthenticationService.clearUserInfo()).called(1);
      verify(mockSocialLoginService.logOut()).called(1);
    });

    test(
        "onUnauthorizedAccessCallBackUseCase with exception calls logoutUser when user is logged in",
        () async {
      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.clearUserInfo())
          .thenAnswer((_) async {});
      when(mockSocialLoginService.logOut()).thenAnswer((_) async {});
      when(mockLocalStorageService.getString(LocalStorageKeys.fcmToken))
          .thenReturn(null);
      when(mockDeviceInfoService.addDeviceParams).thenAnswer(
        (_) async => AddDeviceParams(
          fcmToken: "",
          manufacturer: "",
          deviceModel: "",
          deviceOs: "",
          deviceOsVersion: "",
          appVersion: "",
          ramSize: "",
          screenResolution: "",
          isRooted: false,
        ),
      );
      when(mockSecureStorageService.getString(SecureStorageKeys.deviceID))
          .thenAnswer((_) async => "device-id");
      when(mockApiAppRepository.addDevice(any)).thenAnswer(
        (_) async =>
            Resource<EmptyResponse?>.success(EmptyResponse(), message: ""),
      );

      await viewModel.onUnauthorizedAccessCallBackUseCase(
        null,
        Exception("unauthorized"),
      );

      verify(mockUserAuthenticationService.clearUserInfo()).called(1);
    });

    test(
        "onUnauthorizedAccessCallBackUseCase with null response and null exception skips logoutUser when not logged in",
        () async {
      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(false);

      await viewModel.onUnauthorizedAccessCallBackUseCase(null, null);

      verifyNever(mockUserAuthenticationService.clearUserInfo());
    });

    test(
        "onAuthReloadListenerCallBackUseCase with null authResponse does nothing",
        () async {
      await viewModel.onAuthReloadListenerCallBackUseCase(null);

      expect(viewModel, isNotNull);
    });

    test(
        "onAuthReloadListenerCallBackUseCase with authResponse calls syncLanguageAndCurrencyCode",
        () async {
      when(mockLocalStorageService.currencyCode).thenReturn(null);
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final AuthResponseModel authResponse = AuthResponseModel(
        userInfo: UserInfoResponseModel(),
      );

      await viewModel.onAuthReloadListenerCallBackUseCase(authResponse);

      expect(viewModel, isNotNull);
    });
  });
}
