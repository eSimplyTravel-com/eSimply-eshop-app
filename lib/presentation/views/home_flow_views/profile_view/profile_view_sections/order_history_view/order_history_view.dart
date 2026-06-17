import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view_model.dart";
import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_validity_view.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_paginated_state_list_view.dart";
import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/material.dart";

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  static const String routeName = "OrderHistoryView";

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderHistoryViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: locator<OrderHistoryViewModel>(),
      builder: (
        BuildContext context,
        OrderHistoryViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applyPadding(
        top: 20,
        child: Column(
          children: <Widget>[
            CommonNavigationTitle(
              navigationTitle: LocaleKeys.orderHistory_titleText.tr(),
              textStyle: headerTwoBoldTextStyle(
                context: context,
                fontColor: mainDarkTextColor(context: context),
              ),
            ),
            Expanded(
              child: PaddingWidget.applySymmetricPadding(
                vertical: 25,
                horizontal: 15,
                child: EmptyPaginatedStateListView<OrderHistoryResponseModel>(
                  emptyStateWidget: EmptyStateWidget(
                    title: LocaleKeys.orderHistory_emptyTitleText.tr(),
                    content: LocaleKeys.orderHistory_emptyContentText.tr(),
                    imagePath:
                        EnvironmentImages.emptyOrderHistory.fullImagePath,
                  ),
                  paginationService:
                      viewModel.getOrderHistoryUseCase.paginationService,
                  onRefresh: viewModel.refreshOrderHistory,
                  onLoadItems: viewModel.getOrderHistory,
                  loadingWidget: getShimmerData(),
                  separatorBuilder: (BuildContext context, int index) =>
                      verticalSpaceSmallMedium,
                  builder: (OrderHistoryResponseModel item) {
                    return bundleOrderHistoryView(
                      context: context,
                      viewModel: viewModel,
                      bundleOrder: item,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getShimmerData() {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (BuildContext context, int index) => verticalSpaceSmall,
      itemBuilder: (BuildContext context, int index) => const SizedBox(
        width: double.infinity,
        height: 120,
      ).applyShimmer(
        params: ShimmerParams(
          enable: true,
          context: context,
        ),
      ),
    );
  }

  Widget bundleOrderHistoryView({
    required BuildContext context,
    required OrderHistoryViewModel viewModel,
    required OrderHistoryResponseModel bundleOrder,
  }) {
    return GestureDetector(
      onTap: () async => viewModel.orderTapped(bundleOrder),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: mainBorderColor(context: context),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: PaddingWidget.applyPadding(
          top: 15,
          bottom: 15,
          start: 20,
          end: 15,
          child: Column(
            children: <Widget>[
              BundleHeaderView(
                title: bundleOrder.bundleDetails?.displayTitle ?? "",
                subTitle: bundleOrder.bundleDetails?.displaySubtitle ?? "",
                dataValue: bundleOrder.bundleDetails?.gprsLimitDisplay ?? "",
                countryPrice: bundleOrder.bundleDetails?.priceDisplay ?? "",
                imagePath: (bundleOrder.bundleDetails?.isCruise ?? false)
                    ? EnvironmentImages.globalFlag.fullImagePath
                    : bundleOrder.bundleDetails?.icon ?? "",
                isLoading: false,
                showUnlimitedData:
                    bundleOrder.bundleDetails?.unlimited ?? false,
              ),
              Divider(
                color: mainBorderColor(context: context),
              ),
              verticalSpaceTiny,
              BundleValidityView(
                bundleValidity:
                    bundleOrder.bundleDetails?.getValidityDisplay() ?? "",
                bundleExpiryDate: DateTimeUtils.formatTimestampToDate(
                  timestamp: int.parse(bundleOrder.orderDate ?? "0"),
                  format: DateTimeUtils.ddMmYyyy,
                ),
              ),
            ],
          ),
        ).applyShimmer(
          params: ShimmerParams(
            context: context,
            enable: viewModel.applyShimmer,
            height: viewModel.shimmerHeight,
          ),
        ),
      ),
    );
  }
}
