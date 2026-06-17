import "package:easy_localization/easy_localization.dart" show StringTranslateExtension;
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/bundle_details_bottom_sheet/bundle_detail_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/apply_promo_code_view.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_title_content_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_validity_view.dart";
import "package:esim_open_source/presentation/widgets/divider_line.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/my_phone_input.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_card.dart";
import "package:esim_open_source/presentation/widgets/unlimited_data_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:stacked_services/stacked_services.dart";

class BundleDetailBottomSheetView extends StatelessWidget {
  const BundleDetailBottomSheetView({
    required this.requestBase,
    required this.completer,
    super.key,
  });

  final SheetRequest<PurchaseBundleBottomSheetArgs> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: locator<BundleDetailBottomSheetViewModel>()
        ..bundle = requestBase.data?.bundleResponseModel
        ..tempBundle = requestBase.data?.bundleResponseModel
        ..region = requestBase.data?.region
        ..countriesList = requestBase.data?.countries,
      builder: (
        BuildContext context,
        BundleDetailBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        return KeyboardDismissOnTap(
          child: PaddingWidget.applySymmetricPadding(
            vertical: 15,
            horizontal: 15,
            child: SizedBox(
              height: screenHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BottomSheetCloseButton(
                    onTap: () => completer(
                      SheetResponse<EmptyBottomSheetResponse>(),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight -
                        100 -
                        (viewModel.isKeyboardVisible(context) ? 200 : 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _buildBundleHeader(viewModel.bundle),
                          const DividerLine(),
                          _buildDataAndPrice(context, viewModel.bundle),
                          const DividerLine(),
                          BundleValidityView(
                            bundleValidity: viewModel.bundle?.getValidityDisplay() ?? "",
                            bundleExpiryDate: "",
                          ),
                          verticalSpaceSmall,
                          _buildCountriesCard(viewModel.bundle),
                          _buildPromoCodeSection(context, viewModel),
                          BundleTitleContentView(
                            titleText:
                                LocaleKeys.bundleDetails_planTypeText.tr(),
                            contentText: LocaleKeys
                                .bundleDetails_planTypeText_dataOnly
                                .tr(),
                          ),
                          const DividerLine(
                            verticalPadding: 0,
                          ),
                          BundleTitleContentView(
                            titleText: LocaleKeys
                                .bundleDetails_activationPolicyText
                                .tr(),
                            contentText: LocaleKeys
                                .bundleDetails_activationPolicy_Value
                                .tr(),
                          ),
                          _buildGuestUserSection(context, viewModel),
                          verticalSpaceSmallMedium,
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildPurchaseButton(context, viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBundleHeader(BundleResponseModel? bundle) {
    return BundleHeaderView(
      imagePath: _getBundleHeaderImagePath(bundle),
      title: bundle?.displayTitle ?? "",
      subTitle: bundle?.displaySubtitle ?? "",
      dataValue: "",
      countryPrice: "",
      hasNavArrow: false,
      isLoading: false,
      showUnlimitedData: false,
    );
  }

  String? _getBundleHeaderImagePath(BundleResponseModel? bundle) {
    final bool isCruise = bundle?.isCruise ?? false;
    return isCruise ? EnvironmentImages.globalFlag.fullImagePath : bundle?.icon;
  }

  Widget _buildDataAndPrice(BuildContext context, BundleResponseModel? bundle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildDataWidget(context, bundle),
        _buildPriceWidget(context, bundle),
      ],
    );
  }

  Widget _buildDataWidget(BuildContext context, BundleResponseModel? bundle) {
    final bool isUnlimited = bundle?.unlimited ?? false;
    if (isUnlimited) {
      return const UnlimitedDataWidget();
    }
    return Text(
      bundle?.gprsLimitDisplay ?? "",
      textDirection: TextDirection.ltr,
      style: headerTwoMediumTextStyle(
        context: context,
        fontColor: bundleDataPriceTextColor(context: context),
      ),
    );
  }

  Widget _buildPriceWidget(BuildContext context, BundleResponseModel? bundle) {
    return Text(
      bundle?.priceDisplay ?? "",
      style: headerTwoMediumTextStyle(
        context: context,
        fontColor: bundleDataPriceTextColor(context: context),
      ),
    );
  }

  Widget _buildCountriesCard(BundleResponseModel? bundle) {
    if (!_shouldShowCountriesCard(bundle)) {
      return const SizedBox.shrink();
    }
    return SupportedCountriesCard(
      countries: _getCountriesToDisplay(bundle),
    );
  }

  bool _shouldShowCountriesCard(BundleResponseModel? bundle) {
    final bool isNotCruiseType = bundle?.bundleCategory?.type?.toLowerCase() !=
        AppEnvironment.appEnvironmentHelper.cruiseIdentifier;
    final bool hasCountries = bundle?.countries?.isNotEmpty ?? false;
    return isNotCruiseType && hasCountries;
  }

  List<CountryResponseModel> _getCountriesToDisplay(BundleResponseModel? bundle) {
    final bool isCruiseCategory = bundle?.bundleCategory?.isCruise ?? false;
    if (isCruiseCategory) {
      return <CountryResponseModel>[];
    }
    return bundle?.countries ?? <CountryResponseModel>[];
  }

  Widget _buildPromoCodeSection(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    if (!_shouldShowPromoCode(viewModel)) {
      return const SizedBox.shrink();
    }
    return PaddingWidget.applySymmetricPadding(
      vertical: 10,
      child: ApplyPromoCode(
        callback: viewModel.validatePromoCode,
        message: viewModel.promoCodeMessage,
        isFieldEnabled: viewModel.promoCodeFieldEnabled,
        textFieldBorderColor:
            viewModel.promoCodeFieldColor ??
                greyBackGroundColor(context: context),
        textFieldIcon: viewModel.promoCodeFieldIcon,
        buttonText: viewModel.promoCodeButtonText,
        controller: viewModel.promoCodeController,
        isExpanded: viewModel.isPromoCodeExpanded,
        expandedCallBack: viewModel.expandedCallBack,
      ),
    );
  }

  bool _shouldShowPromoCode(BundleDetailBottomSheetViewModel viewModel) {
    return viewModel.isPromoCodeEnabled && viewModel.isUserLoggedIn;
  }

  Widget _buildGuestUserSection(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    if (viewModel.isUserLoggedIn) {
      return const SizedBox.shrink();
    }
    return PaddingWidget.applySymmetricPadding(
      horizontal: 5,
      child: Column(
        children: <Widget>[
          _buildEmailOrPhoneInput(context, viewModel),
          _buildTermsCheckbox(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildEmailOrPhoneInput(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    if (viewModel.showPhoneInput) {
      return _buildPhoneInput(context, viewModel);
    }
    return _buildEmailInput(context, viewModel);
  }

  Widget _buildPhoneInput(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        PaddingWidget.applySymmetricPadding(
          vertical: 5,
          child: Text(
            LocaleKeys.phoneInput_placeHolder.tr(),
            style: captionOneMediumTextStyle(
              context: context,
              fontColor: secondaryTextColor(context: context),
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
    );
  }

  Widget _buildEmailInput(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    return MainInputField.formField(
      controller: viewModel.emailController,
      themeColor: themeColor,
      textConfig: MainInputFieldTextConfig(
        labelTitleText: LocaleKeys.continueWithEmailView_emailTitleField.tr(),
        hintText: LocaleKeys.continueWithEmailView_emailPlaceholder.tr(),
        errorMessage: viewModel.emailErrorMessage,
      ),
      appearanceConfig: MainInputFieldAppearanceConfig(
        backgroundColor: whiteBackGroundColor(context: context),
        textFieldHeight: 50,
        labelStyle: bodyNormalTextStyle(
          context: context,
          fontColor: secondaryTextColor(context: context),
        ),
      ),
      inputConfig: const MainInputFieldInputConfig(
        textInputType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildTermsCheckbox(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: viewModel.updateTermsSelections,
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
                _getCheckboxImagePath(viewModel.isTermsChecked),
              ),
            ),
          ),
          horizontalSpaceSmall,
          termsAndConditionTappableWidget(context, viewModel),
        ],
      ),
    );
  }

  String _getCheckboxImagePath(bool isChecked) {
    return isChecked
        ? EnvironmentImages.checkBoxSelected.fullImagePath
        : EnvironmentImages.checkBoxUnselected.fullImagePath;
  }

  Widget _buildPurchaseButton(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
  ) {
    return MainButton(
      hideShadows: true,
      themeColor: themeColor,
      onPressed: () async => viewModel.buyNowPressed(context),
      isEnabled: viewModel.isPurchaseButtonEnabled,
      title: LocaleKeys.bundleInfo_priceText.tr(
        namedArgs: <String, String>{
          "price": viewModel.bundle?.priceDisplay ?? "",
        },
      ),
      enabledTextColor: enabledMainButtonTextColor(context: context),
      enabledBackgroundColor: enabledMainButtonColor(context: context),
      disabledTextColor: disabledMainButtonTextColor(context: context),
      disabledBackgroundColor: disabledMainButtonColor(context: context),
    );
  }

  Widget termsAndConditionTappableWidget(
    BuildContext context,
    BundleDetailBottomSheetViewModel viewModel,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      )
      ..add(
        DiagnosticsProperty<SheetRequest<PurchaseBundleBottomSheetArgs>>(
          "requestBase",
          requestBase,
        ),
      );
  }
}
