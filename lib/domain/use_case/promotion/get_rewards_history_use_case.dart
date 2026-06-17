import "dart:async";

import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetRewardsHistoryUseCase
    implements UseCase<Resource<List<RewardHistoryResponseModel>?>, NoParams> {
  GetRewardsHistoryUseCase(this.repository);

  final ApiPromotionRepository repository;

  @override
  FutureOr<Resource<List<RewardHistoryResponseModel>?>> execute(
    NoParams params,
  ) async {
    return await repository.getRewardsHistory();
  }
}
