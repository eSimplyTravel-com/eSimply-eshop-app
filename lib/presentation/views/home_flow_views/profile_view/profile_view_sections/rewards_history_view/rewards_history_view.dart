import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/reward_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/rewards_history_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_state_list_view.dart";
import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class RewardsHistoryView extends StatelessWidget {
  const RewardsHistoryView({super.key});

  static const String routeName = "RewardsHistoryView";

  @override
  Widget build(BuildContext context) {
    return BaseView<RewardsHistoryViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: locator<RewardsHistoryViewModel>(),
      builder: (
        BuildContext context,
        RewardsHistoryViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        height: double.infinity,
        child: PaddingWidget.applyPadding(
          top: 20,
          child: Column(
            children: <Widget>[
              CommonNavigationTitle(
                navigationTitle: LocaleKeys.rewardHistory_titleText.tr(),
                textStyle: headerTwoBoldTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ),
              verticalSpaceSmall,
              // rewardHistoryTypeWidget(
              //   context,
              //   viewModel,
              // ),
              Expanded(
                child: PaddingWidget.applyPadding(
                  top: 20,
                  start: 15,
                  end: 15,
                  child: EmptyStateListView<RewardHistoryResponseModel>(
                    items: viewModel.filteredRewardHistory,
                    onRefresh: () async => viewModel.getRewardsHistory(),
                    emptyStateWidget: SizedBox(
                      height: screenHeight - 200,
                      child: EmptyStateWidget(
                        title: LocaleKeys.rewardHistory_emptyTitleText.tr(),
                        imagePath:
                            EnvironmentImages.emptyRewardHistory.fullImagePath,
                        content: LocaleKeys.rewardHistory_emptyContentText.tr(),
                        button: MainButton.bannerButton(
                          params: BannerButtonParams(
                            title: LocaleKeys.rewardHistory_referTypeTitle
                                .tr() /*viewModel.selectedType.titleText*/,
                            action: () async => viewModel.onEmptyStateTapped(),
                            themeColor: themeColor,
                            textColor:
                                enabledMainButtonTextColor(context: context),
                            buttonColor: enabledMainButtonColor(context: context),
                            titleTextStyle: captionOneBoldTextStyle(
                              context: context,
                            ),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        verticalSpaceSmallMedium,
                    itemBuilder: (BuildContext context, int index) =>
                        RewardHistoryView(
                      rewardHistoryModel:
                          viewModel.filteredRewardHistory[index],
                    ).applyShimmer(
                      params: ShimmerParams(
                        context: context,
                        enable: viewModel.applyShimmer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget rewardHistoryTypeWidget(
//   BuildContext context,
//   RewardsHistoryViewModel viewModel,
// ) {
//   return PaddingWidget.applySymmetricPadding(
//     horizontal: 15,
//     child: SizedBox(
//       height: 30,
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: ListView.separated(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: RewardHistoryType.values.length,
//           separatorBuilder: (BuildContext context, int index) {
//             if (RewardHistoryType.values[index] == RewardHistoryType.none) {
//               return const SizedBox.shrink();
//             }
//             return const SizedBox(width: 10);
//           },
//           itemBuilder: (BuildContext context, int index) {
//             if (RewardHistoryType.values[index] == RewardHistoryType.none) {
//               return const SizedBox.shrink();
//             }
//             return GestureDetector(
//               onTap: () {
//                 viewModel.changeSelectedType(RewardHistoryType.values[index]);
//               },
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: RewardHistoryType.values[index] ==
//                           viewModel.selectedType
//                       ? enabledMainButtonColor(context: context)
//                       : mainWhiteTextColor(context: context),
//                   border: Border.all(
//                     color: mainBorderColor(context: context),
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: PaddingWidget.applySymmetricPadding(
//                   vertical: 5,
//                   horizontal: 10,
//                   child: Center(
//                     child: Text(
//                       RewardHistoryType.values[index].titleText,
//                       style: captionTwoNormalTextStyle(context: context)
//                           .copyWith(
//                         color: RewardHistoryType.values[index] ==
//                                 viewModel.selectedType
//                             ? mainWhiteTextColor(context: context)
//                             : contentTextColor(context: context),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     ),
//   );
// }
}
