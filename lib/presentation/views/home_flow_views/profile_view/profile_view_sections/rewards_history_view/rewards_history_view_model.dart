import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/get_rewards_history_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/referal_stories_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:stacked_services/stacked_services.dart";

// enum RewardHistoryType {
//   none,
//   cashback,
//   referEarn;
//
//   String get titleText {
//     switch (this) {
//       case RewardHistoryType.none:
//         return LocaleKeys.rewardHistory_referTypeTitle.tr();
//       case RewardHistoryType.cashback:
//         return LocaleKeys.rewardHistory_cashbackTypeTitle.tr();
//       case RewardHistoryType.referEarn:
//         return LocaleKeys.rewardHistory_referTypeTitle.tr();
//     }
//   }
// }

class RewardHistoryModel {
  RewardHistoryModel({
    required this.rewardID,
    required this.rewardTitle,
    required this.rewardContent,
    required this.rewardPrice,
    required this.rewardPercentage,
    required this.rewardValidity,
    required this.rewardCountryCode,
    required this.rewardEmail,
    // required this.rewardType,
  });

  int rewardID;
  String rewardTitle;
  String rewardContent;
  String rewardPrice;
  String rewardPercentage;
  String rewardValidity;
  String rewardCountryCode;
  String rewardEmail;
  // RewardHistoryType rewardType;
}

class RewardsHistoryViewModel extends BaseModel {
  // RewardHistoryType selectedType = RewardHistoryType.none;

  List<RewardHistoryResponseModel> _rewardsHistory =
      <RewardHistoryResponseModel>[];
  List<RewardHistoryResponseModel> filteredRewardHistory =
      <RewardHistoryResponseModel>[];

  final GetRewardsHistoryUseCase getRewardsHistoryUseCase =
      GetRewardsHistoryUseCase(locator<ApiPromotionRepository>());

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();

    getRewardsHistory();
  }

  Future<void> getRewardsHistory() async {
    filteredRewardHistory = List<RewardHistoryResponseModel>.generate(
      3,
      (int index) => RewardHistoryResponseModel.mockData[0],
    );
    notifyListeners();

    applyShimmer = true;

    Resource<List<RewardHistoryResponseModel>?> response =
        await getRewardsHistoryUseCase.execute(NoParams());

    handleResponse(
      response,
      onSuccess: (Resource<List<RewardHistoryResponseModel>?> result) async {
        _rewardsHistory = result.data ?? <RewardHistoryResponseModel>[];
        notifyListeners();
      },
      onFailure: (Resource<List<RewardHistoryResponseModel>?> result) async {
        handleError(response);
        _rewardsHistory = <RewardHistoryResponseModel>[];
        notifyListeners();
      },
    );
    // changeSelectedType(selectedType);
    filteredRewardHistory = _rewardsHistory;
    applyShimmer = false;
  }

  // void changeSelectedType(RewardHistoryType newType) {
  //   if (selectedType == newType) {
  //     selectedType = RewardHistoryType.none;
  //     filteredRewardHistory = _rewardsHistory;
  //   } else {
  //     selectedType = newType;
  //     filteredRewardHistory = _rewardsHistory
  //         .where((RewardHistoryResponseModel i) => i.type == newType)
  //         .toList();
  //   }
  //   notifyListeners();
  // }

  Future<void> onEmptyStateTapped() async {
    navigationService.navigateTo(
      StoryViewer.routeName,
      arguments:
          ReferalStoriesView(StackedService.navigatorKey!.currentContext!)
              .storyViewerArgs,
    );
    // if (selectedType == RewardHistoryType.cashback) {
    //   navigationService.navigateTo(
    //     StoryViewer.routeName,
    //     arguments: CashbackStoriesView().storyViewerArgs,
    //   );
    //   return;
    // }
    // navigationService.navigateTo(
    //   StoryViewer.routeName,
    //   arguments:
    //       ReferalStoriesView(StackedService.navigatorKey!.currentContext!)
    //           .storyViewerArgs,
    // );
  }
}
