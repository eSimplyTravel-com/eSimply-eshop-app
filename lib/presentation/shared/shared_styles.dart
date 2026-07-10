import "dart:io";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:flutter/material.dart";

//Theme Color
Color themeColor = Colors.blue;

// Box Decorations
BoxDecoration fieldDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: Colors.grey[200],
);

BoxDecoration disabledFieldDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: Colors.grey[100],
);

// Color Variables

//text
Color mainDarkTextColor({required BuildContext context}) =>
    context.appColors.secondary_600!;

Color mainWhiteTextColor({required BuildContext context}) =>
    context.appColors.baseWhite!;

Color titleTextColor({required BuildContext context}) =>
    context.appColors.primaryAlt_900!;

Color faqTitleTextColor({required BuildContext context}) =>
    context.appColors.primaryAlt_800!;

Color secondaryTextColor({required BuildContext context}) =>
    context.appColors.greyAlt_600!;

Color contentTextColor({required BuildContext context}) =>
    context.appColors.grey_600!;

Color errorTextColor({required BuildContext context}) =>
    context.appColors.error_500!;

Color sectionTitleTextColor({required BuildContext context}) =>
    context.appColors.secondaryAlt_600!;

Color regionCountryBundleTitleTextColor({required BuildContext context}) =>
    context.appColors.primaryAlt_900!;

Color bundleDataPriceTextColor({required BuildContext context}) =>
    context.appColors.primaryAlt_800!;

Color emptyStateTextColor({required BuildContext context}) =>
    context.appColors.secondary_600!;

//button text
Color enabledMainButtonTextColor({required BuildContext context}) =>
    context.appColors.baseWhite!;

Color enabledSecondaryButtonTextColor({required BuildContext context}) =>
    context.appColors.secondary_600!;

Color disabledMainButtonTextColor({required BuildContext context}) =>
    context.appColors.baseWhite!;

Color bubbleCountryTextColor({required BuildContext context}) =>
    context.appColors.baseBlack!;

//button color
Color enabledMainButtonColor({required BuildContext context}) =>
    context.appColors.baseBlack!;

Color enabledMainDarkButtonColor({required BuildContext context}) =>
    context.appColors.secondary_600!;

Color enabledMainWhiteButtonColor({required BuildContext context}) =>
    context.appColors.baseWhite!;

Color googleButtonColor({required BuildContext context}) =>
    Platform.isIOS &&
        AppEnvironment.appEnvironmentHelper.enableAppleSignIn? context.appColors.grey_700! : context.appColors.secondary_600!;

Color facebookButtonColor({required BuildContext context}) =>
    context.appColors.primaryAlt_500!;

Color disabledMainButtonColor({required BuildContext context}) =>
    context.appColors.greyAlt_200!;

Color iconButtonColor({required BuildContext context}) =>
    context.appColors.secondary_600!;

Color secondaryIconButtonColor({required BuildContext context}) =>
    context.appColors.primaryAlt_800!;

Color myEsimIconButtonColor({required BuildContext context}) =>
    context.appColors.secondaryAltIconBtn_600!;

Color userGuideButtonColor({required BuildContext context}) =>
    context.appColors.secondaryAltIconBtn_600!;

Color emptyStateButtonColor({required BuildContext context}) =>
    context.appColors.primaryAlt_800!;

Color promoCodeButtonColor({required BuildContext context}) =>
    context.appColors.secondaryAltIconBtn_600!;

//border color
Color errorBorderColor({required BuildContext context}) =>
    context.appColors.error_300!;

Color mainBorderColor({required BuildContext context}) =>
    context.appColors.grey_200!;

//background
Color myEsimSecondaryBackGroundColor({required BuildContext context}) =>
    context.appColors.secondaryAltIconBtn_600!;

Color mainTabBackGroundColor({required BuildContext context}) =>
    context.appColors.primaryAltBtn_800!;

Color whiteBackGroundColor({required BuildContext context}) =>
    context.appColors.baseWhite!;

Color greyBackGroundColor({required BuildContext context}) =>
    context.appColors.grey_200!;

Color lightGreyBackGroundColor({required BuildContext context}) =>
    context.appColors.grey_100!;

Color bottomNavbarSelectedBackGroundColor({required BuildContext context}) =>
    context.appColors.primaryAlt_800!;

Color bottomNavbarUnselectedBackGroundColor({required BuildContext context}) =>
    context.appColors.grey_400!;

Color appBarBackGround({required BuildContext context}) =>
    context.appColors.grey_25!;

Color toastBackGroundColor({required BuildContext context}) =>
    context.appColors.grey_500!;

Color bodyBackGroundColor({required BuildContext context}) =>
    context.appColors.grey_50!;

Color mainShimmerColor({required BuildContext context}) =>
    context.appColors.grey_300!;

Color mainAppBackGroundColor({required BuildContext context}) =>
    context.appColors.primary_900!;

//other
Color hyperLinkColor({required BuildContext context}) =>
    context.appColors.hyperLink!;

Color notificationBadgeColor({required BuildContext context}) =>
    context.appColors.indigo_700!;

Color enabledSwitchColor({required BuildContext context}) =>
    context.appColors.primaryAlt_25!;

Color switchThumbColor({required BuildContext context}) =>
    context.appColors.primaryAltSwitchBtn_800!;

Color consumptionValueColor({required BuildContext context}) =>
    context.appColors.primary_800!;

Color consumptionBackgroundColor({required BuildContext context}) =>
    context.appColors.primary_50!;

Color unlimitedTextColor({required BuildContext context}) =>
    context.appColors.baseWhite!;

Color unlimitedBackgroundColor({required BuildContext context}) =>
    context.appColors.unlimited!;

// Fonts
TextStyle headerZeroMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerZeroBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerOneNormalTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerOneMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerOneBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  double fontSize = 30,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerTwoMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerTwoBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerThreeMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerThreeBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerFourMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle headerFourNormalTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle bodyNormalTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle bodyMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle bodyBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle unlimitedBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: fontColor ?? context.appColors.baseWhite,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      height: 0.9,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle unlimitedDataBundleTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    unlimitedBoldTextStyle(
      context: context,
      fontFamily: fontFamily,
      fontColor: fontColor,
      isItalic: isItalic,
    ).copyWith(
      fontSize: 15,
    );

TextStyle captionOneNormalTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle captionOneMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle captionOneBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle captionTwoNormalTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle captionTwoMediumTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle captionTwoBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle captionThreeNormalTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );

TextStyle captionFourBoldTextStyle({
  required BuildContext context,
  String? fontFamily,
  Color? fontColor,
  bool isItalic = false,
}) =>
    TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
      color: fontColor ?? context.appColors.baseBlack,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontFamily:
          fontFamily ?? Theme.of(context).textTheme.labelLarge?.fontFamily,
    );
