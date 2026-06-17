import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_by_countries_view/bundles_by_countries_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/bundles_list_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/country_list_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/regions_list_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/widgets/custom_tab_view.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class DataPlansView extends StatelessWidget {
  DataPlansView({super.key});

  static const String routeName = "DataPlansView";

  final BundlesByCountriesViewModel bundleByCountryViewModel =
  BundlesByCountriesViewModel(
    const EsimArguments(
      id: "9651b0b3-8ace-479b-98bd-3960b6b3957b,c9cbd3ca-54c9-436f-b4d2-cf53a84c78e8",
      name: "",
      type: EsimArgumentType.country,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseView<DataPlansViewModel>(
      hideAppBar: true,
      hideLoader: true,
      disableInteractionWhileBusy: false,
      routeName: routeName,
      enableBottomSafeArea: false,
      fireOnViewModelReadyOnce: true,
      staticChild: const BannersView(),
      viewModel: locator<DataPlansViewModel>(),
      builder: (BuildContext context,
          DataPlansViewModel viewModel,
          Widget? childWidget,
          double screenHeight,) =>
          KeyboardDismissOnTap(
            child: SizedBox(
              height: double.infinity,
              child: PaddingWidget.applyPadding(
                top: 20,
                child: Column(
                  children: <Widget>[
                    PaddingWidget.applySymmetricPadding(
                      horizontal: 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            LocaleKeys.dataPlans_titleText.tr(),
                            style: headerTwoBoldTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ),
                          ),
                          getTopTrialingWidget(
                            context: context,
                            viewModel: viewModel,
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceMedium,
                    PaddingWidget.applySymmetricPadding(
                      horizontal: 15,
                      child: MainInputField.searchField(
                        controller: viewModel.searchTextFieldController,
                        themeColor: themeColor,
                        textConfig: MainInputFieldTextConfig(
                          hintText: LocaleKeys.dataPlans_SearchPlaceHolderText
                              .tr(),
                        ),
                        appearanceConfig: MainInputFieldAppearanceConfig(
                          backgroundColor: whiteBackGroundColor(context: context),
                          labelStyle: captionOneNormalTextStyle(
                            context: context,
                            fontColor: secondaryTextColor(context: context),
                          ),
                        ),
                        behaviorConfig: const MainInputFieldBehaviorConfig(
                          clearSearchEnabled: true,
                        ),
                      ),
                    ),
                    verticalSpace(15),
                    AppEnvironment.appEnvironmentHelper.isCruiseEnabled
                        ? getCruisePagerView(
                      context: context,
                      viewModel: viewModel,
                      childWidget: childWidget,
                    )
                        : getTabSection(
                      context: context,
                      viewModel: viewModel,
                      isCruiseEnabled: false,
                      childWidget: childWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget getCruisePagerView({
    required BuildContext context,
    required DataPlansViewModel viewModel,
    required Widget? childWidget,
  }) {
    final Widget? bannerWidget = DataPlansViewModel.cruiseTabBarSelectedIndex == 0 && viewModel.showBanner
        ? childWidget
        : null;

    return DataPlansTabView(
      horizontalPadding: 0,
      isChildCollapsable: true,
      isIndicatorUnderlined: true,
      onTabChange: viewModel.onCruiseTabBarChange,
      initialIndex: DataPlansViewModel.cruiseTabBarSelectedIndex,
      backGroundColor: whiteBackGroundColor(context: context),
      selectedTabColor: mainTabBackGroundColor(context: context),
      selectedLabelColor: mainDarkTextColor(context: context),
      selectedTabTextStyle: captionOneMediumTextStyle(context: context),
      childWidget: bannerWidget,
      tabs: <Tab>[
        Tab(
          text: LocaleKeys.dataPlans_onCruiseText.tr(),
        ),
        Tab(
          text: LocaleKeys.dataPlans_onLandText.tr(),
        ),
      ],
      tabViewsChildren: <Widget>[
        ColoredBox(
          color: bodyBackGroundColor(context: context),
          child: PaddingWidget.applyPadding(
            top: 15,
            end: 15,
            start: 15,
            child: viewModel.filteredCruiseBundles.isEmpty
                ? Center(
              child: Text(
                LocaleKeys.bundleDetails_emptyText.tr(),
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: emptyStateTextColor(context: context),
                ),
              ),
            )
                : BundlesListView(
              showShimmer: viewModel.isBundleServicesBusy(),
              bundles: viewModel.filteredCruiseBundles,
              hideSupportedCountries: true,
              onBundleSelected:
                  (BundleResponseModel selectedBundle) async =>
                  viewModel.navigateToEsimDetail(selectedBundle),
              lastItemBottomPadding: 90,
            ),
          ),
        ),
        Column(
          children: <Widget>[
            getTabSection(
              context: context,
              viewModel: viewModel,
              isCruiseEnabled: true,
              childWidget: childWidget,
            ),
          ],
        ),
      ],
      //childWidget: const BannersView(),
    );
  }

  Widget getTabSection({
    required BuildContext context,
    required DataPlansViewModel viewModel,
    required bool isCruiseEnabled,
    required Widget? childWidget,
  }) {
    return DataPlansTabView(
      verticalPadding: 15,
      isChildCollapsable: true,
      onTabChange: (int newIndex) async {
        viewModel.onTabBarChange(newIndex);
        if (newIndex == 1) {
          await viewModel.analyticsService
              .logEvent(event: AnalyticEvent.regionsClicked());
        }
      },
      initialIndex: DataPlansViewModel.tabBarSelectedIndex,
      childWidget: viewModel.showBanner
          ? childWidget
          : null,
      backGroundColor: bodyBackGroundColor(context: context),
      tabs: <Tab>[
        // if (isCruiseEnabled)
        //   Tab(
        //     text: LocaleKeys.dataPlans_countryTripText.tr(),
        //   ),
        Tab(
          text: LocaleKeys.dataPlans_countriesText.tr(),
        ),
        Tab(
          text: LocaleKeys.dataPlans_regionsText.tr(),
        ),
        if (!isCruiseEnabled)
          Tab(
            text: LocaleKeys.dataPlans_globalsText.tr(),
          ),
      ],
      tabViewsChildren: <Widget>[
        // if (isCruiseEnabled)
        //   BundlesByCountriesView(
        //     horizontalPadding: 0,
        //     viewModel: bundleByCountryViewModel,
        //     onBundleSelected: (BundleResponseModel selectedBundle) async =>
        //         viewModel.navigateToEsimDetail(selectedBundle),
        //   ),
        CountriesList(
          showShimmer: viewModel.isBundleServicesBusy(),
          countries: viewModel.filteredCountries,
          onCountryTap: (CountryResponseModel selectedCountry) async =>
              viewModel.navigateToCountryBundles(selectedCountry),
          lastItemBottomPadding: 90,
        ),
        RegionsList(
          showShimmer: viewModel.isBundleServicesLoading,
          regions: viewModel.filteredRegions,
          onRegionTap: (RegionsResponseModel selectedRegion) async =>
              viewModel.navigateToRegionBundles(selectedRegion),
          lastItemBottomPadding: 90,
        ),
        if (!isCruiseEnabled)
          BundlesListView(
            showShimmer: viewModel.isBundleServicesLoading,
            bundles: viewModel.filteredBundles,
            onBundleSelected: (BundleResponseModel selectedBundle) async =>
                viewModel.navigateToEsimDetail(selectedBundle),
          ),
      ],
    );
  }

  Widget getTopTrialingWidget({
    required BuildContext context,
    required DataPlansViewModel viewModel,
  }) {
    if (AppEnvironment.isFromAppClip) {
      return const SizedBox.shrink();
    } else if (viewModel.isUserLoggedIn) {
      return GestureDetector(
        onTap: () async {
          viewModel.notificationsButtonTapped();
        },
        child: Badge(
          isLabelVisible: viewModel.showNotificationBadge,
          backgroundColor: notificationBadgeColor(context: context),
          child: Image.asset(
            EnvironmentImages.notificationIcon.fullImagePath,
            width: 25,
            height: 25,
          ),
        ),
      );
    } else {
      return MainButton.bannerButton(
        params: BannerButtonParams(
          title: LocaleKeys.profile_login.tr(),
          action: () async {
            viewModel.loginButtonTapped();
          },
          themeColor: themeColor,
          titleHorizontalPadding: 15,
          textColor: enabledMainButtonTextColor(context: context),
          buttonColor: enabledMainButtonColor(context: context),
          titleTextStyle: bodyMediumTextStyle(context: context),
        ),
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<BundlesByCountriesViewModel>(
        "bundleByCountryViewModel",
        bundleByCountryViewModel,
      ),
    );
  }
}
