import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/use_case/user/get_user_purchased_esim_by_order_id_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_order_success/purchase_order_success_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";

class PurchaseLoadingViewModel extends BaseModel {
  String? orderID;
  String? bearerToken;

  bool isApiFetched = false;

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(startTimer());
  }

  Future<void> startTimer() async {
    await Future<void>.delayed(const Duration(seconds: 10));
    // navigationService.back();
    unawaited(getOrderDetails());
  }

  Future<void> getOrderDetails() async {
    if (isApiFetched) {
      return;
    }
    Resource<PurchaseEsimBundleResponseModel?> response =
        await GetUserPurchasedEsimByOrderIdUseCase(locator()).execute(
      GetUserPurchasedEsimByOrderIdParam(
        orderID: orderID ?? "",
        bearerToken: bearerToken,
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<PurchaseEsimBundleResponseModel?> result) async {
        if (result.data == null) {
          navigationService.back();
          locator.resetLazySingleton(
            instance: locator<PurchaseLoadingViewModel>(),
          );
          return;
        }

        locator<MyESimViewModel>().refreshScreen();

        navigationService.replaceWith(
          PurchaseOrderSuccessView.routeName,
          arguments: result.data,
        );
        locator.resetLazySingleton(
          instance: locator<PurchaseLoadingViewModel>(),
        );
      },
      onFailure: (Resource<PurchaseEsimBundleResponseModel?> result) async {
        await handleError(result);
        locator.resetLazySingleton(
          instance: locator<PurchaseLoadingViewModel>(),
        );
        navigationService.back();
      },
    );

    isApiFetched = true;
  }
}
