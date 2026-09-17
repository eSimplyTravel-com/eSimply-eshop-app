import "package:esim_open_source/app/environment/app_environment_helper.dart";

AppEnvironmentHelper openSourceStagingEnvInstance = AppEnvironmentHelper(
  baseApiUrl: "https://esimply-eshop-api.onrender.com",
  omniConfigTenant: "",
  omniConfigBaseUrl: "",
  omniConfigApiKey: "",
  omniConfigAppGuid: "",
  websiteUrl: "esimplytravel.com",
  isCruiseEnabled: true,
  enableLanguageSelection: false,
  environmentFamilyName: "Inter",
  // Wallet removed 2026-09-17: top-ups were abused with fraudulent cards; backend also refuses it.
  enableWalletView: false,
);
