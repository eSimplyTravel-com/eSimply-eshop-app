import "dart:async";

import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetReferralInfoUseCase
    implements UseCase<Resource<ReferralInfoResponseModel?>, NoParams> {
  GetReferralInfoUseCase(this.repository);

  final ApiPromotionRepository repository;

  @override
  FutureOr<Resource<ReferralInfoResponseModel?>> execute(
    NoParams? params,
  ) async {
    return await repository.getReferralInfo();
  }
}
