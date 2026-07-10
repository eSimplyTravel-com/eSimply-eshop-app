import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

class LoginView extends StatelessWidget {
  const LoginView({super.key, this.redirection});

  static const String routeName = "LoginViewPage";
  final InAppRedirection? redirection;

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      routeName: routeName,
      viewModel: locator<LoginViewModel>()..redirection = redirection,
      hideAppBar: true,
      updateStatusBarColor: true,
      statusBarColor: Colors.transparent,
      backGroundImage: EnvironmentImages.onBoardingBackground.fullImagePath,
      builder: (
        BuildContext context,
        LoginViewModel viewModel,
        Widget? child,
        double screenHeight,
      ) =>
          PaddingWidget.applySymmetricPadding(
        vertical: 15,
        horizontal: 20,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  GestureDetector(
                    key: const Key("backButtonPressed"),
                    onTap: () async {
                      viewModel.backButtonPressed();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        EnvironmentImages.whiteCloseIcon.fullImagePath,
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Image.asset(
                    EnvironmentImages.whiteAppIcon.fullImagePath,
                    width: screenWidth(context) / 2,
                    fit: BoxFit.fitWidth,
                  ),
                  verticalSpaceLarge,
                  verticalSpaceLarge,
                  Text(
                    LocaleKeys.loginView_titleText.tr(),
                    textAlign: TextAlign.center,
                    style: headerOneBoldTextStyle(
                      context: context,
                      fontColor: mainWhiteTextColor(context: context),
                      fontSize: 28,
                    ),
                  ),
                  verticalSpaceSmall,
                  Text(
                    LocaleKeys.loginView_subTitleText.tr(),
                    textAlign: TextAlign.center,
                    style: captionOneNormalTextStyle(
                      context: context,
                      fontColor: mainWhiteTextColor(context: context),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Column(
                children: <Widget>[
                  AppEnvironment.appEnvironmentHelper.enableFacebookSignIn
                      ? MainButton.continueWith(
                          params: MainButtonParams(
                            title: LocaleKeys.loginView_continueWithFacebook.tr(),
                            onPressed: () {},
                            themeColor: themeColor,
                            titleTextStyle: bodyBoldTextStyle(context: context),
                            containerPadding: const EdgeInsets.only(bottom: 10),
                          ),
                          action: () async {
                            await viewModel.socialMediaSignInAction(
                              SocialMediaLoginType.facebook,
                            );
                          },
                          image: EnvironmentImages.loginFacebook.fullImagePath,
                          textColor: mainWhiteTextColor(context: context),
                          buttonColor: facebookButtonColor(context: context),
                        )
                      : const SizedBox.shrink(),
                  Platform.isIOS &&
                          AppEnvironment.appEnvironmentHelper.enableAppleSignIn
                      ? MainButton.continueWith(
                          params: MainButtonParams(
                            title: LocaleKeys.loginView_continueWithApple.tr(),
                            onPressed: () {},
                            themeColor: themeColor,
                            titleTextStyle: bodyBoldTextStyle(context: context),
                            containerPadding: const EdgeInsets.only(bottom: 10),
                          ),
                          action: () async {
                            await viewModel.socialMediaSignInAction(
                              SocialMediaLoginType.apple,
                            );
                          },
                          image: EnvironmentImages.loginApple.fullImagePath,
                          textColor: mainWhiteTextColor(context: context),
                          buttonColor:
                              enabledMainDarkButtonColor(context: context),
                        )
                      : const SizedBox.shrink(),
                  AppEnvironment.appEnvironmentHelper.enableGoogleSignIn
                      ? MainButton.continueWith(
                          params: MainButtonParams(
                            title: LocaleKeys.loginView_continueWithGoogle.tr(),
                            onPressed: () {},
                            themeColor: themeColor,
                            titleTextStyle: bodyBoldTextStyle(context: context),
                            containerPadding: const EdgeInsets.only(bottom: 10),
                          ),
                          action: () async {
                            await viewModel.socialMediaSignInAction(
                              SocialMediaLoginType.google,
                            );
                          },
                          image: EnvironmentImages.loginGoogle.fullImagePath,
                          textColor: mainWhiteTextColor(context: context),
                          buttonColor: googleButtonColor(context: context),
                        )
                      : const SizedBox.shrink(),
                  MainButton.continueWith(
                    params: MainButtonParams(
                      title: getContinueWithText(),
                      onPressed: () {},
                      themeColor: themeColor,
                      titleTextStyle: bodyBoldTextStyle(context: context),
                      containerPadding: const EdgeInsets.only(bottom: 10),
                    ),
                    action: () async {
                      viewModel.navigateToSignInPage();
                    },
                    image: EnvironmentImages.loginMail.fullImagePath,
                    textColor: mainDarkTextColor(context: context),
                    buttonColor: enabledMainWhiteButtonColor(context: context),
                  ),
                  PaddingWidget.applyPadding(
                    top: 10,
                    child: termsAndConditionTappableWidget(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget termsAndConditionTappableWidget(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: LocaleKeys.loginView_termsFirstText.tr(),
        style: captionOneNormalTextStyle(
          context: context,
          fontColor: mainWhiteTextColor(context: context),
        ).copyWith(fontSize: 13),
        children: <TextSpan>[
          TextSpan(
            text: LocaleKeys.loginView_termsText.tr(),
            style: captionOneMediumTextStyle(
              context: context,
              fontColor: mainWhiteTextColor(context: context),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                log("Tappable word clicked!");
              },
          ),
          TextSpan(
            text: LocaleKeys.loginView_termsSecondText.tr(),
            style: captionOneNormalTextStyle(
              context: context,
              fontColor: mainWhiteTextColor(context: context),
            ).copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  String getContinueWithText() {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
        return LocaleKeys.loginView_continueWithEmail.tr();
      case LoginType.phoneNumber:
      case LoginType.emailAndPhone:
        return LocaleKeys.loginView_continueWithPhone.tr();
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        return LocaleKeys.loginView_continueWithPhone.tr();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<InAppRedirection?>("redirection", redirection),
    );
  }
}
