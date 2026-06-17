import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/e_sim_current_plan_item.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/e_sim_expired_plan_item.dart";
import "package:esim_open_source/presentation/widgets/custom_tab_view.dart";
import "package:esim_open_source/presentation/widgets/empty_content.dart";
import "package:esim_open_source/presentation/widgets/empty_state_list_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MyESimView extends StatelessWidget {
  const MyESimView({super.key, this.onRequestDataPlansTab});

  static const String routeName = "MyEsimView";
  final void Function()? onRequestDataPlansTab;

  @override
  Widget build(BuildContext context) {
    return BaseView<MyESimViewModel>(
      routeName: routeName,
      hideAppBar: true,
      disableInteractionWhileBusy: false,
      enableBottomSafeArea: false,
      hideLoader: true,
      fireOnViewModelReadyOnce: true,
      viewModel: locator<MyESimViewModel>(),
      builder: (
        BuildContext context,
        MyESimViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        return _buildBodyPage(
          context,
          viewModel,
          screenHeight,
        );
      },
    );
  }

  Widget _buildBodyPage(
    BuildContext context,
    MyESimViewModel viewModel,
    double screenHeight,
  ) {
    return PaddingWidget.applyPadding(
      top: 20,
      child: Column(
        children: <Widget>[
          PaddingWidget.applySymmetricPadding(
            horizontal: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  LocaleKeys.myESim_titleText.tr(),
                  style: headerTwoBoldTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    viewModel.notificationsButtonTapped();
                  },
                  child: Badge(
                    isLabelVisible: viewModel.state.showNotificationBadge,
                    backgroundColor: context.appColors.indigo_700,
                    child: Image.asset(
                      EnvironmentImages.notificationIcon.fullImagePath,
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          DataPlansTabView(
            verticalPadding: 15,
            onTabChange: (int newIndex) => viewModel.setTabIndex = newIndex,
            initialIndex: viewModel.state.selectedTabIndex,
            childWidget: verticalSpaceSmall,
            backGroundColor: bodyBackGroundColor(context: context),
            tabs: <Tab>[
              Tab(
                text: LocaleKeys.current_plans.tr(),
              ),
              Tab(
                text: LocaleKeys.expired_plans.tr(),
              ),
            ],
            tabViewsChildren: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _currentPlans(context, viewModel),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _expiredPlans(context, viewModel),
                  ),
                ],
              ),
            ],
            isScrollable: true,
            //childWidget: const BannersView(),
          ),
        ],
      ),
    );
  }

  Widget _currentPlans(
    BuildContext context,
    MyESimViewModel viewModel,
  ) {
    return EmptyStateListView<PurchaseEsimBundleResponseModel>(
      items: viewModel.state.currentESimList,
      onRefresh: viewModel.refreshCurrentPlans,
      emptyStateWidget: SizedBox(
        height: 400,
        child: EmptyCurrentPlansContent(
          onCheckOurPlansClick: viewModel.openDataPlans,
        ),
      ),
      itemBuilder: (BuildContext context, int index) {
        final PurchaseEsimBundleResponseModel item =
            viewModel.state.currentESimList[index];

        return Column(
          children: <Widget>[
            ESimCurrentPlanItem(
              status: item.getStatusText(),
              showUnlimitedData: item.unlimited ?? false,
              statusTextColor: item.getStatusTextColor(context),
              statusBgColor: item.getStatusBgColor(context),
              countryCode: "",
              title: item.getDisplayName() ?? "" ,
              subTitle: item.displaySubtitle ?? "",
              dataValue: item.gprsLimitDisplay ?? "",
              showInstallButton: viewModel.state.showInstallButton,
              showTopUpButton: item.isTopupAllowed ?? true,
              iconPath: (item.bundleCategory?.isCruise ?? false)
                  ? EnvironmentImages.globalFlag.fullImagePath
                  : item.icon ?? "",
              price: "",
              validity: item.getValidityDisplay() ?? "",
              expiryDate: DateTimeUtils.formatTimestampToDate(
                timestamp: int.parse(item.paymentDate ?? "0"),
                format: DateTimeUtils.ddMmYyyy,
              ),
              supportedCountries: (item.bundleCategory?.isCruise ?? false)
                  ? <CountryResponseModel>[]
                  : item.countries ?? <CountryResponseModel>[],
              onEditName: () =>
                  unawaited(viewModel.onEditNameClick(iccid: item.iccid ?? "")),
              onTopUpClick: () =>
                  unawaited(viewModel.onTopUpClick(iccid: item.iccid ?? "")),
              onConsumptionClick: () async =>
                  viewModel.onConsumptionClick(iccid: item.iccid ?? ""),
              onQrCodeClick: () async => viewModel.onQrCodeClick(iccid: item.iccid ?? ""),
              onInstallClick: () async =>
                  viewModel.onInstallClick(iccid: item.iccid ?? ""),
              isLoading: viewModel.isBusy,
              onItemClick: () =>
                  unawaited(viewModel.onCurrentBundleClick(iccid: item.iccid ?? "")),
            ),
            (index == viewModel.state.currentESimList.length - 1)
                ? const SizedBox(height: 90)
                : Container(),
          ],
        );
      },
    );
  }

  Widget _expiredPlans(
    BuildContext context,
    MyESimViewModel viewModel,
  ) {
    return EmptyStateListView<PurchaseEsimBundleResponseModel>(
      items: viewModel.state.expiredESimList,
      onRefresh: viewModel.refreshCurrentPlans,
      emptyStateWidget: SizedBox(
        height: 400,
        child: EmptyExpiredPlansContent(
          onCheckOurPlansClick: viewModel.openDataPlans,
        ),
      ),
      itemBuilder: (BuildContext context, int index) {
        final PurchaseEsimBundleResponseModel item =
            viewModel.state.expiredESimList[index];

        return Column(
          children: <Widget>[
            ESimExpiredPlanItem(
              countryCode: "",
              showUnlimitedData: item.unlimited ?? false,
              title: item.displayTitle ?? "",
              subTitle: item.displaySubtitle ?? "",
              dataValue: item.gprsLimitDisplay ?? "",
              price: "",
              validity: item.getValidityDisplay() ?? "",
              expiryDate: DateTimeUtils.formatTimestampToDate(
                timestamp: int.parse(item.paymentDate ?? "0"),
                format: DateTimeUtils.ddMmYyyy,
              ),
              isLoading: viewModel.isBusy,
              iconPath: item.icon,
              onItemClick: () =>
                  unawaited(viewModel.onExpiredBundleClick(iccid: item.iccid ?? "")),
            ),
            (index == viewModel.state.expiredESimList.length - 1)
                ? const SizedBox(height: 90)
                : Container(),
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<void Function()?>.has(
        "onRequestDataPlansTab",
        onRequestDataPlansTab,
      ),
    );
  }
}
