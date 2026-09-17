import "package:esim_open_source/app/environment/app_environment_helper.dart";

AppEnvironmentHelper openSourceProdEnvInstance = AppEnvironmentHelper(
  baseApiUrl: "https://esimply-eshop-api.onrender.com",
  omniConfigTenant: "",
  omniConfigBaseUrl: "",
  omniConfigApiKey: "",
  omniConfigAppGuid: "",
  websiteUrl: "esimplytravel.com",
  isCruiseEnabled: true,
  environmentFamilyName: "Inter",
  enableLanguageSelection: false,
  // Wallet removed 2026-09-17: top-ups were abused with fraudulent cards; backend also refuses it.
  enableWalletView: false,
);
