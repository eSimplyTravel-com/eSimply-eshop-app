import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/redeem_voucher_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/widgets/qr_scanner/qr_scanner_view.dart";
import "package:flutter/cupertino.dart";
import "package:stacked_services/stacked_services.dart";

class VoucherCodeBottomSheetViewModel extends BaseModel {
  VoucherCodeBottomSheetViewModel({required this.completer});
  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;
  TextEditingController get voucherCodeController => _voucherCodeController;
  final TextEditingController _voucherCodeController = TextEditingController();
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  GetUserInfoUseCase getUserInfoUseCase =
      GetUserInfoUseCase(locator<ApiAuthRepository>());

  final RedeemVoucherUseCase redeemVoucherUseCase =
      RedeemVoucherUseCase(locator<ApiPromotionRepository>());

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    _voucherCodeController.addListener(validateForm);
  }

  void validateForm() {
    _isButtonEnabled = _voucherCodeController.text.trim().isNotEmpty;
    notifyListeners();
  }

  Future<void> scanVoucherCode() async {
    try {
      String barcodeScanRes = await navigationService.navigateTo(
        QrScannerView.routeName,
        preventDuplicates: false,
      );

      log("Voucher code: $barcodeScanRes");
      _voucherCodeController.text = barcodeScanRes;
      notifyListeners();
    } on Object catch (_) {
      log("Error on scanning or parsing");
    }
  }

  Future<void> redeemVoucher() async {
    setViewState(ViewState.busy);

    Resource<EmptyResponse?> response = await redeemVoucherUseCase.execute(
      RedeemVoucherUseCaseParams(
        voucherCode: _voucherCodeController.text.trim(),
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<EmptyResponse?> result) async {
        await getUserInfoUseCase.execute(NoParams());
        completer(
          SheetResponse<EmptyBottomSheetResponse>(),
        );
      },
    );
    setViewState(ViewState.idle);
  }
}
