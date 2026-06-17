import "dart:async";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_consumption_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/esim_base_model.dart";
import "package:stacked_services/stacked_services.dart";

class ConsumptionBottomSheetViewModel extends EsimBaseModel {
  // ConsumptionBottomSheetViewModel({
  //   required this.request,
  //   required this.completer,
  // });

  //#region UseCases
  final GetUserConsumptionUseCase getUserConsumptionUseCase =
      GetUserConsumptionUseCase(locator<ApiUserRepository>());

  //#endregion

  //#region Variables
  final ConsumptionState _state = ConsumptionState();

  ConsumptionState get state => _state;
  late SheetRequest<BundleConsumptionBottomRequest> request;
  late Function(SheetResponse<MainBottomSheetResponse>) completer;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    _state.showTopUP = request.data?.showTopUp ?? false;
    if (!(request.data?.isUnlimitedData ?? false)) {
      unawaited(_fetchConsumptionData());
    } else {
      setViewState(ViewState.idle);
    }
  }

  void onTopUpClick() {
    completer(
      SheetResponse<MainBottomSheetResponse>(
        data: const MainBottomSheetResponse(
          canceled: false,
          tag: "top-up",
        ),
      ),
    );
  }

  //#endregion

  //#region Apis
  Future<void> _fetchConsumptionData() async {
    setViewState(ViewState.busy);

    // await Future<void>.delayed(const Duration(seconds: 1));
    // _state.percentageUI = "64%";
    // _state.errorMessage = "64%";
    // _state.consumptionText = "622.5MB of 750MB";
    // setViewState(ViewState.idle);
    // return;

    Resource<UserBundleConsumptionResponse?> response =
        await getUserConsumptionUseCase
            .execute(UserConsumptionParam(iccID: request.data?.iccID ?? ""));
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
        _state
          ..percentageUI = "$percentage %"
          ..consumption = percentage / 100
          ..consumptionText = "$dataUsedDisplay of $dataAllocatedDisplay";
      },
      onFailure: (Resource<UserBundleConsumptionResponse?> result) async {
        await handleError(response);
        completer(SheetResponse<MainBottomSheetResponse>());
      },
    );
  }

//#endregion

  void closeBottomSheet() {
    completer(SheetResponse<MainBottomSheetResponse>());
  }
}

class ConsumptionState {
  String? errorMessage;
  String percentageUI = "0.0 %";
  String consumptionText = "";
  double consumption = 0;
  bool showTopUP = true;
}
