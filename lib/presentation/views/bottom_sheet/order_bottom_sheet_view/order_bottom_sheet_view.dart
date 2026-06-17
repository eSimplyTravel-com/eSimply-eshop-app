import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_bottom_sheet_view/order_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_title_content_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_validity_view.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class OrderBottomSheetView extends StatelessWidget {
  const OrderBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });
  final SheetRequest<OrderHistoryResponseModel> requestBase;
  final Function(SheetResponse<OrderHistoryResponseModel>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: locator<OrderBottomSheetViewModel>()
        ..completer = completer
        ..initBundleOrderModel = requestBase.data,
      builder: (
        BuildContext context,
        OrderBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        height: screenHeight,
        width: screenWidth(context),
        child: PaddingWidget.applySymmetricPadding(
          vertical: 15,
          horizontal: 15,
          child: Column(
            children: <Widget>[
              BottomSheetCloseButton(
                onTap: () => completer(
                  SheetResponse<OrderHistoryResponseModel>(),
                ),
              ),
              verticalSpaceSmallMedium,
              BundleHeaderView(
                hasNavArrow: false,
                title: viewModel
                        .initBundleOrderModel?.bundleDetails?.displayTitle ??
                    "",
                subTitle: viewModel
                        .initBundleOrderModel?.bundleDetails?.displaySubtitle ??
                    "",
                dataValue: viewModel.initBundleOrderModel?.bundleDetails
                        ?.gprsLimitDisplay ??
                    "",
                countryPrice: viewModel
                        .initBundleOrderModel?.bundleDetails?.priceDisplay ??
                    "",
                imagePath:
                    viewModel.initBundleOrderModel?.bundleDetails?.icon ?? "",
                isLoading: false,
                showUnlimitedData:
                    viewModel.initBundleOrderModel?.bundleDetails?.unlimited ??
                        false,
              ),
              verticalSpaceSmall,
              Divider(
                color: mainBorderColor(context: context),
              ),
              verticalSpaceSmall,
              BundleValidityView(
                bundleValidity: viewModel
                        .initBundleOrderModel?.bundleDetails?.getValidityDisplay() ??
                    "",
                bundleExpiryDate: DateTimeUtils.formatTimestampToDate(
                  timestamp: int.parse(
                    viewModel.initBundleOrderModel?.orderDate ?? "0",
                  ),
                  format: DateTimeUtils.ddMmYyyy,
                ),
              ),
              verticalSpaceSmall,
              Divider(
                color: mainBorderColor(context: context),
              ),
              BundleTitleContentView(
                titleText: LocaleKeys.orderBottomSheet_orderID.tr(),
                contentText: viewModel.bundleOrderModel?.orderNumber ?? "",
                showShimmer: viewModel.applyShimmer,
              ),
              Divider(
                color: mainBorderColor(context: context),
              ),
              BundleTitleContentView(
                titleText: LocaleKeys.orderBottomSheet_paymentDetails.tr(),
                contentText:
                    viewModel.bundleOrderModel?.paymentDetails?.cardDisplay ??
                        "",
                showShimmer: viewModel.applyShimmer,
              ),
              Divider(
                color: mainBorderColor(context: context),
              ),
              BundleTitleContentView(
                titleText: LocaleKeys.orderBottomSheet_orderStatus.tr(),
                contentText: viewModel.bundleOrderModel?.orderStatus ?? "",
                showShimmer: viewModel.applyShimmer,
              ),
              Divider(
                color: mainBorderColor(context: context),
              ),
              const Spacer(),
              MainButton(
                title: LocaleKeys.orderBottomSheet_viewReceipt.tr(),
                onPressed: () => completer(
                  SheetResponse<OrderHistoryResponseModel>(
                    confirmed: true,
                    data: viewModel.bundleOrderModel,
                  ),
                ),
                isEnabled: viewModel.isButtonEnabled,
                hideShadows: true,
                themeColor: themeColor,
                enabledTextColor: enabledMainButtonTextColor(context: context),
                enabledBackgroundColor:
                    enabledMainButtonColor(context: context),
                disabledTextColor:
                    disabledMainButtonTextColor(context: context),
                disabledBackgroundColor:
                    disabledMainButtonColor(context: context),
                titleTextStyle: bodyBoldTextStyle(
                  context: context,
                  fontColor: mainWhiteTextColor(context: context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<dynamic>>(
          "requestBase",
          requestBase,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<OrderHistoryResponseModel> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
