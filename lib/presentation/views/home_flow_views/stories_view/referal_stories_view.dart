import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class ReferalStoriesView {
  ReferalStoriesView(this.context);
  BuildContext context;
  StoryViewerArgs get storyViewerArgs {
    Widget sharedButtons = PaddingWidget.applyPadding(
      end: 20,
      start: 20,
      bottom: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MainButton(
            onPressed: () async =>
                locator<BottomSheetService>().showCustomSheet(
              enableDrag: false,
              isScrollControlled: true,
              variant: BottomSheetType.shareReferralCode,
            ),
            themeColor: themeColor,
            title: LocaleKeys.storiesView_startSharing.tr(),
            hideShadows: true,
            height: 55,
            enabledTextColor: enabledMainButtonColor(
              context: context,
            ),
            enabledBackgroundColor: myEsimSecondaryBackGroundColor(
              context: context,
            ),
          ),
          verticalSpaceSmall,
          MainButton(
            onPressed: () => locator<NavigationService>().back(),
            themeColor: themeColor,
            title: LocaleKeys.storiesView_notNow.tr(),
            hideShadows: true,
            height: 55,
            enabledTextColor: enabledMainButtonColor(
              context: context,
            ),
            enabledBackgroundColor: enabledMainButtonTextColor(
              context: context,
            ),
          ),
        ],
      ),
    );

    return StoryViewerArgs(
      autoClose: false,
      indicatorHeight: 4,
      stories: <StoryItem>[
        StoryItem(
          content: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  EnvironmentImages.storyBuilding.fullImagePath,
                ),
                fit: BoxFit.cover, // Cover, contain, etc.
              ),
            ),
            child: PaddingWidget.applyPadding(
              top: 120,
              start: 20,
              end: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        LocaleKeys.storiesView_referralTitle1.tr(),
                        style: headerOneBoldTextStyle(
                          context: context,
                          fontColor: mainWhiteTextColor(
                            context: context,
                          ),
                        ),
                      ),
                      verticalSpaceSmallMedium,
                      Text(
                        LocaleKeys.storiesView_referralContent1.tr(),
                        style: headerFourNormalTextStyle(
                          context: context,
                          fontColor: mainWhiteTextColor(
                            context: context,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          buttons: sharedButtons,
          duration: const Duration(seconds: 5),
          useSplitTransition: true,
        ),
        StoryItem(
          content: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  EnvironmentImages.storyCar.fullImagePath,
                ),
                fit: BoxFit.cover, // Cover, contain, etc.
              ),
            ),
            child: PaddingWidget.applyPadding(
              top: 70,
              child: PaddingWidget.applySymmetricPadding(
                vertical: 50,
                horizontal: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          LocaleKeys.storiesView_referralTitle2.tr(),
                          style: headerOneBoldTextStyle(
                            context: context,
                            fontColor: mainWhiteTextColor(
                              context: context,
                            ),
                          ),
                        ),
                        verticalSpaceSmallMedium,
                        Text(
                          LocaleKeys.storiesView_referralContent2.tr(
                            namedArgs: <String, String>{
                              "referAndEarnAmount":
                              locator<ReferralInfoService>().getReferralAmountAndCurrency,
                            },
                          ),
                          style: headerFourNormalTextStyle(
                            context: context,
                            fontColor: mainWhiteTextColor(
                              context: context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          buttons: sharedButtons,
          duration: const Duration(seconds: 5),
          useSplitTransition: true,
        ),
        StoryItem(
          content: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  EnvironmentImages.storyGirl.fullImagePath,
                ),
                fit: BoxFit.cover, // Cover, contain, etc.
              ),
            ),
            child: PaddingWidget.applyPadding(
              top: 70,
              child: PaddingWidget.applySymmetricPadding(
                vertical: 50,
                horizontal: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          LocaleKeys.storiesView_referralTitle3.tr(),
                          style: headerOneBoldTextStyle(
                            context: context,
                            fontColor: mainWhiteTextColor(
                              context: context,
                            ),
                          ),
                        ),
                        verticalSpaceSmallMedium,
                        Text(
                          LocaleKeys.storiesView_referralContent3.tr(
                            namedArgs: <String, String>{
                              "referAndEarnAmount":
                              locator<ReferralInfoService>().getReferralAmountAndCurrency,
                            },
                          ),
                          style: headerFourNormalTextStyle(
                            context: context,
                            fontColor: mainWhiteTextColor(
                              context: context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          buttons: sharedButtons,
          duration: const Duration(seconds: 5),
          useSplitTransition: true,
        ),
      ],
    );
  }
}
