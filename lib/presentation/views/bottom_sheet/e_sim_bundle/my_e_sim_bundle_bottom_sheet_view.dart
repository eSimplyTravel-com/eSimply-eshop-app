import "package:easy_localization/easy_localization.dart"
    show StringTranslateExtension;
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/transaction_history_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle/my_e_sim_bundle_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_qr_code/qr_code_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_divider_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_info_column_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_info_row_view.dart";
import "package:esim_open_source/presentation/widgets/animated_half_circular_progress_indicator.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/presentation/widgets/my_card_wrap.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_card.dart";
import "package:esim_open_source/presentation/widgets/top_up_button.dart";
import "package:esim_open_source/presentation/widgets/unlimited_data_widget.dart";
import "package:esim_open_source/presentation/widgets/warning_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class MyESimBundleBottomSheetView extends StatelessWidget {
  const MyESimBundleBottomSheetView({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<MyESimBundleRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: locator<MyESimBundleBottomSheetViewModel>()
        ..request = request
        ..completer = completer,
      builder: (
        BuildContext context,
        MyESimBundleBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            DecoratedBox(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: SizedBox(
                width: screenWidth(context),
                child: PaddingWidget.applySymmetricPadding(
                  vertical: 15,
                  horizontal: 20,
                  child: Column(
                    children: <Widget>[
                      buildTopHeader(
                        context,
                        viewModel.state.item,
                      ),
                      verticalSpaceSmallMedium,
                      const BundleDivider(
                        verticalPadding: 0,
                      ),
                      SizedBox(
                        height: screenHeight - 100,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              verticalSpaceSmallMedium,
                              //qr code details title
                              BundleInfoRow(
                                validity: viewModel.state.item
                                        ?.getValidityDisplay() ??
                                    "",
                                expiryDate: DateTimeUtils.formatTimestampToDate(
                                  timestamp: int.parse(
                                    viewModel.state.item?.paymentDate ?? "0",
                                  ),
                                  format: DateTimeUtils.ddMmYyyy,
                                ),
                                isLoading: false,
                              ),
                              verticalSpaceSmall,
                              viewModel.isCruise()
                                  ? Container()
                                  : SupportedCountriesCard(
                                      countries:
                                          viewModel.state.item?.countries ??
                                              <CountryResponseModel>[],
                                    ),
                              verticalSpaceSmall,
                              WarningWidget(
                                warningTextContent:
                                    LocaleKeys.esim_warning.tr(),
                              ),
                              verticalSpaceSmall,
                              buildAccountInfo(
                                context,
                                viewModel.state.item,
                                viewModel.state.expiryDate,
                              ),
                              verticalSpaceSmall,
                              buildConsumption(
                                context,
                                viewModel,
                              ),
                              verticalSpaceMedium,
                              buildPlanHistory(
                                  context, viewModel.state.item, viewModel,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildTopHeader(
    BuildContext context,
    PurchaseEsimBundleResponseModel? item,
  ) {
    return Column(
      spacing: 12,
      children: <Widget>[
        BottomSheetCloseButton(
          onTap: () => completer(SheetResponse<MainBottomSheetResponse>()),
        ),
        BundleHeaderView(
          title: item?.getDisplayName() ?? "",
          subTitle: item?.displaySubtitle ?? "",
          dataValue: item?.gprsLimitDisplay ?? "",
          isLoading: false,
          hasNavArrow: false,
          imagePath: (item?.bundleCategory?.isCruise ?? false)
              ? EnvironmentImages.globalFlag.fullImagePath
              : item?.icon ?? "",
          showUnlimitedData: item?.unlimited ?? false,
        ),
      ],
    );
  }

  Widget buildAccountInfo(
    BuildContext context,
    PurchaseEsimBundleResponseModel? item,
    String? expiryDate,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      color: lightGreyBackGroundColor(context: context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: SizedBox(
        width: screenWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PaddingWidget.applySymmetricPadding(
              vertical: 12,
              horizontal: 12,
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocaleKeys.accountInformation_titleText.tr(),
                    style: captionOneMediumTextStyle(
                      context: context,
                      fontColor: mainDarkTextColor(context: context),
                    ),
                  ),
                  (expiryDate != null && expiryDate.isNotEmpty)
                      ? () {
                          final String validityLabel = isRTL(context)
                              ? "${LocaleKeys.esim_validity.tr()} eSIM"
                              : LocaleKeys.esim_validity.tr();
                          return Column(
                            children: <Widget>[
                              verticalSpaceSmall,
                              BundleInfoColumn(
                                label: validityLabel,
                                value: expiryDate,
                              ),
                            ],
                          );
                        }()
                      : Container(),
                  buildInfoRow(
                    context: context,
                    label: LocaleKeys.iccid_number.tr(),
                    value: item?.iccid ?? "",
                    isLoading: false,
                  ),
                  buildInfoRow(
                    context: context,
                    label: LocaleKeys.order_id.tr(),
                    value: item?.orderNumber ?? "",
                    isLoading: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConsumption(
    BuildContext context,
    MyESimBundleBottomSheetViewModel viewModel,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      color: lightGreyBackGroundColor(context: context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: screenWidth(context),
          child: Column(
            spacing: 12,
            children: <Widget>[
              Text(
                LocaleKeys.consumption.tr(),
                style: captionTwoBoldTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ).textSupportsRTL(context),
              viewModel.state.item?.unlimited ?? false
                  ? buildConsumptionBodyUnlimited(context, viewModel)
                  : buildConsumptionBodyLimited(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConsumptionBodyLimited(
    BuildContext context,
    MyESimBundleBottomSheetViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: screenWidth(context),
          height: screenWidth(context) / 2,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: screenWidth(context),
                  height: screenWidth(context),
                  child: AnimatedHalfCircularProgressIndicator(
                    targetValue: viewModel.state.consumption,
                    valueColor: consumptionValueColor(context: context),
                    isLoading: viewModel.isBusy,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: screenWidth(context),
                  height: screenWidth(context) / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        viewModel.state.percentageUI,
                        textAlign: TextAlign.center,
                        style: headerOneBoldTextStyle(
                          context: context,
                          fontColor: mainDarkTextColor(context: context),
                        ),
                      ).applyShimmer(
                          params: ShimmerParams(
                        context: context,
                        enable: viewModel.state.consumptionLoading,
                      ),),
                      verticalSpaceSmall,
                      Text(
                        "${viewModel.state.consumptionText}\n${LocaleKeys.data_consumed.tr()}",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: captionTwoNormalTextStyle(
                          context: context,
                          fontColor: contentTextColor(context: context),
                        ).copyWith(fontSize: 10),
                      ).applyShimmer(
                          params: ShimmerParams(
                        context: context,
                        enable: viewModel.state.consumptionLoading,
                      ),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpaceSmall,
        viewModel.state.showTopUP
            ? Row(
                children: <Widget>[
                  const Spacer(),
                  TopUpButton(
                    onClick: viewModel.onTopUpClick,
                    backgroundColor:
                    enabledMainButtonColor(context: context),
                  ),
                  const Spacer(),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget buildConsumptionBodyUnlimited(
    BuildContext context,
    MyESimBundleBottomSheetViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  LocaleKeys.unlimited_data_bundle.tr(),
                  style: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: contentTextColor(context: context),
                  ),
                  maxLines: 2,
                ).applyShimmer(
                    params: ShimmerParams(
                  context: context,
                  enable: viewModel.state.consumptionLoading,
                ),),
                Text(
                  LocaleKeys.unlimited.tr(),
                  style: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: contentTextColor(context: context),
                  ),
                  maxLines: 2,
                ).applyShimmer(
                    params: ShimmerParams(
                  context: context,
                  enable: viewModel.state.consumptionLoading,
                ),),
              ],
            ),
            const Spacer(),
            viewModel.state.showTopUP
                ? TopUpButton(
                    onClick: viewModel.onTopUpClick,
                    backgroundColor:
                    enabledMainButtonColor(context: context),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget buildPlanHistory(
    BuildContext context,
    PurchaseEsimBundleResponseModel? item,
    MyESimBundleBottomSheetViewModel viewModel,
  ) {
    return Column(
      spacing: 12,
      children: <Widget>[
        Text(
          LocaleKeys.plan_history.tr(),
          style: captionTwoBoldTextStyle(
            context: context,
            fontColor: mainDarkTextColor(context: context),
          ),
        ).textSupportsRTL(context),
        Column(
          spacing: 10,
          children: item?.transactionHistory
                  ?.map(
                    (TransactionHistoryResponseModel transaction) =>
                        transActionsHistory(context, transaction, viewModel),
                  )
                  .toList() ??
              <Widget>[],
        ),
      ],
    );
  }

  Widget transActionsHistory(
    BuildContext context,
    TransactionHistoryResponseModel? transaction,
    MyESimBundleBottomSheetViewModel viewModel,
  ) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: mainBorderColor(context: context),
        ),
      ),
      child: SizedBox(
        width: screenWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PaddingWidget.applySymmetricPadding(
              vertical: 16,
              horizontal: 16,
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        transaction?.bundle?.priceDisplay ?? "",
                        style: headerOneMediumTextStyle(
                          context: context,
                          fontColor: mainDarkTextColor(context: context),
                        ),
                      ),
                      (transaction?.bundle?.unlimited ?? false)
                          ? const UnlimitedDataWidget()
                          : Text(
                              transaction?.bundle?.gprsLimitDisplay ?? "",
                              textDirection: TextDirection.ltr,
                              style: headerOneMediumTextStyle(
                                context: context,
                                fontColor: mainDarkTextColor(context: context),
                              ),
                            ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    spacing: 12,
                    children: <Widget>[
                      Text(
                        LocaleKeys.valid.tr(
                          namedArgs: <String, String>{
                            "date":
                                transaction?.bundle?.getValidityDisplay() ?? "",
                          },
                        ),
                        style: captionTwoNormalTextStyle(
                          context: context,
                          fontColor: contentTextColor(context: context),
                        ),
                      ),
                      Text(
                        LocaleKeys.purchased.tr(
                          namedArgs: <String, String>{
                            "date": DateTimeUtils.formatTimestampToDate(
                              timestamp:
                                  int.parse(transaction?.createdAt ?? "0"),
                              format: DateTimeUtils.ddMmYyyy,
                            ),
                          },
                        ),
                        style: captionTwoNormalTextStyle(
                          context: context,
                          fontColor: contentTextColor(context: context),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  MyCardWrap(
                    enableBorder: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    borderRadius: 20,
                    color:
                        enabledMainButtonColor(context: context).withAlpha(30),
                    child: Text(
                      viewModel.getBundleTranslation(transaction?.bundleType),
                      style: captionTwoBoldTextStyle(
                        context: context,
                        fontColor: enabledMainButtonColor(context: context),
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  buildInfoRow(
                    context: context,
                    label: LocaleKeys.order_id.tr(),
                    value: transaction?.userOrderId ?? "",
                    isLoading: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<MyESimBundleRequest>>(
          "request",
          request,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<MainBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
