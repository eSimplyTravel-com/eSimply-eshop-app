import "dart:async";

import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/responses/promotion/referral_info_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model_dto.dart";
import "package:esim_open_source/domain/data/api_promotion.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiPromotionRepositoryImpl implements ApiPromotionRepository {
  ApiPromotionRepositoryImpl({
    required APIPromotion apiPromotion,
  }) : _apiPromotion = apiPromotion;

  final APIPromotion _apiPromotion;

  @override
  FutureOr<Resource<EmptyResponse?>> redeemVoucher({
    required String voucherCode,
  }) async {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      _apiPromotion.redeemVoucher(voucherCode: voucherCode),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> applyReferralCode({
    required String referralCode,
  }) async {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      _apiPromotion.applyReferralCode(referralCode: referralCode),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<BundleResponseModel?>> validatePromoCode({
    required String promoCode,
    required String bundleCode,
  }) async {
    return responseToResource<BundleResponseModelDto, BundleResponseModel?>(
      _apiPromotion.validatePromoCode(
        promoCode: promoCode,
        bundleCode: bundleCode,
      ),
        (BundleResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<List<RewardHistoryResponseModel>?>>
      getRewardsHistory() async {
    return responseToResource<List<RewardHistoryResponseModelDto>, List<RewardHistoryResponseModel>?>(
      _apiPromotion.getRewardsHistory(),
          (List<RewardHistoryResponseModelDto>? dtos) => dtos
          ?.map((RewardHistoryResponseModelDto dto) => dto.toDomain())
          .toList(),
    );
  }

  @override
  FutureOr<Resource<ReferralInfoResponseModel?>> getReferralInfo() {
    return responseToResource<ReferralInfoResponseModelDto, ReferralInfoResponseModel?>(
      _apiPromotion.getReferralInfo(),
        (ReferralInfoResponseModelDto dto) => dto.toDomain(),
    );
  }
}
