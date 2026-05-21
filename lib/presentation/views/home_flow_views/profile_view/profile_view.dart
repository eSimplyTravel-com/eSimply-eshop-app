import "package:adaptive_platform_ui/adaptive_platform_ui.dart";
import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static String routeName = "ProfileView";

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      hideAppBar: true,
      routeName: routeName,
      enableBottomSafeArea: false,
      fireOnViewModelReadyOnce: true,
      viewModel: locator<ProfileViewModel>(),
      builder: (
        BuildContext context,
        ProfileViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applySymmetricPadding(
        horizontal: 15,
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Image.asset(
                EnvironmentImages.profilePerson.fullImagePath,
                width: 80,
                height: 80,
              ),
              verticalSpaceSmall,
              getTopTrialingWidget(
                context: context,
                viewModel: viewModel,
              ),
              // verticalSpaceMediumLarge,
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     LocaleKeys.profile_settings.tr(),
              //     style:
              //         mainPlaceHolderTitleTextStyle(context: context).copyWith(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              // verticalSpaceSmall,
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: ProfileViewSections.values.length,
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      profileSectionSeparationView(
                    context,
                    viewModel,
                    ProfileViewSections.values[index],
                  ),
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      profileSectionView(
                    context,
                    viewModel,
                    ProfileViewSections.values[index],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 5,
                  bottom: PlatformInfo.isIOS26OrHigher() ? 90 : 5,
                ),
                child: Text(
                  LocaleKeys.profile_version.tr(
                    namedArgs: <String, String>{
                      "version": viewModel.appVersion,
                      "buildNumber": viewModel.buildNumber,
                    },
                  ),
                  style: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: contentTextColor(context: context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileSectionSeparationView(
    BuildContext context,
    ProfileViewModel viewModel,
    ProfileViewSections section,
  ) {
    if (section.isViewHidden(viewModel) || section.isHeaderTitle) {
      return const SizedBox.shrink();
    } else {
      return Divider(
        color: greyBackGroundColor(context: context),
      );
    }
  }

  Widget profileSectionView(
    BuildContext context,
    ProfileViewModel viewModel,
    ProfileViewSections section,
  ) {
    if (section.isViewHidden(viewModel)) {
      return const SizedBox.shrink();
    } else if (section.isHeaderTitle) {
      return Column(
        children: <Widget>[
          verticalSpaceMediumLarge,
          Text(
            section.sectionTitle,
            style: captionOneNormalTextStyle(
              context: context,
              fontColor: sectionTitleTextColor(context: context),
            ),
          ).textSupportsRTL(context),
          verticalSpaceSmall,
        ],
      );
    } else {
      return GestureDetector(
        onTap: () async {
          section.tapAction(viewModel);
        },
        child: ColoredBox(
          color: Colors.transparent,
          child: PaddingWidget.applySymmetricPadding(
            vertical: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      section.sectionImagePath,
                      width: 15,
                      height: 15,
                    ),
                    horizontalSpaceSmall,
                    Text(
                      section.sectionTitle,
                      style: bodyNormalTextStyle(
                        context: context,
                        fontColor: titleTextColor(context: context),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  EnvironmentImages.darkArrowRight.fullImagePath,
                  width: 15,
                  height: 15,
                ).imageSupportsRTL(context),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget getTopTrialingWidget({
    required BuildContext context,
    required ProfileViewModel viewModel,
  }) {
    return Column(
      children: <Widget>[
        Text(
          viewModel.isUserLoggedIn
              ? viewModel.getUserName()
              : LocaleKeys.profile_guest.tr(),
          textAlign: TextAlign.center,
          style: headerThreeBoldTextStyle(
            context: context,
            fontColor: mainDarkTextColor(
              context: context,
            ),
          ),
        ),
        viewModel.isUserLoggedIn
            ? const SizedBox.shrink()
            : Column(
                children: <Widget>[
                  verticalSpaceTiny,
                  MainButton.bannerButton(
                    params: BannerButtonParams(
                      title: LocaleKeys.profile_login.tr(),
                      action: () async {
                        viewModel.loginButtonTapped();
                      },
                      themeColor: themeColor,
                      titleHorizontalPadding: 15,
                      textColor: enabledMainButtonTextColor(context: context),
                      buttonColor: enabledMainButtonColor(context: context),
                      titleTextStyle: bodyBoldTextStyle(
                        context: context,
                        fontColor: mainWhiteTextColor(context: context),
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
