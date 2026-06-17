import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:stacked/stacked.dart";

class UserAuthenticationService with ListenableServiceMixin {
  UserAuthenticationService() {
    listenToReactiveValues(<dynamic>[
      _authModel,
    ]);
    _getInitialValue();
  }

  final LocalStorageService localStorageService =
      locator<LocalStorageService>();

  final ReactiveValue<AuthResponseModel?> _authModel =
      ReactiveValue<AuthResponseModel?>(null);

  bool get isUserLoggedIn => _authModel.value?.accessToken?.isNotEmpty ?? false;
  String get userFirstName => _authModel.value?.userInfo?.firstName ?? "";
  String get userLastName => _authModel.value?.userInfo?.lastName ?? "";
  String get userEmailAddress => _authModel.value?.userInfo?.email ?? "";
  String get userPhoneNumber => _authModel.value?.userInfo?.msisdn ?? "";
  String get referralCode => _authModel.value?.userInfo?.referralCode ?? "";
  String get walletCurrencyCode =>
      _authModel.value?.userInfo?.currencyCode ?? "";
  double get walletAvailableBalance => _authModel.value?.userInfo?.balance ?? 0;

  Future<void> saveUserResponse(AuthResponseModel? authResponse) async {
    await localStorageService.saveLoginResponse(authResponse);
    _authModel.value = authResponse;
    notifyListeners();
  }

  Future<void> updateUserResponse(AuthResponseModel? authResponse) async {
    String? accessToken = _authModel.value?.accessToken;
    String? refreshToken = _authModel.value?.refreshToken;

    AuthResponseModel authResponseModel = AuthResponseModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userInfo: authResponse?.userInfo,
      userToken: authResponse?.userToken,
      isVerified: authResponse?.isVerified,
    );

    await localStorageService.saveLoginResponse(authResponseModel);

    _authModel.value = authResponseModel;
    notifyListeners();
  }

  Future<void> clearUserInfo() async {
    await localStorageService.clear();
    _authModel.value = null;
    notifyListeners();
  }

  void _getInitialValue() {
    _authModel.value = localStorageService.authResponse;
    notifyListeners();
  }
}
