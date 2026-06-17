import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/promotion_apis/promotion_apis.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/responses/promotion/referral_info_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model_dto.dart";
import "package:esim_open_source/domain/data/api_promotion.dart";

class APIPromotionImpl extends APIService implements APIPromotion {
  APIPromotionImpl._privateConstructor() : super.privateConstructor();

  static APIPromotionImpl? _instance;

  static APIPromotionImpl get instance {
    if (_instance == null) {
      _instance = APIPromotionImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> applyReferralCode({
    required String referralCode,
  }) async {
    ResponseMainDto<EmptyResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.applyReferralCode,
        parameters: <String, dynamic>{
          "referral_code": referralCode,
        },
      ),
      fromJson: EmptyResponseDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<EmptyResponseDto?>> redeemVoucher({
    required String voucherCode,
  }) async {
    ResponseMainDto<EmptyResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.redeemVoucher,
        parameters: <String, dynamic>{
          "code": voucherCode,
        },
      ),
      fromJson: EmptyResponseDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<BundleResponseModelDto?>> validatePromoCode({
    required String promoCode,
    required String bundleCode,
  }) async {
    Map<String, String> parameters = <String, String>{
      "promo_code": promoCode,
      "bundle_code": bundleCode,
    };

    ResponseMainDto<BundleResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.validatePromoCode,
        parameters: parameters,
      ),
      fromJson: BundleResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<RewardHistoryResponseModelDto>>>
      getRewardsHistory() async {
    ResponseMainDto<List<RewardHistoryResponseModelDto>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.getRewardsHistory,
      ),
      fromJson: RewardHistoryResponseModelDto.fromJsonList,
    );
    return response;
  }

  @override
  Future<ResponseMainDto<ReferralInfoResponseModelDto?>> getReferralInfo() async {
    ResponseMainDto<ReferralInfoResponseModelDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.getReferralInfo,
      ),
      fromJson: ReferralInfoResponseModelDto.fromJson,
    );
    return response;
  }
}
