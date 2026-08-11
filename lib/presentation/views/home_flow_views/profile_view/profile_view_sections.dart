import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:stacked_services/stacked_services.dart";

enum ProfileViewSections {
  settingsHeader,
  accountInformation,
  myWallet,
  orderHistory,
  aboutUs,
  faq,
  contactUs,
  termsAndConditions,
  userGuide,
  language,
  currency,
  analyticsConsent,
  accountHeader,
  logout,
  deleteAccount;

  bool isViewHidden(ProfileViewModel viewModel) {
    switch (this) {
      case ProfileViewSections.currency:
        return !AppEnvironment.appEnvironmentHelper.enableCurrencySelection;
      case ProfileViewSections.myWallet:
        if (viewModel.isUserLoggedIn &&
            AppEnvironment.appEnvironmentHelper.enableWalletView) {
          return false;
        }
        return true;
      case ProfileViewSections.logout:
      case ProfileViewSections.orderHistory:
      case ProfileViewSections.accountHeader:
      case ProfileViewSections.deleteAccount:
      case ProfileViewSections.accountInformation:
        if (viewModel.isUserLoggedIn) {
          return false;
        }
        return true;
      case ProfileViewSections.language:
        return !AppEnvironment.appEnvironmentHelper.enableLanguageSelection;
      default:
        return false;
    }
  }

  bool get isHeaderTitle {
    switch (this) {
      case ProfileViewSections.accountHeader:
      case ProfileViewSections.settingsHeader:
        return true;
      default:
        return false;
    }
  }

  String get sectionTitle {
    switch (this) {
      case ProfileViewSections.settingsHeader:
        return LocaleKeys.profile_settings.tr();
      case ProfileViewSections.accountInformation:
        return LocaleKeys.profile_accountInformation.tr();
      case ProfileViewSections.myWallet:
        return LocaleKeys.profile_myWallet.tr();
      case ProfileViewSections.orderHistory:
        return LocaleKeys.profile_orderHistory.tr();
      case ProfileViewSections.aboutUs:
        return LocaleKeys.profile_aboutUs.tr();
      case ProfileViewSections.faq:
        return LocaleKeys.profile_faq.tr();
      case ProfileViewSections.contactUs:
        return LocaleKeys.profile_contactUs.tr();
      case ProfileViewSections.termsAndConditions:
        return LocaleKeys.profile_termsConditions.tr();
      case ProfileViewSections.userGuide:
        return LocaleKeys.profile_userGuide.tr();
      case ProfileViewSections.language:
        return LocaleKeys.profile_language.tr();
      case ProfileViewSections.currency:
        return LocaleKeys.profile_currency.tr();
      case ProfileViewSections.analyticsConsent:
        return LocaleKeys.analyticsConsent_settingsTitle.tr();
      case ProfileViewSections.accountHeader:
        return LocaleKeys.profile_account.tr();
      case ProfileViewSections.logout:
        return LocaleKeys.profile_logout.tr();
      case ProfileViewSections.deleteAccount:
        return LocaleKeys.profile_delete.tr();
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _sectionImage,
        orElse: () => EnvironmentImages.language,
      )
      .fullImagePath;

  String get _sectionImage {
    switch (this) {
      case ProfileViewSections.settingsHeader:
        return "";
      case ProfileViewSections.accountInformation:
        return "accountInformation";
      case ProfileViewSections.myWallet:
        return "wallet";
      case ProfileViewSections.orderHistory:
        return "orderHistory";
      case ProfileViewSections.aboutUs:
        return "aboutUs";
      case ProfileViewSections.faq:
        return "faq";
      case ProfileViewSections.contactUs:
        return "contactUs";
      case ProfileViewSections.termsAndConditions:
        return "termsAndConditions";
      case ProfileViewSections.userGuide:
        return "userGuide";
      case ProfileViewSections.language:
        return "language";
      case ProfileViewSections.currency:
        return "currency";
      case ProfileViewSections.analyticsConsent:
        return "analytics";
      case ProfileViewSections.accountHeader:
        return "";
      case ProfileViewSections.logout:
        return "logout";
      case ProfileViewSections.deleteAccount:
        return "deleteAccount";
    }
  }

  Future<void> tapAction(ProfileViewModel viewModel) async {
    switch (this) {
      case ProfileViewSections.accountInformation:
        viewModel.navigationService
            .navigateTo(AccountInformationView.routeName);
      case ProfileViewSections.myWallet:
        viewModel.navigationService.navigateTo(MyWalletView.routeName);
      case ProfileViewSections.faq:
        viewModel.navigationService.navigateTo(FaqView.routeName);
      case ProfileViewSections.contactUs:
        viewModel.analyticsService
            .logEvent(event: AnalyticEvent.contactUsClicked());
        viewModel.navigationService.navigateTo(ContactUsView.routeName);
      case ProfileViewSections.orderHistory:
        viewModel.navigationService.navigateTo(OrderHistoryView.routeName);
      case ProfileViewSections.aboutUs:
        viewModel.navigationService.navigateTo(
          DynamicDataView.routeName,
          arguments: DynamicDataViewType.aboutUs,
        );
      case ProfileViewSections.termsAndConditions:
        viewModel.navigationService.navigateTo(
          DynamicDataView.routeName,
          arguments: DynamicDataViewType.termsConditions,
        );
      case ProfileViewSections.userGuide:
        viewModel.analyticsService
            .logEvent(event: AnalyticEvent.userGuideOpened());
        viewModel.navigationService.navigateTo(
          UserGuideView.routeName,
        );
      case ProfileViewSections.currency:
        viewModel.navigationService.navigateTo(
          DynamicSelectionView.routeName,
          arguments: CurrenciesDataSource(),
        );
      case ProfileViewSections.language:
        viewModel.navigationService.navigateTo(
          DynamicSelectionView.routeName,
          arguments: LanguagesDataSource(),
        );
      case ProfileViewSections.analyticsConsent:
        log("Tapped $sectionTitle");
      case ProfileViewSections.logout:
        SheetResponse<EmptyBottomSheetResponse>? logoutResponse =
            await viewModel.bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.logout,
        );
        if (logoutResponse?.confirmed ?? false) {
          await viewModel.logoutUser();
        }
      case ProfileViewSections.deleteAccount:
        SheetResponse<EmptyBottomSheetResponse>? deleteAccountResponse =
            await viewModel.bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.deleteAccount,
        );
        if (deleteAccountResponse?.confirmed ?? false) {
          await viewModel.logoutUser();
        }
      default:
        log("Tapped $sectionTitle");
    }
  }
}
