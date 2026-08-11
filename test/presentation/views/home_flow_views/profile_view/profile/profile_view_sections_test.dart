import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "ProfileView");
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("ProfileViewSections Tests", () {
    late ProfileViewModel viewModel;

    setUp(() {
      viewModel = ProfileViewModel();
    });

    test("tap action myWallet", () async {
      when(locator<NavigationService>().navigateTo(MyWalletView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.myWallet.tapAction(viewModel);
    });
    test("tap action faq", () async {
      when(locator<NavigationService>().navigateTo(FaqView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.faq.tapAction(viewModel);
    });
    test("tap action ContactUsView", () async {
      when(locator<NavigationService>().navigateTo(ContactUsView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.contactUs.tapAction(viewModel);
    });
    test("tap action OrderHistoryView", () async {
      when(locator<NavigationService>().navigateTo(OrderHistoryView.routeName))
          .thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.orderHistory.tapAction(viewModel);
    });
    test("tap action aboutUs", () async {
      when(
        locator<NavigationService>().navigateTo(
          DynamicDataView.routeName,
          arguments: DynamicDataViewType.aboutUs,
        ),
      ).thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.aboutUs.tapAction(viewModel);
    });

    test("tap action termsCondition", () async {
      when(
        locator<NavigationService>().navigateTo(
          DynamicDataView.routeName,
          arguments: DynamicDataViewType.termsConditions,
        ),
      ).thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.termsAndConditions.tapAction(viewModel);
    });

    test("tap action userGuide", () async {
      when(
        locator<NavigationService>().navigateTo(
          UserGuideView.routeName,
        ),
      ).thenAnswer((_) {
        return null;
      });
      await ProfileViewSections.userGuide.tapAction(viewModel);
    });

    test("tap action logout", () async {
      when(
        locator<BottomSheetService>().showCustomSheet<EmptyBottomSheetResponse,
            ConfirmationSheetRequest>(
          enableDrag: false,
          isScrollControlled: true,
          data: anyNamed("data"),
          variant: BottomSheetType.logout,
        ),
      ).thenAnswer((_) async => null);
      await ProfileViewSections.logout.tapAction(viewModel);
    });

    test("tap action deleteAccount", () async {
      when(
        locator<BottomSheetService>().showCustomSheet<EmptyBottomSheetResponse,
            ConfirmationSheetRequest>(
          enableDrag: false,
          isScrollControlled: true,
          data: anyNamed("data"),
          variant: BottomSheetType.deleteAccount,
        ),
      ).thenAnswer((_) async =>
          SheetResponse<EmptyBottomSheetResponse>(),);
      await ProfileViewSections.deleteAccount.tapAction(viewModel);
    });

    group("Enum Values", () {
      test("all enum values exist", () {
        const List<ProfileViewSections> expectedSections =
            <ProfileViewSections>[
          ProfileViewSections.settingsHeader,
          ProfileViewSections.accountInformation,
          ProfileViewSections.myWallet,
          ProfileViewSections.orderHistory,
          ProfileViewSections.aboutUs,
          ProfileViewSections.faq,
          ProfileViewSections.contactUs,
          ProfileViewSections.termsAndConditions,
          ProfileViewSections.userGuide,
          ProfileViewSections.language,
          ProfileViewSections.currency,
          ProfileViewSections.analyticsConsent,
          ProfileViewSections.accountHeader,
          ProfileViewSections.logout,
          ProfileViewSections.deleteAccount,
        ];

        expect(ProfileViewSections.values, expectedSections);
      });
    });

    group("isViewHidden Tests", () {
      test("currency section hidden when currency selection disabled", () {
        // Mock environment to disable currency selection
        AppEnvironment.appEnvironmentHelper.enableCurrencySelection = false;

        final bool isHidden =
            ProfileViewSections.currency.isViewHidden(viewModel);

        expect(isHidden, isTrue);
      });

      test("currency section visible when currency selection enabled", () {
        // Mock environment to enable currency selection
        AppEnvironment.appEnvironmentHelper.enableCurrencySelection = true;

        final bool isHidden =
            ProfileViewSections.currency.isViewHidden(viewModel);

        expect(isHidden, isFalse);
      });

      test("user-dependent sections work with different login states", () {
        // Test that isViewHidden method can be called for user-dependent sections
        const List<ProfileViewSections> userDependentSections =
            <ProfileViewSections>[
          ProfileViewSections.myWallet,
          ProfileViewSections.logout,
          ProfileViewSections.orderHistory,
          ProfileViewSections.accountHeader,
          ProfileViewSections.deleteAccount,
          ProfileViewSections.accountInformation,
        ];

        for (final ProfileViewSections section in userDependentSections) {
          expect(() => section.isViewHidden(viewModel), returnsNormally);
        }
      });

      test("language section hidden when language selection disabled", () {
        AppEnvironment.appEnvironmentHelper.enableLanguageSelection = false;

        final bool isHidden =
            ProfileViewSections.language.isViewHidden(viewModel);

        expect(isHidden, isTrue);
      });

      test("language section visible when language selection enabled", () {
        AppEnvironment.appEnvironmentHelper.enableLanguageSelection = true;

        final bool isHidden =
            ProfileViewSections.language.isViewHidden(viewModel);

        expect(isHidden, isFalse);
      });

      test("default sections are visible", () {
        const List<ProfileViewSections> defaultVisibleSections =
            <ProfileViewSections>[
          ProfileViewSections.settingsHeader,
          ProfileViewSections.aboutUs,
          ProfileViewSections.faq,
          ProfileViewSections.contactUs,
          ProfileViewSections.termsAndConditions,
          ProfileViewSections.userGuide,
        ];

        for (final ProfileViewSections section in defaultVisibleSections) {
          final bool isHidden = section.isViewHidden(viewModel);
          expect(isHidden, isFalse,
              reason: "Section ${section.name} should be visible by default",);
        }
      });
    });

    group("isHeaderTitle Tests", () {
      test("accountHeader is header title", () {
        expect(ProfileViewSections.accountHeader.isHeaderTitle, isTrue);
      });

      test("settingsHeader is header title", () {
        expect(ProfileViewSections.settingsHeader.isHeaderTitle, isTrue);
      });

      test("non-header sections return false", () {
        const List<ProfileViewSections> nonHeaderSections =
            <ProfileViewSections>[
          ProfileViewSections.accountInformation,
          ProfileViewSections.myWallet,
          ProfileViewSections.orderHistory,
          ProfileViewSections.aboutUs,
          ProfileViewSections.faq,
          ProfileViewSections.contactUs,
          ProfileViewSections.termsAndConditions,
          ProfileViewSections.userGuide,
          ProfileViewSections.language,
          ProfileViewSections.currency,
          ProfileViewSections.logout,
          ProfileViewSections.deleteAccount,
        ];

        for (final ProfileViewSections section in nonHeaderSections) {
          expect(section.isHeaderTitle, isFalse,
              reason: "Section ${section.name} should not be header title",);
        }
      });
    });

    group("sectionTitle Tests", () {
      test("all sections return correct localized titles", () {
        expect(ProfileViewSections.settingsHeader.sectionTitle,
            equals(LocaleKeys.profile_settings.tr()),);
        expect(ProfileViewSections.accountInformation.sectionTitle,
            equals(LocaleKeys.profile_accountInformation.tr()),);
        expect(ProfileViewSections.myWallet.sectionTitle,
            equals(LocaleKeys.profile_myWallet.tr()),);
        expect(ProfileViewSections.orderHistory.sectionTitle,
            equals(LocaleKeys.profile_orderHistory.tr()),);
        expect(ProfileViewSections.aboutUs.sectionTitle,
            equals(LocaleKeys.profile_aboutUs.tr()),);
        expect(ProfileViewSections.faq.sectionTitle,
            equals(LocaleKeys.profile_faq.tr()),);
        expect(ProfileViewSections.contactUs.sectionTitle,
            equals(LocaleKeys.profile_contactUs.tr()),);
        expect(ProfileViewSections.termsAndConditions.sectionTitle,
            equals(LocaleKeys.profile_termsConditions.tr()),);
        expect(ProfileViewSections.userGuide.sectionTitle,
            equals(LocaleKeys.profile_userGuide.tr()),);
        expect(ProfileViewSections.language.sectionTitle,
            equals(LocaleKeys.profile_language.tr()),);
        expect(ProfileViewSections.currency.sectionTitle,
            equals(LocaleKeys.profile_currency.tr()),);
        expect(ProfileViewSections.accountHeader.sectionTitle,
            equals(LocaleKeys.profile_account.tr()),);
        expect(ProfileViewSections.logout.sectionTitle,
            equals(LocaleKeys.profile_logout.tr()),);
        expect(ProfileViewSections.deleteAccount.sectionTitle,
            equals(LocaleKeys.profile_delete.tr()),);
      });
    });

    group("sectionImagePath Tests", () {
      test("sections return correct image paths", () {
        expect(ProfileViewSections.accountInformation.sectionImagePath,
            equals(EnvironmentImages.accountInformation.fullImagePath),);
        expect(ProfileViewSections.myWallet.sectionImagePath,
            equals(EnvironmentImages.wallet.fullImagePath),);
        expect(ProfileViewSections.orderHistory.sectionImagePath,
            equals(EnvironmentImages.orderHistory.fullImagePath),);
        expect(ProfileViewSections.aboutUs.sectionImagePath,
            equals(EnvironmentImages.aboutUs.fullImagePath),);
        expect(ProfileViewSections.faq.sectionImagePath,
            equals(EnvironmentImages.faq.fullImagePath),);
        expect(ProfileViewSections.contactUs.sectionImagePath,
            equals(EnvironmentImages.contactUs.fullImagePath),);
        expect(ProfileViewSections.termsAndConditions.sectionImagePath,
            equals(EnvironmentImages.termsAndConditions.fullImagePath),);
        expect(ProfileViewSections.userGuide.sectionImagePath,
            equals(EnvironmentImages.userGuide.fullImagePath),);
        expect(ProfileViewSections.language.sectionImagePath,
            equals(EnvironmentImages.language.fullImagePath),);
        expect(ProfileViewSections.currency.sectionImagePath,
            equals(EnvironmentImages.currency.fullImagePath),);
        expect(ProfileViewSections.logout.sectionImagePath,
            equals(EnvironmentImages.logout.fullImagePath),);
        expect(ProfileViewSections.deleteAccount.sectionImagePath,
            equals(EnvironmentImages.deleteAccount.fullImagePath),);
      });

      test("header sections return default language image path", () {
        expect(ProfileViewSections.settingsHeader.sectionImagePath,
            equals(EnvironmentImages.language.fullImagePath),);
        expect(ProfileViewSections.accountHeader.sectionImagePath,
            equals(EnvironmentImages.language.fullImagePath),);
      });
    });

    group("_sectionImage Tests", () {
      test("sections return correct image names", () {
        // Access private getter through sectionImagePath
        expect(ProfileViewSections.accountInformation.sectionImagePath,
            contains("accountInformation"),);
        expect(
            ProfileViewSections.myWallet.sectionImagePath, contains("wallet"),);
        expect(ProfileViewSections.orderHistory.sectionImagePath,
            contains("orderHistory"),);
        expect(
            ProfileViewSections.aboutUs.sectionImagePath, contains("aboutUs"),);
        expect(ProfileViewSections.faq.sectionImagePath, contains("faq"));
        expect(ProfileViewSections.contactUs.sectionImagePath,
            contains("contactUs"),);
        expect(ProfileViewSections.termsAndConditions.sectionImagePath,
            contains("termsAndConditions"),);
        expect(ProfileViewSections.userGuide.sectionImagePath,
            contains("userGuide"),);
        expect(ProfileViewSections.language.sectionImagePath,
            contains("language"),);
        expect(ProfileViewSections.currency.sectionImagePath,
            contains("currency"),);
        expect(ProfileViewSections.logout.sectionImagePath, contains("logout"));
        expect(ProfileViewSections.deleteAccount.sectionImagePath,
            contains("deleteAccount"),);
      });
    });
  });
}
