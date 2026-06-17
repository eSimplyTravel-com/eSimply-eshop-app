import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_receipt_bottom_sheet_view/order_receipt_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/bundle_title_content_view.dart";
import "package:esim_open_source/presentation/widgets/divider_line.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class OrderReceiptBottomSheetView extends StatelessWidget {
  const OrderReceiptBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });

  final SheetRequest<OrderHistoryResponseModel> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: locator<OrderReceiptBottomSheetViewModel>()
        ..bundleOrderModel = requestBase.data,
      // OrderReceiptBottomSheetViewModel(
      //   bundleOrderModel: requestBase.data,
      // ),
      builder: (
        BuildContext context,
        OrderReceiptBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          DecoratedBox(
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        child: SizedBox(
          width: screenWidth(context),
          child: PaddingWidget.applySymmetricPadding(
            vertical: 15,
            horizontal: 15,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 40,
              ), // Prevent content from being hidden by the button
              child: Column(
                children: <Widget>[
                  BottomSheetCloseButton(
                    onTap: () => completer(
                      SheetResponse<EmptyBottomSheetResponse>(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: RepaintBoundary(
                          key: viewModel.globalKey,
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  EnvironmentImages.darkAppIcon.fullImagePath,
                                  width: 180,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              DividerLine(
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                dividerColor: mainBorderColor(context: context),
                              ),
                              BundleTitleContentView(
                                titleText: LocaleKeys
                                    .orderReceiptBottomSheet_companyName
                                    .tr(),
                                contentText:
                                    viewModel.bundleOrderModel?.companyName ??
                                        "N/A",
                              ),
                              DividerLine(
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                dividerColor: mainBorderColor(context: context),
                              ),
                              BundleTitleContentView(
                                titleText: LocaleKeys
                                    .orderReceiptBottomSheet_address
                                    .tr(),
                                contentText: viewModel
                                        .bundleOrderModel?.companyAddress ??
                                    "N/A",
                              ),
                              DividerLine(
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                dividerColor: mainBorderColor(context: context),
                              ),
                              BundleTitleContentView(
                                titleText: LocaleKeys
                                    .orderReceiptBottomSheet_email
                                    .tr(),
                                contentText:
                                    viewModel.bundleOrderModel?.companyEmail ??
                                        "N/A",
                              ),
                              DividerLine(
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                dividerColor: mainBorderColor(context: context),
                              ),
                              BundleTitleContentView(
                                titleText: LocaleKeys
                                    .orderReceiptBottomSheet_orderID
                                    .tr(),
                                contentText:
                                    viewModel.bundleOrderModel?.orderNumber ??
                                        "N/A",
                              ),
                              DividerLine(
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                dividerColor: mainBorderColor(context: context),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  BundleTitleContentView(
                                    titleText: LocaleKeys
                                        .orderReceiptBottomSheet_totalPaid
                                        .tr(),
                                    contentText: viewModel.bundleOrderModel
                                            ?.orderDisplayPrice ??
                                        "",
                                  ),
                                  BundleTitleContentView(
                                    titleText: LocaleKeys
                                        .orderReceiptBottomSheet_datePaid
                                        .tr(),
                                    contentText:
                                        DateTimeUtils.formatTimestampToDate(
                                      timestamp: int.parse(
                                        viewModel.bundleOrderModel?.orderDate ??
                                            "0",
                                      ),
                                      format: DateTimeUtils.ddMmYyyy,
                                    ),
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                  ),
                                ],
                              ),
                              DividerLine(
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                dividerColor: mainBorderColor(context: context),
                              ),
                              BundleTitleContentView(
                                titleText: LocaleKeys
                                    .orderReceiptBottomSheet_paymentMethod
                                    .tr(),
                                contentText: viewModel.bundleOrderModel
                                        ?.paymentDetails?.cardDisplay ??
                                    "N/A",
                              ),
                              DividerLine(
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                dividerColor: mainBorderColor(context: context),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  LocaleKeys.orderReceiptBottomSheet_summary
                                      .tr(),
                                  style: captionTwoNormalTextStyle(
                                    context: context,
                                    fontColor:
                                        contentTextColor(context: context),
                                  ),
                                ).textSupportsRTL(context),
                              ),
                              verticalSpaceSmallMedium,
                              Table(
                                border: TableBorder.all(
                                  color: mainBorderColor(context: context),
                                ),
                                children: <TableRow>[
                                  TableRow(
                                    children: <Widget>[
                                      tableRowCell(
                                        context: context,
                                        titleText: LocaleKeys
                                            .orderReceiptBottomSheet_qty
                                            .tr(),
                                        contentText: viewModel
                                                .bundleOrderModel?.quantity
                                                .toString() ??
                                            "0",
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      tableRowCell(
                                        context: context,
                                        titleText: LocaleKeys
                                            .orderReceiptBottomSheet_product
                                            .tr(),
                                        contentText: viewModel.bundleOrderModel
                                                ?.bundleDetails?.displayTitle ??
                                            "",
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      tableRowCell(
                                        context: context,
                                        titleText: LocaleKeys
                                            .orderReceiptBottomSheet_unitPrice
                                            .tr(),
                                        contentText: viewModel.bundleOrderModel
                                                ?.orderDisplayPrice ??
                                            "",
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      tableRowCell(
                                        context: context,
                                        titleText: LocaleKeys
                                            .orderReceiptBottomSheet_amount
                                            .tr(),
                                        contentText: viewModel.bundleOrderModel
                                                ?.orderDisplayPrice ??
                                            "",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  MainButton(
                    title: LocaleKeys.orderReceiptBottomSheet_download.tr(),
                    onPressed: viewModel.savePdf,
                    hideShadows: true,
                    themeColor: themeColor,
                    enabledTextColor:
                        enabledMainButtonTextColor(context: context),
                    enabledBackgroundColor:
                        enabledMainButtonColor(context: context),
                    titleTextStyle: bodyBoldTextStyle(context: context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tableRowCell({
    required BuildContext context,
    required String titleText,
    required String contentText,
  }) {
    return PaddingWidget.applySymmetricPadding(
      vertical: 5,
      horizontal: 10,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                titleText,
                style: captionTwoNormalTextStyle(
                  context: context,
                  fontColor: contentTextColor(context: context),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  contentText,
                  textAlign: TextAlign.right,
                  style: captionOneMediumTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
