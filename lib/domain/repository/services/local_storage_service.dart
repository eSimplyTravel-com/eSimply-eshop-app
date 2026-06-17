import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";

enum LocalStorageKeys {
  loginResponseKey("LoginResponseKey"),
  biometricKey("biometricKey"),
  fcmToken("fcmToken"),
  hasPreviouslyStarted("hasPreviouslyStarted"),
  appConfigurations("appConfigurations"),
  appBanner("appBanner"),
  referralInfo("referralInfo"),
  appCurrency("appCurrency"),
  referralCode("referralCode"),
  appLanguage("appLanguage"),
  utm("utm");

  const LocalStorageKeys(this.value);

  final String value;
}

abstract class LocalStorageService {
  int? getInt(LocalStorageKeys key);
  bool? getBool(LocalStorageKeys key);
  double? getDouble(LocalStorageKeys key);
  String? getString(LocalStorageKeys key);
  List<String>? getStringList(LocalStorageKeys key);

  bool containsKey(LocalStorageKeys key);

  String get accessToken;
  String get refreshToken;
  bool? get biometricEnabled;
  AuthResponseModel? get authResponse;

  String get languageCode;
  String? get currencyCode;

  Future<bool> setInt(LocalStorageKeys key, int value);
  Future<bool> setBool(LocalStorageKeys key, {required bool value});
  Future<bool> setDouble(LocalStorageKeys key, double value);
  Future<bool> setString(LocalStorageKeys key, String value);
  Future<bool> setStringList(LocalStorageKeys key, List<String> value);

  Future<void> clear();
  Future<bool> remove(LocalStorageKeys key);
  Future<bool> setBiometricEnabled({bool? value});
  Future<void> saveLoginResponse(AuthResponseModel? authResponse);
}
