import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/request/related_search.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/bundle_details_bottom_sheet/bundle_detail_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/cashback_reward_bottom_sheet/cashback_reward_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/compatible_bottom_sheet_view/compatible_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/confirmation_bottom_sheet_view/confirmation_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/delete_account_bottom_sheet/delete_account_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle/my_e_sim_bundle_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_consumption/consumption_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_qr_code/qr_code_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_top_up/top_up_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/edit_name/edit_name_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/logout_bottom_sheet/logout_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_bottom_sheet_view/order_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_receipt_bottom_sheet_view/order_receipt_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/payment_method_bottom_sheet/payment_method_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/payment_selection_bottom_sheet/payment_selection_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/services_bottom_sheet/services_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/share_referral_code/share_referral_code_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/success_bottom_sheet/success_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/tax_bottom_sheet/tax_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/terms_bottom_sheet/terms_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/upgrade_wallet_bottom_sheet/upgrade_wallet_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/voucher_code_bottom_sheet/voucher_code_bottom_sheet_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class ConfirmationSheetRequest {
  ConfirmationSheetRequest({
    required this.titleText,
    required this.contentText,
    required this.selectedText,
  });

  final String titleText;
  final String contentText;
  final String selectedText;
}

void setupBottomSheetUi() {
  final BottomSheetService bottomSheetService = locator<BottomSheetService>();

  final Map<
      BottomSheetType,
      StatelessWidget Function(
        dynamic context,
        dynamic sheetRequest,
        Function(SheetResponse<Object> p1) completer,
      )> builders = <BottomSheetType,
      StatelessWidget Function(
    dynamic context,
    dynamic sheetRequest,
    Function(SheetResponse<Object> p1) completer,
  )>{
    BottomSheetType.floatingBox:
        (dynamic context, dynamic sheetRequest, dynamic completer) =>
            _FloatingBoxBottomSheet(
              request: sheetRequest,
              completer: completer,
            ),
    BottomSheetType.generic: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<GenericBottomSheetResponse>) completer,
    ) =>
        GenericBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.services: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<MainBottomSheetResponse>) completer,
    ) =>
        _ServicesBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.logout: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        LogoutBottomSheet(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.deleteAccount: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        DeleteAccountBottomSheet(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.orderHistory: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<OrderHistoryResponseModel>) completer,
    ) =>
        OrderBottomSheetView(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.receiptOrder: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        OrderReceiptBottomSheetView(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.voucherCode: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        VoucherCodeBottomSheetView(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.termsCondition: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        TermsBottomSheetView(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.bundleDetails: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        BundleDetailBottomSheetView(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.paymentMethod: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        PaymentMethodBottomSheetView(
          completer: completer,
        ),
    BottomSheetType.topUpBundle: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<MainBottomSheetResponse>) completer,
    ) =>
        _BundleTopUpBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.bundleQrCode: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<MainBottomSheetResponse>) completer,
    ) =>
        _BundleQrBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.bundleConsumption: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<MainBottomSheetResponse>) completer,
    ) =>
        _BundleConsumptionBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.bundleEditName: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<MainBottomSheetResponse>) completer,
    ) =>
        _BundleEditNameBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.compatibleSheetView: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        CompatibleBottomSheetView(
          completer: completer,
          requestBase: sheetRequest,
        ),
    BottomSheetType.myESimBundle: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<MainBottomSheetResponse>) completer,
    ) =>
        _MyESimBundleBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.successBottomSheet: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        _SuccessBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.confirmationSheet: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        ConfirmationBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.upgradeWallet: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        UpgradeWalletBottomSheetView(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.shareReferralCode: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        ShareReferralCodeBottomSheet(
          requestBase: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.paymentSelection: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<PaymentType>) completer,
    ) =>
        _PaymentSelectionBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.cashbackReward: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        _CashbackRewardBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.tax: (
      dynamic context,
      dynamic sheetRequest,
      Function(SheetResponse<EmptyBottomSheetResponse>) completer,
    ) =>
        _TaxBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class PurchaseBundleBottomSheetArgs {
  PurchaseBundleBottomSheetArgs(
    this.region,
    this.countries,
    this.bundleResponseModel,
  );

  final RegionRequestModel? region;
  final List<CountriesRequestModel>? countries;
  final BundleResponseModel bundleResponseModel;
}

class EmptyBottomSheetResponse {
  const EmptyBottomSheetResponse();
}

class MainBottomSheetResponse {
  const MainBottomSheetResponse({
    this.tag = "",
    this.canceled = true,
  });

  final String tag;
  final bool canceled;
}

class _FloatingBoxBottomSheet extends StatelessWidget {
  const _FloatingBoxBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<dynamic> request;
  final Function(SheetResponse<dynamic>) completer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            request.title ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            request.description ?? "",
            style: const TextStyle(color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                onPressed: () =>
                    completer(SheetResponse<dynamic>(confirmed: true)),
                child: Text(
                  request.secondaryButtonTitle ?? "",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () =>
                    completer(SheetResponse<dynamic>(confirmed: true)),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  request.mainButtonTitle ?? "",
                  style: const TextStyle(color: Colors.white),
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
      ..add(DiagnosticsProperty<SheetRequest<dynamic>>("request", request))
      ..add(
        ObjectFlagProperty<Function(SheetResponse<dynamic> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}

class GenericBottomSheetRequest {
  const GenericBottomSheetRequest({
    this.message = "GenericBottomSheetRequest",
  });

  final String message;
}

class GenericBottomSheetResponse {
  const GenericBottomSheetResponse({
    this.message = "GenericBottomSheetResponse",
  });

  final String message;
}

class GenericBottomSheet extends StatelessWidget {
  const GenericBottomSheet({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<dynamic> request;
  final Function(SheetResponse<GenericBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            request.title ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            request.description ?? "",
            style: const TextStyle(color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                onPressed: () => completer(
                  SheetResponse<GenericBottomSheetResponse>(
                    confirmed: true,
                    data: const GenericBottomSheetResponse(
                      message: "SecondaryButton",
                    ),
                  ),
                ),
                child: Text(
                  request.secondaryButtonTitle ?? "",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () => completer(
                  SheetResponse<GenericBottomSheetResponse>(
                    confirmed: true,
                    data:
                        const GenericBottomSheetResponse(message: "MainButton"),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  request.mainButtonTitle ?? "",
                  style: const TextStyle(color: Colors.white),
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
      ..add(DiagnosticsProperty<SheetRequest<dynamic>>("request", request))
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<GenericBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}

//#region Service Bottom Sheet
class _ServicesBottomSheet extends StatelessWidget {
  const _ServicesBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<ServicesBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return ServicesBottomSheet(
      requestBase: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<ServicesBottomRequest>>(
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

class ServicesBottomRequest {
  const ServicesBottomRequest({
    this.title,
    this.subtitle,
    this.actions,
  });

  final String? title;
  final String? subtitle;
  final List<ServicesBottomAction>? actions;
}

class ServicesBottomAction {
  const ServicesBottomAction({
    this.title,
    this.svgurl,
    this.tag = "",
  });

  final String? title;
  final String? svgurl;
  final String tag;
}
//#endregion

//#region bundle qr code
class _BundleQrBottomSheet extends StatelessWidget {
  const _BundleQrBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<BundleQrBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return ESimQrBottomSheet(
      request: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<BundleQrBottomRequest>>(
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

class BundleQrBottomRequest {
  const BundleQrBottomRequest({
    required this.iccID,
    this.smDpAddress,
    this.activationCode,
  });

  final String iccID;
  final String? smDpAddress;
  final String? activationCode;
}
//#endregion

//#region bundle consumption
class _BundleConsumptionBottomSheet extends StatelessWidget {
  const _BundleConsumptionBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<BundleConsumptionBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return ConsumptionBottomSheetView(
      request: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<BundleConsumptionBottomRequest>>(
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

class BundleConsumptionBottomRequest {
  const BundleConsumptionBottomRequest({
    required this.iccID,
    required this.showTopUp,
    required this.isUnlimitedData,
  });

  final String iccID;
  final bool showTopUp;
  final bool isUnlimitedData;
}
//#endregion

//#region bundle Top up
class _BundleTopUpBottomSheet extends StatelessWidget {
  const _BundleTopUpBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<BundleTopUpBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return TopUpBottomSheet(
      request: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<BundleTopUpBottomRequest>>(
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

class BundleTopUpBottomRequest {
  const BundleTopUpBottomRequest({
    required this.iccID,
    required this.bundleCode,
  });

  final String iccID;
  final String bundleCode;
}
//#endregion

//#region bundle Edit Name
class _BundleEditNameBottomSheet extends StatelessWidget {
  const _BundleEditNameBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<BundleEditNameRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return EditNameBottomSheetView(
      request: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<BundleEditNameRequest>>(
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

class BundleEditNameRequest {
  BundleEditNameRequest({
    this.name,
  });

  final String? name;
}
//#endregion

//#region My eSIM Bundle
class _MyESimBundleBottomSheet extends StatelessWidget {
  const _MyESimBundleBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<MyESimBundleRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return MyESimBundleBottomSheetView(
      request: request,
      completer: completer,
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

class MyESimBundleRequest {
  MyESimBundleRequest({
    required this.eSimBundleResponseModel,
  });

  final PurchaseEsimBundleResponseModel? eSimBundleResponseModel;
}
//#endregion

//#region Success Bottom Sheet
class _SuccessBottomSheet extends StatelessWidget {
  const _SuccessBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<SuccessBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return SuccessBottomSheet(
      request: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<SuccessBottomRequest>>(
          "request",
          request,
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

class SuccessBottomRequest {
  SuccessBottomRequest({
    required this.title,
    required this.description,
    this.imagePath,
  });

  final String title;
  final String description;
  final String? imagePath;
}
//#endregion

//#region CashbackReward Bottom Sheet
class _CashbackRewardBottomSheet extends StatelessWidget {
  const _CashbackRewardBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<CashbackRewardBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return CashbackRewardBottomSheet(
      request: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<CashbackRewardBottomRequest>>(
          "request",
          request,
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

class CashbackRewardBottomRequest {
  CashbackRewardBottomRequest({
    required this.title,
    required this.percent,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String percent;
  final String description;
  final String imagePath;
}
//#endregion

//#region Payment Selection
class _PaymentSelectionBottomSheet extends StatelessWidget {
  const _PaymentSelectionBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<PaymentSelectionBottomRequest> request;
  final Function(SheetResponse<PaymentType>) completer;

  @override
  Widget build(BuildContext context) {
    return PaymentSelectionBottomSheetView(
      completer: completer,
      requestBase: request,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<PaymentSelectionBottomRequest>>(
          "request",
          request,
        ),
      )
      ..add(
        ObjectFlagProperty<Function(SheetResponse<PaymentType> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}

class PaymentSelectionBottomRequest {
  const PaymentSelectionBottomRequest({required this.paymentTypeList});

  final List<PaymentType> paymentTypeList;
}

class PaymentSelectionResponse {
  const PaymentSelectionResponse({
    required this.paymentType,
    required this.canceled,
  });

  final PaymentType paymentType;
  final bool canceled;
}
//#endregion

//#region Tax Bottom Sheet
class _TaxBottomSheet extends StatelessWidget {
  const _TaxBottomSheet({
    required this.request,
    required this.completer,
  });

  final SheetRequest<TaxBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return TaxBottomSheet(
      request: request,
      completer: completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<TaxBottomRequest>>(
          "request",
          request,
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

class TaxBottomRequest {
  TaxBottomRequest({
    required this.subTotal,
    required this.estimatedTax,
    required this.total,
  });

  final String subTotal;
  final String estimatedTax;
  final String total;
}
//#endregion
