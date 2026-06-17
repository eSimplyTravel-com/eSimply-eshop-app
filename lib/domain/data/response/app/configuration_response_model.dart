enum ConfigurationResponseKeys {
  catalogBundleCashVersion,
  whatsAppNumber,
  supabaseBaseUrl,
  supabaseAnonKey,
  defaultCurrency,
  paymentTypes,
  loginType,
  cashbackDiscount;

  String get configurationKeyValue {
    switch (this) {
      case ConfigurationResponseKeys.catalogBundleCashVersion:
        return "CATALOG.BUNDLES_CACHE_VERSION";
      case ConfigurationResponseKeys.whatsAppNumber:
        return "WHATSAPP_NUMBER";
      case ConfigurationResponseKeys.supabaseBaseUrl:
        return "SUPABASE_BASE_URL";
      case ConfigurationResponseKeys.supabaseAnonKey:
        return "SUPABASE_BASE_ANON_KEY";
      case ConfigurationResponseKeys.defaultCurrency:
        return "default_currency";
      case ConfigurationResponseKeys.paymentTypes:
        return "ALLOWED_PAYMENT_TYPES";
      case ConfigurationResponseKeys.loginType:
        return "LOGIN_TYPE";
      case ConfigurationResponseKeys.cashbackDiscount:
        return "REFERRAL_CODE_PERCENTAGE";
    }
  }
}

class ConfigurationResponseModel {
  ConfigurationResponseModel({
    String? key,
    String? value,
  }) {
    _key = key;
    _value = value;
  }

  String? _key;
  String? _value;

  ConfigurationResponseModel copyWith({
    String? key,
    String? value,
  }) =>
      ConfigurationResponseModel(
        key: key ?? _key,
        value: value ?? _value,
      );

  String? get key => _key;

  String? get value => _value;
}
