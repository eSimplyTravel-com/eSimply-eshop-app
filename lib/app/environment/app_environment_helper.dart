import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_theme.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";

class AppEnvironmentHelper {
  AppEnvironmentHelper({
    required this.baseApiUrl,
    required this.omniConfigTenant,
    required this.omniConfigBaseUrl,
    required this.omniConfigApiKey,
    required this.omniConfigAppGuid,
    this.websiteUrl = "",
    this.defaultLoginType = LoginType.email,
    this.enableBranchIO = false,
    this.enablePromoCode = true,
    this.enableWalletView = true,
    this.enableBannersView = true,
    this.enableCurrencySelection = true,
    this.environmentTheme = EnvironmentTheme.openSource,
    this.enableLanguageSelection = true,
    this.enableAppleSignIn = true,
    this.enableGoogleSignIn = true,
    this.enableFacebookSignIn = true,
    this.enableGuestFlowPurchase = true,
    this.environmentCornerRadius = 25,
    this.environmentFamilyName = "Poppins",
    this.isCruiseEnabled = false,
    this.cruiseIdentifier = "cruise",
    this.defaultPaymentTypeList = const <PaymentType>[
      PaymentType.card,
    ],
    this.supabaseFacebookCallBackScheme = "iosupabaseesimply://login-callback",
  });

  String baseApiUrl;
  bool isCruiseEnabled;
  String cruiseIdentifier;
  double environmentCornerRadius;
  String environmentFamilyName;
  EnvironmentTheme environmentTheme;
  String supabaseFacebookCallBackScheme;
  String omniConfigTenant;
  String omniConfigBaseUrl;
  String omniConfigApiKey;
  String omniConfigAppGuid;
  String websiteUrl;

  //feature flags
  LoginType defaultLoginType;
  bool enableBranchIO;
  bool enablePromoCode;
  bool enableWalletView;
  bool enableBannersView;
  bool enableCurrencySelection;
  bool enableLanguageSelection;
  bool enableGuestFlowPurchase;
  List<PaymentType> defaultPaymentTypeList;

  //social media flags
  bool enableAppleSignIn;
  bool enableGoogleSignIn;
  bool enableFacebookSignIn;

  //Login type
  LoginType? get _apiLoginType =>
      locator<AppConfigurationService>().getLoginType;

  LoginType get loginType => _apiLoginType ?? defaultLoginType;

  //Payment type
  List<PaymentType>? get _apiPaymentTypeList =>
      locator<AppConfigurationService>().getPaymentTypes;

  // Allow Guest Flow Purchase
  bool get isGuestFlowPurchaseEnabled {
    return enableGuestFlowPurchase &&
        !(loginType == LoginType.phoneNumber ||
            loginType == LoginType.emailAndPhone);
  }

  List<PaymentType> paymentTypeList({required bool isUserLoggedIn}) {
    List<PaymentType> list = _apiPaymentTypeList ?? defaultPaymentTypeList;
    // check if wallet is enabled
    // if not, we should remove it from payment type bottom sheet
    if ((list.contains(PaymentType.wallet) && !enableWalletView) ||
        (list.contains(PaymentType.wallet) && !isUserLoggedIn)) {
      list.remove(PaymentType.wallet);
    }
    return list;
  }
}
