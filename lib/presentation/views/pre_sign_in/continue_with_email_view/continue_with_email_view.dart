import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/my_phone_input.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class ContinueWithEmailViewArgs {
  ContinueWithEmailViewArgs({
    this.redirection,
    this.localLoginType,
  });

  final InAppRedirection? redirection;
  final LoginType? localLoginType;
}

class ContinueWithEmailView extends StatelessWidget {
  const ContinueWithEmailView({
    super.key,
    this.redirection,
    LoginType? localLoginType,
  }) : _localLoginType = localLoginType;

  static const String routeName = "ContinueWithEmailView";
  final InAppRedirection? redirection;

  final LoginType? _localLoginType;

  LoginType get localLoginType =>
      _localLoginType ?? AppEnvironment.appEnvironmentHelper.loginType;

  @override
  Widget build(BuildContext context) {
    return BaseView<ContinueWithEmailViewModel>(
      routeName: routeName,
      hideAppBar: true,
      viewModel: locator<ContinueWithEmailViewModel>()
        ..redirection = redirection,
      builder: (
        BuildContext context,
        ContinueWithEmailViewModel viewModel,
        Widget? child,
        double screenHeight,
      ) =>
          KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: PaddingWidget.applySymmetricPadding(
            vertical: 10,
            horizontal: 20,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: viewModel.backButtonTapped,
                      child: Image.asset(
                        EnvironmentImages.navBackIcon.fullImagePath,
                        width: 25,
                        height: 25,
                      ),
                    ).imageSupportsRTL(context).textSupportsRTL(context),
                  ),
                  Image.asset(
                    EnvironmentImages.darkAppIcon.fullImagePath,
                    width: screenWidth(context) / 2.5,
                    fit: BoxFit.fitWidth,
                  ),
                  verticalSpaceMassive,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        LocaleKeys.continueWithEmailView_titleText.tr(),
                        style: headerTwoMediumTextStyle(
                          context: context,
                          fontColor: mainDarkTextColor(context: context),
                        ),
                      ),
                      verticalSpaceSmall,
                      Text(
                        getLoginInstructionText(),
                        style: bodyNormalTextStyle(
                          context: context,
                          fontColor: secondaryTextColor(context: context),
                        ),
                      ),
                      verticalSpaceSmall,
                      verticalSpace(
                        (localLoginType == LoginType.emailAndPhone ||
                            localLoginType == LoginType.emailAndPhoneAndEmailVerification ||
                            localLoginType == LoginType.emailAndPhoneAndBothVerification) ? 60 : 90,
                      ),
                      viewModel.showEmailField
                          ? MainInputField.formField(
                              controller: viewModel.state?.emailController ??
                                  TextEditingController(),
                              themeColor: themeColor,
                              textConfig: MainInputFieldTextConfig(
                                labelTitleText: LocaleKeys
                                    .continueWithEmailView_emailTitleField
                                    .tr(),
                                hintText: LocaleKeys
                                    .continueWithEmailView_emailPlaceholder
                                    .tr(),
                                errorMessage: viewModel.state?.emailErrorMessage,
                              ),
                              appearanceConfig: MainInputFieldAppearanceConfig(
                                backgroundColor: context.appColors.baseWhite,
                                labelStyle: bodyNormalTextStyle(
                                  context: context,
                                  fontColor: secondaryTextColor(context: context),
                                ),
                              ),
                              inputConfig: const MainInputFieldInputConfig(
                                textInputType: TextInputType.emailAddress,
                              ),
                            )
                          : Container(),
                      localLoginType == LoginType.emailAndPhone
                          ? verticalSpaceSmall
                          : Container(),
                      viewModel.showPhoneField
                          ? Column(
                              children: <Widget>[
                                PaddingWidget.applySymmetricPadding(
                                  vertical: 5,
                                  child: Text(
                                    LocaleKeys.phoneInput_placeHolder.tr(),
                                    style: captionOneMediumTextStyle(
                                      context: context,
                                      fontColor:
                                          secondaryTextColor(context: context),
                                    ),
                                  ).textSupportsRTL(context),
                                ),
                                MyPhoneInput(
                                  onChanged: (
                                    String code,
                                    String phoneNumber, {
                                    required bool isValid,
                                  }) {
                                    viewModel.validateNumber(
                                      code: code,
                                      number: phoneNumber,
                                      isValid: isValid,
                                    );
                                  },
                                  phoneController: viewModel.phoneController,
                                  validateRequired: true,
                                ),
                              ],
                            )
                          : Container(),
                      verticalSpaceMediumLarge,
                      GestureDetector(
                        key: const Key("checkBox"),
                        onTap: () {
                          viewModel.updateTermsSelections();
                        },
                        child: Row(
                          children: <Widget>[
                            Align(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                  bottom: 10,
                                  top: 10,
                                ),
                                child: Image.asset(
                                  width: 17,
                                  (viewModel.state?.isTermsChecked ?? false)
                                      ? EnvironmentImages
                                          .checkBoxSelected.fullImagePath
                                      : EnvironmentImages
                                          .checkBoxUnselected.fullImagePath,
                                ),
                              ),
                            ),
                            horizontalSpaceSmall,
                            Expanded(
                              child: termsAndConditionTappableWidget(
                                context,
                                viewModel,
                              ).textSupportsRTL(context),
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceLarge,
                      _buildButtonSection(context, viewModel),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget termsAndConditionTappableWidget(
    BuildContext context,
    ContinueWithEmailViewModel viewModel,
  ) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: LocaleKeys.continueWithEmailView_acceptTerms.tr(),
        style: captionOneMediumTextStyle(
          context: context,
          fontColor: mainDarkTextColor(context: context),
        ),
        children: <TextSpan>[
          TextSpan(
            text: LocaleKeys.continueWithEmailView_termsText.tr(),
            style: captionOneMediumTextStyle(context: context).copyWith(
              fontSize: 14,
              color: hyperLinkColor(context: context),
              decoration: TextDecoration.underline,
              decorationColor: hyperLinkColor(context: context),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                viewModel.showTermsSheet();
              },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection(
    BuildContext context,
    ContinueWithEmailViewModel viewModel,
  ) {
    if (localLoginType == LoginType.emailAndPhoneAndBothVerification) {
      return Column(
        children: <Widget>[
          MainButton(
            title: LocaleKeys.continueWithEmail_signInViaEmail.tr(),
            onPressed: () async {
              viewModel.loginButtonTappedWithChannel("EMAIL");
            },
            themeColor: themeColor,
            height: 53,
            hideShadows: true,
            isEnabled: viewModel.state?.isLoginEnabled ?? false,
            enabledTextColor:
                enabledMainButtonTextColor(context: context),
            disabledTextColor:
                disabledMainButtonTextColor(context: context),
            disabledBackgroundColor:
                disabledMainButtonColor(context: context),
            enabledBackgroundColor:
                enabledMainButtonColor(context: context),
          ),
          verticalSpaceSmall,
          Center(
            child: Text(
              LocaleKeys.continueWithEmail_or.tr(),
              style: bodyNormalTextStyle(
                context: context,
                fontColor: secondaryTextColor(context: context),
              ),
            ),
          ),
          verticalSpaceSmall,
          MainButton(
            title: LocaleKeys.continueWithEmail_signInViaSms.tr(),
            onPressed: () async {
              viewModel.loginButtonTappedWithChannel("SMS");
            },
            themeColor: themeColor,
            height: 53,
            hideShadows: true,
            isEnabled: viewModel.state?.isLoginEnabled ?? false,
            enabledTextColor:
                enabledMainButtonTextColor(context: context),
            disabledTextColor:
                disabledMainButtonTextColor(context: context),
            disabledBackgroundColor:
                disabledMainButtonColor(context: context),
            enabledBackgroundColor:
                enabledMainButtonColor(context: context),
          ),
          if (viewModel.otpSendErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                viewModel.otpSendErrorMessage!,
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: errorTextColor(context: context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
    }
    return MainButton(
      title: LocaleKeys.continueWithEmailView_titleText.tr(),
      onPressed: () async {
        viewModel.loginButtonTapped();
      },
      themeColor: themeColor,
      height: 53,
      hideShadows: true,
      isEnabled: viewModel.state?.isLoginEnabled ?? false,
      enabledTextColor:
          enabledMainButtonTextColor(context: context),
      disabledTextColor:
          disabledMainButtonTextColor(context: context),
      disabledBackgroundColor:
          disabledMainButtonColor(context: context),
      enabledBackgroundColor:
          enabledMainButtonColor(context: context),
    );
  }

  String getContinueWithEmailSubtitleText() {
    switch (localLoginType) {
      case LoginType.email:
        return LocaleKeys.continueWithEmailView_SubTitleText.tr();
      case LoginType.phoneNumber:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        return LocaleKeys.continueWithEmailView_SubTitleTextPhone.tr();
    }
  }

  String getLoginInstructionText() {
    switch (localLoginType) {
      case LoginType.email:
        return LocaleKeys.loginView_instructionText_email.tr();
      case LoginType.phoneNumber:
        return LocaleKeys.loginView_instructionText_phone.tr();
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        return LocaleKeys.loginView_instructionText_emailPhone.tr();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<InAppRedirection?>("redirection", redirection),
      )
      ..add(EnumProperty<LoginType>("localLoginType", localLoginType));
  }
}
