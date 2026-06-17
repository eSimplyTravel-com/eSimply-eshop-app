import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/data_source/esims_local_data_source.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_exists_response_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/responses/user/order_history_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/user/user_bundle_consumption_response_dto.dart";
import "package:esim_open_source/data/remote/responses/user/user_notification_response_dto.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/data/request/related_search.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_exists_response.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiUserRepositoryImpl implements ApiUserRepository {
  ApiUserRepositoryImpl({
    required this.apiUserBundles,
    required this.repository,
  });

  final ApiUser apiUserBundles;
  final EsimsLocalDataSource repository;

  @override
  FutureOr<Resource<UserBundleConsumptionResponse?>> getUserConsumption({
    required String iccID,
  }) {
    return responseToResource<UserBundleConsumptionResponseDto,
        UserBundleConsumptionResponse?>(
      apiUserBundles.getUserConsumption(iccID: iccID),
      (UserBundleConsumptionResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> assignBundle({
    required String bundleCode,
    required String promoCode,
    required String referralCode,
    required String affiliateCode,
    required String paymentType,
    required RelatedSearchRequestModel relatedSearch,
    String? bearerToken,
  }) {
    return responseToResource<BundleAssignResponseModelDto,
        BundleAssignResponseModel?>(
      apiUserBundles.assignBundle(
        bundleCode: bundleCode,
        promoCode: promoCode,
        referralCode: referralCode,
        affiliateCode: affiliateCode,
        paymentType: paymentType,
        bearerToken: bearerToken,
        relatedSearch: relatedSearch,
      ),
      (BundleAssignResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> topUpBundle({
    required String iccID,
    required String bundleCode,
    required String paymentType,
  }) {
    return responseToResource<BundleAssignResponseModelDto,
        BundleAssignResponseModel?>(
      apiUserBundles.topUpBundle(
        iccID: iccID,
        bundleCode: bundleCode,
        paymentType: paymentType,
      ),
      (BundleAssignResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<List<UserNotificationModel>>> getUserNotifications({
    required int pageIndex,
    required int pageSize,
  }) {
    return responseToResource<List<UserNotificationModelDto>,
        List<UserNotificationModel>>(
      apiUserBundles.getUserNotifications(
        pageIndex: pageIndex,
        pageSize: pageSize,
      ),
      (List<UserNotificationModelDto> dtos) =>
          dtos.map((UserNotificationModelDto dto) => dto.toDomain()).toList(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> setNotificationsRead() {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiUserBundles.setNotificationsRead(),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<BundleExistsResponse?>> getBundleExists({
    required String code,
  }) {
    return responseToResource<BundleExistsResponseDto, BundleExistsResponse?>(
      apiUserBundles.getBundleExists(code: code),
      (BundleExistsResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> getBundleLabel({
    required String iccid,
    required String label,
  }) {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiUserBundles.getBundleLabel(iccid: iccid, label: label),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<PurchaseEsimBundleResponseModel?>> getMyEsimByIccID({
    required String iccID,
  }) {
    return responseToResource<PurchaseEsimBundleResponseModelDto,
        PurchaseEsimBundleResponseModel?>(
      apiUserBundles.getMyEsimByIccID(
        iccID: iccID,
      ),
      (PurchaseEsimBundleResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<PurchaseEsimBundleResponseModel?>> getMyEsimByOrder({
    required String orderID,
    String? bearerToken,
  }) {
    return responseToResource<PurchaseEsimBundleResponseModelDto,
        PurchaseEsimBundleResponseModel?>(
      apiUserBundles.getMyEsimByOrder(
        orderID: orderID,
        bearerToken: bearerToken,
      ),
      (PurchaseEsimBundleResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<List<PurchaseEsimBundleResponseModel>?>>
      getMyEsims() async {
    // no internet connection
    if (!await locator<ConnectivityService>().isConnected()) {
      List<PurchaseEsimBundleResponseModelDto>? dbEsim =
          repository.getPurchasedEsims();
      if (dbEsim != null) {
        return Resource<List<PurchaseEsimBundleResponseModel>?>.success(
          dbEsim
              .map((PurchaseEsimBundleResponseModelDto dto) => dto.toDomain())
              .toList(),
          message: "",
        );
      } else {
        return Resource<List<PurchaseEsimBundleResponseModel>?>.error(
          "No internet connection",
        );
      }
    }

    try {
      Resource<List<PurchaseEsimBundleResponseModel>?> response =
          await responseToResource<List<PurchaseEsimBundleResponseModelDto>?,
              List<PurchaseEsimBundleResponseModel>?>(
        apiUserBundles.getMyEsims(),
        (List<PurchaseEsimBundleResponseModelDto>? dtos) => dtos
            ?.map((PurchaseEsimBundleResponseModelDto dto) => dto.toDomain())
            .toList(),
      );

      if (response.resourceType == ResourceType.success) {
        repository.replacePurchasedEsims(
          response.data
              ?.map(
                (PurchaseEsimBundleResponseModel model) =>
                    PurchaseEsimBundleResponseModelDto().fromDomain(model),
              )
              .toList(),
        );
      }

      return response;
    } on Object catch (ex) {
      log(ex.toString());
      List<PurchaseEsimBundleResponseModelDto>? dbEsim =
          repository.getPurchasedEsims();
      if (dbEsim != null) {
        return Resource<List<PurchaseEsimBundleResponseModel>?>.success(
          dbEsim
              .map((PurchaseEsimBundleResponseModelDto dto) => dto.toDomain())
              .toList(),
          message: "",
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>?>> getRelatedTopUp({
    required String iccID,
    required String bundleCode,
  }) {
    return responseToResource<List<BundleResponseModelDto>,
        List<BundleResponseModel>?>(
      apiUserBundles.getRelatedTopUp(
        iccID: iccID,
        bundleCode: bundleCode,
      ),
      (List<BundleResponseModelDto>? dtos) =>
          dtos?.map((BundleResponseModelDto dto) => dto.toDomain()).toList(),
    );
  }

  @override
  FutureOr<Resource<List<OrderHistoryResponseModel>?>> getOrderHistory({
    required int pageIndex,
    required int pageSize,
  }) {
    return responseToResource<List<OrderHistoryResponseModelDto>,
        List<OrderHistoryResponseModel>?>(
      apiUserBundles.getOrderHistory(
        pageIndex: pageIndex,
        pageSize: pageSize,
      ),
      (List<OrderHistoryResponseModelDto> dtos) => dtos
          .map((OrderHistoryResponseModelDto dto) => dto.toDomain())
          .toList(),
    );
  }

  @override
  FutureOr<Resource<OrderHistoryResponseModel?>> getOrderByID({
    required String orderID,
  }) {
    return responseToResource<OrderHistoryResponseModelDto,
        OrderHistoryResponseModel?>(
      apiUserBundles.getOrderByID(
        orderID: orderID,
      ),
      (OrderHistoryResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> topUpWallet({
    required double amount,
    required String currency,
  }) async {
    return responseToResource<BundleAssignResponseModelDto,
        BundleAssignResponseModel?>(
      apiUserBundles.topUpWallet(
        amount: amount,
        currency: currency,
      ),
      (BundleAssignResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> cancelOrder({
    required String orderID,
  }) async {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiUserBundles.cancelOrder(
        orderID: orderID,
      ),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> resendOrderOtp({
    required String orderID,
  }) async {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiUserBundles.resendOrderOtp(
        orderID: orderID,
      ),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> verifyOrderOtp({
    required String otp,
    required String iccid,
    required String orderID,
  }) async {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiUserBundles.verifyOrderOtp(
        otp: otp,
        iccid: iccid,
        orderID: orderID,
      ),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }
}
