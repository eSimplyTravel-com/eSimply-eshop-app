import "package:esim_open_source/app/environment/app_environment.dart";

enum EnvironmentImagesType { png, gif, svg }

enum EnvironmentImages {
  //user guide
  androidStep1,
  androidStep2,
  androidStep3,
  androidStep4,
  androidStep5,
  androidStep6,
  androidStep7,
  androidStep8,
  androidStep9,
  androidStep10,
  androidStep11,
  androidStep12,
  androidStep13,
  androidStep14,
  androidStep15,
  androidStep16,
  androidStep17,
  androidStep18,
  iosStep1,
  iosStep2,
  iosStep3,
  iosStep4,
  iosStep5,
  iosStep6,
  iosStep7,
  iosStep8,
  iosStep9,
  iosStep10,
  iosStep11,
  iosStep12,
  iosStep13,
  iosStep14,
  iosStep15,
  iosStep16,
  iosStep17,
  iosStep18,
  scanGallery,
  scanQr,
  userGuideNextIcon,
  userGuidePreviousIcon,
  //tab bar
  tabBarMyEsim,
  tabBarProfile,
  tabBarDataPlans,
  //profile
  expandFaq,
  collapseFaq,
  aboutUs,
  accountInformation,
  chevronRight,
  contactUs,
  deleteAccount,
  faq,
  language,
  logout,
  orderHistory,
  profilePerson,
  termsAndConditions,
  userGuide,
  wallet,
  currency,
  //wallet
  walletCashback,
  walletIcon,
  walletReferEarn,
  walletRewardHistory,
  walletVoucher,
  walletUpgrade,
  payByCard,
  payByWallet,
  payByDcb,
  //icons
  iconCheck,
  iconWarning,
  topUpIcon,
  checkBoxSelected,
  checkBoxUnselected,
  scanPromoCode,
  searchIcon,
  notificationIcon,
  deleteAccountIcon,
  compatibleIcon,
  inCompatibleIcon,
  darkArrowRight,
  whiteCloseIcon,
  checkCompatibleIcon,
  darkAppIcon,
  logoutIcon,
  navBackIcon,
  onBoardingBackground,
  sheetCloseIcon,
  whiteAppIcon,
  copyIcon,
  shareIcon,
  //empty state
  emptyEsims,
  emptyNotifications,
  emptyOrderHistory,
  emptyRewardHistory,
  //login icons
  loginMail,
  loginApple,
  loginGoogle,
  loginFacebook,
  //flags
  globalFlag,
  //logo
  splashIcon,
  headerLockup,
  //stories
  storyCar,
  storyGirl,
  storyBuilding;
}

extension EnvironmentImagesExtension on EnvironmentImages {
  bool get isSharedImage {
    switch (this) {
      case EnvironmentImages.iosStep1:
      case EnvironmentImages.tabBarMyEsim:
      case EnvironmentImages.tabBarProfile:
      case EnvironmentImages.tabBarDataPlans:
      case EnvironmentImages.aboutUs:
      case EnvironmentImages.accountInformation:
      case EnvironmentImages.chevronRight:
      case EnvironmentImages.contactUs:
      case EnvironmentImages.deleteAccount:
      case EnvironmentImages.faq:
      case EnvironmentImages.language:
      case EnvironmentImages.logout:
      case EnvironmentImages.orderHistory:
      case EnvironmentImages.profilePerson:
      case EnvironmentImages.termsAndConditions:
      case EnvironmentImages.userGuide:
      case EnvironmentImages.wallet:
      case EnvironmentImages.currency:
      case EnvironmentImages.walletCashback:
      case EnvironmentImages.walletIcon:
      case EnvironmentImages.walletReferEarn:
      case EnvironmentImages.walletRewardHistory:
      case EnvironmentImages.walletVoucher:
      case EnvironmentImages.walletUpgrade:
      case EnvironmentImages.payByCard:
      case EnvironmentImages.payByWallet:
      case EnvironmentImages.payByDcb:
      case EnvironmentImages.notificationIcon:
      case EnvironmentImages.deleteAccountIcon:
      case EnvironmentImages.checkCompatibleIcon:
      case EnvironmentImages.darkAppIcon:
      case EnvironmentImages.logoutIcon:
      case EnvironmentImages.navBackIcon:
      case EnvironmentImages.onBoardingBackground:
      case EnvironmentImages.sheetCloseIcon:
      case EnvironmentImages.whiteAppIcon:
      case EnvironmentImages.emptyEsims:
      case EnvironmentImages.emptyOrderHistory:
      case EnvironmentImages.emptyRewardHistory:
      case EnvironmentImages.emptyNotifications:
      case EnvironmentImages.loginMail:
      case EnvironmentImages.splashIcon:
      case EnvironmentImages.headerLockup:
      case EnvironmentImages.storyCar:
      case EnvironmentImages.storyGirl:
      case EnvironmentImages.storyBuilding:
      case EnvironmentImages.copyIcon:
      case EnvironmentImages.shareIcon:
        return false;
      default:
        return true;
    }
  }

  EnvironmentImagesType get imageType {
    switch (this) {
      case EnvironmentImages.androidStep3:
      case EnvironmentImages.androidStep4:
      case EnvironmentImages.androidStep5:
      case EnvironmentImages.androidStep6:
      case EnvironmentImages.androidStep7:
      case EnvironmentImages.androidStep9:
      case EnvironmentImages.androidStep11:
      case EnvironmentImages.androidStep14:
      case EnvironmentImages.androidStep15:
      case EnvironmentImages.androidStep16:
      case EnvironmentImages.androidStep17:
      case EnvironmentImages.androidStep18:
      case EnvironmentImages.iosStep2:
      case EnvironmentImages.iosStep3:
      case EnvironmentImages.iosStep4:
      case EnvironmentImages.iosStep6:
      case EnvironmentImages.iosStep7:
      case EnvironmentImages.iosStep8:
      case EnvironmentImages.iosStep9:
      case EnvironmentImages.iosStep10:
      case EnvironmentImages.iosStep11:
      case EnvironmentImages.iosStep14:
      case EnvironmentImages.iosStep15:
      case EnvironmentImages.iosStep16:
      case EnvironmentImages.iosStep17:
      case EnvironmentImages.iosStep18:
        return EnvironmentImagesType.gif;
      case EnvironmentImages.topUpIcon:
      case EnvironmentImages.iconCheck:
      case EnvironmentImages.iconWarning:
      case EnvironmentImages.globalFlag:
        return EnvironmentImagesType.svg;
      default:
        return EnvironmentImagesType.png;
    }
  }

  String get imageName {
    switch (this) {
      case EnvironmentImages.androidStep1:
      case EnvironmentImages.androidStep2:
      case EnvironmentImages.androidStep3:
      case EnvironmentImages.androidStep4:
      case EnvironmentImages.androidStep5:
      case EnvironmentImages.androidStep6:
      case EnvironmentImages.androidStep7:
      case EnvironmentImages.androidStep8:
      case EnvironmentImages.androidStep9:
      case EnvironmentImages.androidStep10:
      case EnvironmentImages.androidStep11:
      case EnvironmentImages.androidStep12:
      case EnvironmentImages.androidStep13:
      case EnvironmentImages.androidStep14:
      case EnvironmentImages.androidStep15:
      case EnvironmentImages.androidStep16:
      case EnvironmentImages.androidStep17:
      case EnvironmentImages.androidStep18:
      case EnvironmentImages.iosStep1:
      case EnvironmentImages.iosStep2:
      case EnvironmentImages.iosStep3:
      case EnvironmentImages.iosStep4:
      case EnvironmentImages.iosStep5:
      case EnvironmentImages.iosStep6:
      case EnvironmentImages.iosStep7:
      case EnvironmentImages.iosStep8:
      case EnvironmentImages.iosStep9:
      case EnvironmentImages.iosStep10:
      case EnvironmentImages.iosStep11:
      case EnvironmentImages.iosStep12:
      case EnvironmentImages.iosStep13:
      case EnvironmentImages.iosStep14:
      case EnvironmentImages.iosStep15:
      case EnvironmentImages.iosStep16:
      case EnvironmentImages.iosStep17:
      case EnvironmentImages.iosStep18:
      case EnvironmentImages.scanGallery:
      case EnvironmentImages.scanQr:
      case EnvironmentImages.userGuideNextIcon:
      case EnvironmentImages.userGuidePreviousIcon:
        return "user_guide/$name";
      case EnvironmentImages.tabBarMyEsim:
      case EnvironmentImages.tabBarProfile:
      case EnvironmentImages.tabBarDataPlans:
        return "tab_bar/$name";
      case EnvironmentImages.expandFaq:
      case EnvironmentImages.collapseFaq:
      case EnvironmentImages.aboutUs:
      case EnvironmentImages.accountInformation:
      case EnvironmentImages.chevronRight:
      case EnvironmentImages.contactUs:
      case EnvironmentImages.deleteAccount:
      case EnvironmentImages.faq:
      case EnvironmentImages.language:
      case EnvironmentImages.logout:
      case EnvironmentImages.orderHistory:
      case EnvironmentImages.profilePerson:
      case EnvironmentImages.termsAndConditions:
      case EnvironmentImages.userGuide:
      case EnvironmentImages.wallet:
      case EnvironmentImages.currency:
        return "profile/$name";
      case EnvironmentImages.walletCashback:
      case EnvironmentImages.walletIcon:
      case EnvironmentImages.walletReferEarn:
      case EnvironmentImages.walletRewardHistory:
      case EnvironmentImages.walletVoucher:
      case EnvironmentImages.walletUpgrade:
      case EnvironmentImages.payByCard:
      case EnvironmentImages.payByWallet:
      case EnvironmentImages.payByDcb:
        return "wallet/$name";
      case EnvironmentImages.iconCheck:
      case EnvironmentImages.iconWarning:
      case EnvironmentImages.topUpIcon:
      case EnvironmentImages.checkBoxSelected:
      case EnvironmentImages.checkBoxUnselected:
      case EnvironmentImages.scanPromoCode:
      case EnvironmentImages.searchIcon:
      case EnvironmentImages.notificationIcon:
      case EnvironmentImages.deleteAccountIcon:
      case EnvironmentImages.compatibleIcon:
      case EnvironmentImages.inCompatibleIcon:
      case EnvironmentImages.darkArrowRight:
      case EnvironmentImages.whiteCloseIcon:
      case EnvironmentImages.checkCompatibleIcon:
      case EnvironmentImages.darkAppIcon:
      case EnvironmentImages.logoutIcon:
      case EnvironmentImages.navBackIcon:
      case EnvironmentImages.onBoardingBackground:
      case EnvironmentImages.sheetCloseIcon:
      case EnvironmentImages.whiteAppIcon:
      case EnvironmentImages.copyIcon:
      case EnvironmentImages.shareIcon:
        return "icons/$name";
      case EnvironmentImages.emptyEsims:
      case EnvironmentImages.emptyNotifications:
      case EnvironmentImages.emptyOrderHistory:
      case EnvironmentImages.emptyRewardHistory:
        return "empty_state/$name";
      case EnvironmentImages.loginMail:
      case EnvironmentImages.loginApple:
      case EnvironmentImages.loginGoogle:
      case EnvironmentImages.loginFacebook:
        return "login_icons/$name";
      case EnvironmentImages.globalFlag:
        return "flags/$name";
      case EnvironmentImages.splashIcon:
      case EnvironmentImages.headerLockup:
        return "logo/$name";
      case EnvironmentImages.storyCar:
      case EnvironmentImages.storyGirl:
      case EnvironmentImages.storyBuilding:
        return "stories/$name";
    }
  }

  String get fullImagePath {
    String rootDirectory = isSharedImage
        ? "shared"
        : AppEnvironment.appEnvironmentHelper.environmentTheme.directoryName;
    return "assets/images/$rootDirectory/$imageName.${imageType.name}";
  }
}
