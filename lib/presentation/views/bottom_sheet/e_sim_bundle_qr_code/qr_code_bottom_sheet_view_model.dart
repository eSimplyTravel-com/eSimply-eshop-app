import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/use_case/user/get_user_purchased_esim_by_iccid_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/file_helper.dart";
import "package:esim_open_source/utils/image_helper.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class QrCodeBottomSheetViewModel extends BaseModel {
  QrCodeBottomSheetViewModel({
    required this.request,
    required this.completer,
  });

  //#region Variables
  final SheetRequest<BundleQrBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;
  GlobalKey globalKey = GlobalKey();

  String? smDpAddress = "";
  String? activationCode = "";

  String get qrCodeValue => "LPA:1\$$smDpAddress\$$activationCode";

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    unawaited(_getBundleDetailsInfo());
  }

  Future<void> copyToClipboard(String text) async {
    if (isBusy) {
      return;
    }
    copyText(text);
  }

  void onOpenSettingsClicked() {
    unawaited(
      locator<FlutterChannelHandlerService>().openSimProfilesSettings(),
    );
  }

  Future<void> onUserGuideClick() async {
    navigationService.navigateTo(
      UserGuideView.routeName,
      preventDuplicates: false,
    );
  }

  Future<void> onShareClick() async {
    String path =
        await captureImage(globalKey: globalKey, fileName: smDpAddress);
    shareImage(imagePath: path);
  }

  Future<void> onDownloadClick() async {
    String path =
        await captureImage(globalKey: globalKey, fileName: smDpAddress);
    saveImageToGallery(
      imagePath: path,
      toastMessage: LocaleKeys.qr_code_saved.tr(),
    );
  }

  //#endregion

  //#region Apis

  Future<void> _getBundleDetailsInfo() async {
    if (request.data?.smDpAddress != null &&
        request.data?.activationCode != null) {
      smDpAddress = request.data?.smDpAddress ?? "";
      activationCode = request.data?.activationCode ?? "";
      notifyListeners();
      return;
    }

    setViewState(ViewState.busy);
    Resource<PurchaseEsimBundleResponseModel?> response =
        await GetUserPurchasedEsimByIccidUseCase(locator()).execute(
      GetUserPurchasedEsimByIccidParam(iccID: request.data?.iccID ?? ""),
    );
    handleResponse(
      response,
      onSuccess: (Resource<PurchaseEsimBundleResponseModel?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        smDpAddress = result.data?.smdpAddress ?? "";
        activationCode = result.data?.activationCode ?? "";
      },
      onFailure: (Resource<PurchaseEsimBundleResponseModel?> result) async {
        await handleError(response);
        completer(SheetResponse<MainBottomSheetResponse>());
      },
    );
    setViewState(ViewState.idle);
  }

//#endregion
}
