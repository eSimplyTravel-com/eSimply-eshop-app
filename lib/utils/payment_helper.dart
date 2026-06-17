import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:stacked_services/stacked_services.dart";

class PaymentHelper {
  static Future<void> checkTaxAmount({
    required Resource<BundleAssignResponseModel?> result,
    required Function() onError,
    required Function() onSuccess,
  }) async {
    if (result.data == null) {
      onError();
      return;
    }

    if (result.data?.isTaxExist() ?? false) {
      String subTotalDisplay = result.data?.subtotalPriceDisplay ?? "";
      String estimatedTaxDisplay = result.data?.taxPriceDisplay ?? "";
      String totalPriceDisplay = result.data?.totalPriceDisplay ?? "";
      SheetResponse<EmptyBottomSheetResponse>? taxBottomSheetResponse =
          await locator<BottomSheetService>().showCustomSheet(
        data: TaxBottomRequest(
          subTotal: subTotalDisplay,
          estimatedTax: estimatedTaxDisplay,
          total: totalPriceDisplay,
        ),
        enableDrag: false,
        isScrollControlled: true,
        variant: BottomSheetType.tax,
      );

      if (taxBottomSheetResponse?.confirmed ?? false) {
        onSuccess();
      } else {
        onError();
      }
    } else {
      onSuccess();
    }
  }

  static Future<PaymentType?> choosePaymentMethod(
    List<PaymentType> paymentTypeList,
  ) async {
    SheetResponse<PaymentType>? response =
        await locator<BottomSheetService>().showCustomSheet(
      data: PaymentSelectionBottomRequest(paymentTypeList: paymentTypeList),
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.paymentSelection,
    );
    if (response?.confirmed ?? false) {
      return response?.data ?? PaymentType.card;
    }
    return null;
  }
}
