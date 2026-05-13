import "package:esim_open_source/app/environment/app_environment_helper.dart";

AppEnvironmentHelper openSourceProdEnvInstance = AppEnvironmentHelper(
  baseApiUrl: "https://esimply-eshop-api.onrender.com",
  omniConfigTenant: "",
  omniConfigBaseUrl: "",
  omniConfigApiKey: "",
  omniConfigAppGuid: "",
  websiteUrl: "esimply-eshop-web.onrender.com",
  isCruiseEnabled: true,
  environmentFamilyName: "Inter",
  enableLanguageSelection: false,
);
