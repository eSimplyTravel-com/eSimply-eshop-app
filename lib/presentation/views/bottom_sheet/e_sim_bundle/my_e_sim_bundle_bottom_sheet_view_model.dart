import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_consumption_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:stacked_services/stacked_services.dart";

class MyESimBundleBottomSheetViewModel extends BaseModel {
  // MyESimBundleBottomSheetViewModel({
  //   required this.request,
  //   required this.completer,
  // });

  //#region UseCases
  final GetUserConsumptionUseCase getUserConsumptionUseCase =
      GetUserConsumptionUseCase(locator<ApiUserRepository>());

  //#endregion

  //#region Variables
  final MyESimBundleBottomState _state = MyESimBundleBottomState();

  MyESimBundleBottomState get state => _state;

  late SheetRequest<MyESimBundleRequest> request;
  late Function(SheetResponse<MainBottomSheetResponse>) completer;

//#endregion

//#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();

    PurchaseEsimBundleResponseModel? item =
        request.data?.eSimBundleResponseModel;

    bool isUnlimited = item?.unlimited ?? false;

    _state
      ..item = item
      ..showTopUP =
          (request.data?.eSimBundleResponseModel?.isTopupAllowed ?? true)
      ..consumptionLoading = !isUnlimited;

    if (isUnlimited) {
      notifyListeners();
    } else {
      unawaited(_fetchConsumptionData());
    }
  }

//#endregion

//#region Apis
  Future<void> _fetchConsumptionData() async {
    _state.consumptionLoading = true;
    Resource<UserBundleConsumptionResponse?> response =
        await getUserConsumptionUseCase
            .execute(UserConsumptionParam(iccID: _state.item?.iccid ?? ""));
    handleResponse<UserBundleConsumptionResponse?>(
      response,
      onSuccess: (Resource<UserBundleConsumptionResponse?> result) async {
        setViewState(ViewState.idle);
        double dataUsed = (result.data?.dataUsed ?? 0).toDouble();
        double dataAllocated = (result.data?.dataAllocated ?? 0).toDouble();
        String dataAllocatedDisplay = result.data?.dataAllocatedDisplay ?? "";
        String dataUsedDisplay = result.data?.dataUsedDisplay ?? "";
        double percentage = (dataUsed / dataAllocated) * 100;
        percentage = double.parse(percentage.toStringAsFixed(2));
        String expiryDate = DateTimeUtils.formatStringToDate(
          dateString: result.data?.expiryDate ?? "",
          format: DateTimeUtils.ddMmYyyy,
        );
        _state
          ..percentageUI = "$percentage %"
          ..consumption = percentage / 100
          ..consumptionText = "$dataUsedDisplay of $dataAllocatedDisplay"
          ..consumptionLoading = false
          ..expiryDate = expiryDate;
      },
      onFailure: (Resource<UserBundleConsumptionResponse?> result) async {
        _state
          ..errorMessage = result.message ?? "Something Went Wrong"
          ..consumptionLoading = false;
      },
    );
  }

//#endregion

  bool isCruise() {
    return state.item?.bundleCategory?.isCruise ?? false;
  }

  void onTopUpClick() {
    completer(
      SheetResponse<MainBottomSheetResponse>(
        data: const MainBottomSheetResponse(
          canceled: false,
          tag: "top_up",
        ),
      ),
    );
  }

  String getBundleTranslation(String? bundleType) {
    switch (bundleType?.toLowerCase().replaceAll(" ", "")) {
      case "primarybundle":
        return LocaleKeys.primaryBundle.tr();
      default:
        return bundleType ?? "N/A";
    }
  }
}

class MyESimBundleBottomState {
  PurchaseEsimBundleResponseModel? item;
  String? errorMessage;
  String percentageUI = "0.0 %";
  String consumptionText = "";
  double consumption = 0;
  bool consumptionLoading = true;
  bool showTopUP = true;
  String? expiryDate;
}
