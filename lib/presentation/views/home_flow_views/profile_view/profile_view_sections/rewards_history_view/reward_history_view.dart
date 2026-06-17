import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class RewardHistoryView extends StatelessWidget {
  const RewardHistoryView({
    //required this.applyShimmer,
    required this.rewardHistoryModel,
    super.key,
  });

  //final bool applyShimmer;
  final RewardHistoryResponseModel rewardHistoryModel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: mainBorderColor(context: context),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PaddingWidget.applySymmetricPadding(
        vertical: 15,
        horizontal: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // viewHeaderBadge(
            //   context,
            // ),
            verticalSpaceSmallMedium,
            viewBundleContent(
              context,
            ),
            verticalSpaceSmallMedium,
            Text(
              rewardHistoryModel.dateDisplayed,
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: secondaryTextColor(context: context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget viewHeaderBadge(
    BuildContext context,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.warning_50
        /*rewardHistoryModel.type == RewardHistoryType.cashback
            ? context.appColors.indigo_50
            : context.appColors.warning_50*/
        ,
        borderRadius: BorderRadius.circular(12),
      ),
      child: PaddingWidget.applySymmetricPadding(
        vertical: 5,
        horizontal: 10,
        child: Text(
          LocaleKeys.rewardHistory_referTypeTitle
              .tr() /*rewardHistoryModel.type.titleText*/,
          style: captionTwoNormalTextStyle(
            context: context,
            fontColor: context.appColors.warning_700
            /*rewardHistoryModel.type == RewardHistoryType.cashback
                ? context.appColors.indigo_700
                : context.appColors.warning_700*/
            ,
          ),
        ),
      ),
    );
  }

  Widget viewBundleContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            rewardHistoryModel.name ?? "",
            overflow: TextOverflow.ellipsis,
            style: captionOneNormalTextStyle(
              context: context,
              fontColor: contentTextColor(context: context),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              rewardHistoryModel.amount ?? "",
              style: headerThreeBoldTextStyle(
                context: context,
                fontColor: contentTextColor(context: context),
              ),
            ),
            const SizedBox.shrink(),
            /*rewardHistoryModel.type == RewardHistoryType.referEarn
                ? const SizedBox.shrink()
                : Text(
                    rewardHistoryModel.promotionName ?? "",
                    style: captionTwoNormalTextStyle(
                      context: context,
                      fontColor: contentTextColor(context: context),
                    ),
                  ),*/
          ],
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<RewardHistoryResponseModel>(
        "rewardHistoryModel",
        rewardHistoryModel,
      ),
    );
  }
}
