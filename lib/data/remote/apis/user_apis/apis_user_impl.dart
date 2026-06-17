import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/user_apis/user_apis.dart";
import "package:esim_open_source/data/remote/request/related_search_dto.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
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

class APIUserImpl extends APIService implements ApiUser {
  APIUserImpl._privateConstructor() : super.privateConstructor();

  static APIUserImpl? _instance;

  static APIUserImpl get instance {
    if (_instance == null) {
      _instance = APIUserImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMainDto<UserBundleConsumptionResponseDto?>> getUserConsumption({
    required String iccID,
  }) async {
    ResponseMainDto<UserBundleConsumptionResponseDto> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getUserConsumption,
        paramIDs: <String>[iccID],
      ),
      fromJson: UserBundleConsumptionResponseDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<BundleAssignResponseModelDto?>> assignBundle({
    required String bundleCode,
    required String promoCode,
    required String referralCode,
    required String affiliateCode,
    required String paymentType,
    required RelatedSearchRequestModel relatedSearch,
    String? bearerToken,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "bundle_code": bundleCode,
      "promo_code": promoCode,
      "referral_code": referralCode,
      "affiliate_code": affiliateCode,
      "payment_type": paymentType,
      "related_search":
          RelatedSearchRequestModelDto.fromDomain(relatedSearch).toJson(),
    };

    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $bearerToken",
    };

    ResponseMainDto<BundleAssignResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.assignBundle,
        parameters: params,
        additionalHeaders:
            (bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: BundleAssignResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<BundleAssignResponseModelDto?>> topUpBundle({
    required String iccID,
    required String bundleCode,
    required String paymentType,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "iccid": iccID,
      "bundle_code": bundleCode,
      "payment_type": paymentType,
    };

    ResponseMainDto<BundleAssignResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.topUpBundle,
        parameters: params,
      ),
      fromJson: BundleAssignResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<UserNotificationModelDto>>> getUserNotifications({
    required int pageIndex,
    required int pageSize,
  }) async {
    ResponseMainDto<List<UserNotificationModelDto>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getUserNotifications,
        queryParameters: <String, dynamic>{
          "page_index": pageIndex,
          "page_size": pageSize,
        },
      ),
      fromJson: UserNotificationModelDto.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> setNotificationsRead() async {
    ResponseMainDto<EmptyResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.setNotificationsRead,
      ),
      fromJson: EmptyResponseDto.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<BundleExistsResponseDto?>> getBundleExists({
    required String code,
  }) async {
    ResponseMainDto<BundleExistsResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getBundleExists,
        paramIDs: <String>[code],
      ),
      fromJson: BundleExistsResponseDto.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> getBundleLabel({
    required String iccid,
    required String label,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{"label": label};
    ResponseMainDto<EmptyResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getBundleLabel,
        paramIDs: <String>[iccid],
        parameters: params,
      ),
      fromJson: EmptyResponseDto.fromJson,
    );

    return response;
  }

  @override
  Future<ResponseMainDto<PurchaseEsimBundleResponseModelDto?>> getMyEsimByIccID({
    required String iccID,
  }) async {
    ResponseMainDto<PurchaseEsimBundleResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getMyEsimByIccID,
        paramIDs: <String>[iccID],
      ),
      fromJson: PurchaseEsimBundleResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  Future<ResponseMainDto<PurchaseEsimBundleResponseModelDto?>> getMyEsimByOrder({
    required String orderID,
    String? bearerToken,
  }) async {
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $bearerToken",
    };

    ResponseMainDto<PurchaseEsimBundleResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getMyEsimByOrder,
        paramIDs: <String>[orderID],
        additionalHeaders:
            (bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: PurchaseEsimBundleResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  Future<ResponseMainDto<List<PurchaseEsimBundleResponseModelDto>?>>
      getMyEsims() async {
    ResponseMainDto<List<PurchaseEsimBundleResponseModelDto>?> response =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getMyEsims,
      ),
      fromJson: PurchaseEsimBundleResponseModelDto.fromJsonList,
    );
    return response;
  }

  @override
  Future<ResponseMainDto<List<BundleResponseModelDto>?>> getRelatedTopUp({
    required String iccID,
    required String bundleCode,
  }) async {
    ResponseMainDto<List<BundleResponseModelDto>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getRelatedTopUp,
        paramIDs: <String>[bundleCode, iccID],
      ),
      fromJson: BundleResponseModelDto.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<OrderHistoryResponseModelDto>?>> getOrderHistory({
    required int pageIndex,
    required int pageSize,
  }) async {
    ResponseMainDto<List<OrderHistoryResponseModelDto>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getOrderHistory,
        queryParameters: <String, dynamic>{
          "page_index": pageIndex,
          "page_size": pageSize,
        },
      ),
      fromJson: OrderHistoryResponseModelDto.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<OrderHistoryResponseModelDto?>> getOrderByID({
    required String orderID,
  }) async {
    ResponseMainDto<OrderHistoryResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getOrderByID,
        paramIDs: <String>[orderID],
      ),
      fromJson: OrderHistoryResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  Future<ResponseMainDto<BundleAssignResponseModelDto?>> topUpWallet({
    required double amount,
    required String currency,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "amount": amount,
      //"currency": currency,
    };

    ResponseMainDto<BundleAssignResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.topUpWallet,
        parameters: params,
      ),
      fromJson: BundleAssignResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> cancelOrder({
    required String orderID,
  }) async {
    ResponseMainDto<EmptyResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.cancelOrder,
        paramIDs: <String>[orderID],
      ),
      fromJson: EmptyResponseDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> resendOrderOtp({
    required String orderID,
  }) async {
    ResponseMainDto<EmptyResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.resendOrderOtp,
        paramIDs: <String>[orderID],
      ),
      fromJson: EmptyResponseDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> verifyOrderOtp({
    required String otp,
    required String iccid,
    required String orderID,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "otp": otp,
      "iccid": iccid,
      "order_id": orderID,
    };

    ResponseMainDto<EmptyResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.verifyOrderOtp,
        parameters: params,
      ),
      fromJson: EmptyResponseDto.fromJson,
    );
    return response;
  }
}
