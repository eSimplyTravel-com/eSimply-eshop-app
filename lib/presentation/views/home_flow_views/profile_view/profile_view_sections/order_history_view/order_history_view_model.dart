import "dart:async";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_order_history_pagination_use_case.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class OrderHistoryViewModel extends BaseModel {
  //#region UseCases
  GetOrderHistoryPaginationUseCase getOrderHistoryUseCase = GetOrderHistoryPaginationUseCase(locator());

  //#endregion

  //#region Variables
  // List<OrderHistoryResponseModel>? bundles;

  @override
  double? get shimmerHeight => 150;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(getOrderHistory());
  }

  Future<void> orderTapped(OrderHistoryResponseModel order) async {
    SheetResponse<OrderHistoryResponseModel>? response =
        await bottomSheetService.showCustomSheet(
      data: order,
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.orderHistory,
    );

    if (response?.confirmed ?? false) {
      bottomSheetService.showCustomSheet(
        data: response?.data,
        enableDrag: false,
        isScrollControlled: true,
        variant: BottomSheetType.receiptOrder,
      );
    }
  }

  //#endregion

  //#region Apis

  Future<void> getOrderHistory() async {
    await getOrderHistoryUseCase.loadNextPage(NoParams());
  }

  Future<void> refreshOrderHistory() async {
    await getOrderHistoryUseCase.refreshData(NoParams());
  }
//#endregion
}
