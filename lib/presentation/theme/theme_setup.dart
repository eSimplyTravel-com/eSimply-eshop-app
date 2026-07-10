import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_theme.dart";
import "package:esim_open_source/presentation/theme/color_templates/open_source_color_template.dart";
import "package:esim_open_source/presentation/theme/color_templates/template_app_colors.dart";
import "package:esim_open_source/presentation/theme/theme_dark.dart";
import "package:esim_open_source/presentation/theme/theme_light.dart";
import "package:flutter/material.dart";

// https://www.filledstacks.com/post/multiple-themes-in-flutter-dark-and-light-theme-flutter-stacked/
// getThemeManager(context).toggleDarkLightTheme();
// getThemeManager(context).selectThemeAtIndex(1);
// Theme.of(context).backgroundColor
List<ThemeData> getThemes() {
  return <ThemeData>[
    themeLight,
    themeDark,
    // themeLightHighContrast,
    // themeHighContrast,
  ];
}

TemplateAppColors get templateAppColors {
  switch (AppEnvironment.appEnvironmentHelper.environmentTheme) {
    case EnvironmentTheme.openSource:
      return OpenSourceColorTemplate();
  }
}

class AppColors extends ThemeExtension<AppColors> {
  AppColors({
    required this.baseBlack,
    required this.baseWhite,
    required this.baseNavy,
    required this.error_50,
    required this.error_300,
    required this.error_500,
    required this.grey_1,
    required this.grey_25,
    required this.grey_50,
    required this.grey_100,
    required this.grey_200,
    required this.greyAlt_200,
    required this.grey_300,
    required this.grey_400,
    required this.grey_500,
    required this.greyAlt_500,
    required this.grey_600,
    required this.greyAlt_600,
    required this.grey_700,
    required this.grey_800,
    required this.grey_900,
    required this.indigo_50,
    required this.indigo_700,
    required this.indigo_900,
    required this.lightBlue_100,
    required this.lightBlue_200,
    required this.lightBlue_300,
    required this.primary_25,
    required this.primaryAlt_25,
    required this.primary_50,
    required this.primary_100,
    required this.primary_200,
    required this.primary_300,
    required this.primary_400,
    required this.primary_500,
    required this.primaryAlt_500,
    required this.primary_600,
    required this.primary_700,
    required this.primary_800,
    required this.primaryAlt_800,
    required this.primaryAltBtn_800,
    required this.primaryAltGuideBtn_800,
    required this.primaryAltSwitchBtn_800,
    required this.primary_900,
    required this.primaryAlt_900,
    required this.secondary_25,
    required this.secondary_50,
    required this.secondary_100,
    required this.secondary_200,
    required this.secondary_300,
    required this.secondary_400,
    required this.secondary_500,
    required this.secondary_600,
    required this.secondaryAlt_600,
    required this.secondaryAltIconBtn_600,
    required this.secondary_700,
    required this.secondary_800,
    required this.secondary_900,
    required this.shadow,
    required this.success_50,
    required this.success_300,
    required this.success_400,
    required this.success_700,
    required this.warning_50,
    required this.warning_400,
    required this.warning_700,
    required this.blue,
    required this.hyperLink,
    required this.unlimited,
  });

  //#region Variables
  final Color? baseBlack;
  final Color? baseWhite;
  final Color? baseNavy;
  final Color? error_50;
  final Color? error_300;
  final Color? error_500;
  final Color? grey_1;
  final Color? grey_25;
  final Color? grey_50;
  final Color? grey_100;
  final Color? grey_200;
  final Color? greyAlt_200;
  final Color? grey_300;
  final Color? grey_400;
  final Color? grey_500;
  final Color? greyAlt_500;
  final Color? grey_600;
  final Color? greyAlt_600;
  final Color? grey_700;
  final Color? grey_800;
  final Color? grey_900;
  final Color? indigo_50;
  final Color? indigo_700;
  final Color? indigo_900;
  final Color? lightBlue_100;
  final Color? lightBlue_200;
  final Color? lightBlue_300;
  final Color? primary_25;
  final Color? primaryAlt_25;
  final Color? primary_50;
  final Color? primary_100;
  final Color? primary_200;
  final Color? primary_300;
  final Color? primary_400;
  final Color? primary_500;
  final Color? primaryAlt_500;
  final Color? primary_600;
  final Color? primary_700;
  final Color? primary_800;
  final Color? primaryAlt_800;
  final Color? primaryAltBtn_800;
  final Color? primaryAltGuideBtn_800;
  final Color? primaryAltSwitchBtn_800;
  final Color? primary_900;
  final Color? primaryAlt_900;
  final Color? secondary_25;
  final Color? secondary_50;
  final Color? secondary_100;
  final Color? secondary_200;
  final Color? secondary_300;
  final Color? secondary_400;
  final Color? secondary_500;
  final Color? secondary_600;
  final Color? secondaryAlt_600;
  final Color? secondaryAltIconBtn_600;
  final Color? secondary_700;
  final Color? secondary_800;
  final Color? secondary_900;
  final Color? shadow;
  final Color? success_50;
  final Color? success_300;
  final Color? success_400;
  final Color? success_700;
  final Color? warning_50;
  final Color? warning_400;
  final Color? warning_700;
  final Color? blue;
  final Color? hyperLink;
  final Color? unlimited;

  static AppColors get lightThemeColors => AppColors(
        baseBlack: templateAppColors.defBaseBlack,
        baseWhite: templateAppColors.defBaseWhite,
        baseNavy: templateAppColors.defBaseNavy,
        error_50: templateAppColors.defError_50,
        error_300: templateAppColors.defError_300,
        error_500: templateAppColors.defError_500,
        grey_1: templateAppColors.defGrey_1,
        grey_25: templateAppColors.defGrey_25,
        grey_50: templateAppColors.defGrey_50,
        grey_100: templateAppColors.defGrey_100,
        grey_200: templateAppColors.defGrey_200,
        greyAlt_200: templateAppColors.defGreyAlt_200,
        grey_300: templateAppColors.defGrey_300,
        grey_400: templateAppColors.defGrey_400,
        grey_500: templateAppColors.defGrey_500,
        greyAlt_500: templateAppColors.defGreyAlt_500,
        grey_600: templateAppColors.defGrey_600,
        greyAlt_600: templateAppColors.defGreyAlt_600,
        grey_700: templateAppColors.defGrey_700,
        grey_800: templateAppColors.defGrey_800,
        grey_900: templateAppColors.defGrey_900,
        indigo_50: templateAppColors.defIndigo_50,
        indigo_700: templateAppColors.defIndigo_700,
        indigo_900: templateAppColors.defIndigo_900,
        lightBlue_100: templateAppColors.defLightBlue_100,
        lightBlue_200: templateAppColors.defLightBlue_200,
        lightBlue_300: templateAppColors.defLightBlue_300,
        primary_25: templateAppColors.defPrimary_25,
        primaryAlt_25: templateAppColors.defPrimaryAlt_25,
        primary_50: templateAppColors.defPrimary_50,
        primary_100: templateAppColors.defPrimary_100,
        primary_200: templateAppColors.defPrimary_200,
        primary_300: templateAppColors.defPrimary_300,
        primary_400: templateAppColors.defPrimary_400,
        primary_500: templateAppColors.defPrimary_500,
        primaryAlt_500: templateAppColors.defPrimaryAlt_500,
        primary_600: templateAppColors.defPrimary_600,
        primary_700: templateAppColors.defPrimary_700,
        primary_800: templateAppColors.defPrimary_800,
        primaryAlt_800: templateAppColors.defPrimaryAlt_800,
        primaryAltBtn_800: templateAppColors.defPrimaryAltBtn_800,
        primaryAltGuideBtn_800: templateAppColors.defPrimaryAltGuideBtn_800,
        primaryAltSwitchBtn_800: templateAppColors.defPrimaryAltSwitchBtn_800,
        primary_900: templateAppColors.defPrimary_900,
        primaryAlt_900: templateAppColors.defPrimaryAlt_900,
        secondary_25: templateAppColors.defSecondary_25,
        secondary_50: templateAppColors.defSecondary_50,
        secondary_100: templateAppColors.defSecondary_100,
        secondary_200: templateAppColors.defSecondary_200,
        secondary_300: templateAppColors.defSecondary_300,
        secondary_400: templateAppColors.defSecondary_400,
        secondary_500: templateAppColors.defSecondary_500,
        secondary_600: templateAppColors.defSecondary_600,
        secondaryAlt_600: templateAppColors.defSecondaryAlt_600,
        secondaryAltIconBtn_600: templateAppColors.defSecondaryAltIconBtn_600,
        secondary_700: templateAppColors.defSecondary_700,
        secondary_800: templateAppColors.defSecondary_800,
        secondary_900: templateAppColors.defSecondary_900,
        shadow: templateAppColors.defShadow,
        success_50: templateAppColors.defSuccess_50,
        success_300: templateAppColors.defSuccess_300,
        success_400: templateAppColors.defSuccess_400,
        success_700: templateAppColors.defSuccess_700,
        warning_50: templateAppColors.defWarning_50,
        warning_400: templateAppColors.defWarning_400,
        warning_700: templateAppColors.defWarning_700,
        blue: templateAppColors.defBlue,
        hyperLink: templateAppColors.defHyperLink,
        unlimited: templateAppColors.defUnlimited,
      );

  static AppColors get darkThemeColors => AppColors(
        baseBlack: templateAppColors.defBaseBlack,
        baseWhite: templateAppColors.defBaseWhite,
        baseNavy: templateAppColors.defBaseNavy,
        error_50: templateAppColors.defError_50,
        error_300: templateAppColors.defError_300,
        error_500: templateAppColors.defError_500,
        grey_1: templateAppColors.defGrey_1,
        grey_25: templateAppColors.defGrey_25,
        grey_50: templateAppColors.defGrey_50,
        grey_100: templateAppColors.defGrey_100,
        grey_200: templateAppColors.defGrey_200,
        greyAlt_200: templateAppColors.defGreyAlt_200,
        grey_300: templateAppColors.defGrey_300,
        grey_400: templateAppColors.defGrey_400,
        grey_500: templateAppColors.defGrey_500,
        greyAlt_500: templateAppColors.defGreyAlt_500,
        grey_600: templateAppColors.defGrey_600,
        greyAlt_600: templateAppColors.defGreyAlt_600,
        grey_700: templateAppColors.defGrey_700,
        grey_800: templateAppColors.defGrey_800,
        grey_900: templateAppColors.defGrey_900,
        indigo_50: templateAppColors.defIndigo_50,
        indigo_700: templateAppColors.defIndigo_700,
        indigo_900: templateAppColors.defIndigo_900,
        lightBlue_100: templateAppColors.defLightBlue_100,
        lightBlue_200: templateAppColors.defLightBlue_200,
        lightBlue_300: templateAppColors.defLightBlue_300,
        primary_25: templateAppColors.defPrimary_25,
        primaryAlt_25: templateAppColors.defPrimaryAlt_25,
        primary_50: templateAppColors.defPrimary_50,
        primary_100: templateAppColors.defPrimary_100,
        primary_200: templateAppColors.defPrimary_200,
        primary_300: templateAppColors.defPrimary_300,
        primary_400: templateAppColors.defPrimary_400,
        primary_500: templateAppColors.defPrimary_500,
        primaryAlt_500: templateAppColors.defPrimaryAlt_500,
        primary_600: templateAppColors.defPrimary_600,
        primary_700: templateAppColors.defPrimary_700,
        primary_800: templateAppColors.defPrimary_800,
        primaryAlt_800: templateAppColors.defPrimaryAlt_800,
        primaryAltBtn_800: templateAppColors.defPrimaryAltBtn_800,
        primaryAltGuideBtn_800: templateAppColors.defPrimaryAltGuideBtn_800,
        primaryAltSwitchBtn_800: templateAppColors.defPrimaryAltSwitchBtn_800,
        primary_900: templateAppColors.defPrimary_900,
        primaryAlt_900: templateAppColors.defPrimaryAlt_900,
        secondary_25: templateAppColors.defSecondary_25,
        secondary_50: templateAppColors.defSecondary_50,
        secondary_100: templateAppColors.defSecondary_100,
        secondary_200: templateAppColors.defSecondary_200,
        secondary_300: templateAppColors.defSecondary_300,
        secondary_400: templateAppColors.defSecondary_400,
        secondary_500: templateAppColors.defSecondary_500,
        secondary_600: templateAppColors.defSecondary_600,
        secondaryAlt_600: templateAppColors.defSecondaryAlt_600,
        secondaryAltIconBtn_600: templateAppColors.defSecondaryAltIconBtn_600,
        secondary_700: templateAppColors.defSecondary_700,
        secondary_800: templateAppColors.defSecondary_800,
        secondary_900: templateAppColors.defSecondary_900,
        shadow: templateAppColors.defShadow,
        success_50: templateAppColors.defSuccess_50,
        success_300: templateAppColors.defSuccess_300,
        success_400: templateAppColors.defSuccess_400,
        success_700: templateAppColors.defSuccess_700,
        warning_50: templateAppColors.defWarning_50,
        warning_400: templateAppColors.defWarning_400,
        warning_700: templateAppColors.defWarning_700,
        blue: templateAppColors.defBlue,
        hyperLink: templateAppColors.defHyperLink,
        unlimited: templateAppColors.defUnlimited,
      );

  @override
  ThemeExtension<AppColors> copyWith() {
    return AppColors(
      baseBlack: templateAppColors.defBaseBlack,
      baseWhite: templateAppColors.defBaseWhite,
      baseNavy: templateAppColors.defBaseNavy,
      error_50: templateAppColors.defError_50,
      error_300: templateAppColors.defError_300,
      error_500: templateAppColors.defError_500,
      grey_1: templateAppColors.defGrey_1,
      grey_25: templateAppColors.defGrey_25,
      grey_50: templateAppColors.defGrey_50,
      grey_100: templateAppColors.defGrey_100,
      grey_200: templateAppColors.defGrey_200,
      greyAlt_200: templateAppColors.defGreyAlt_200,
      grey_300: templateAppColors.defGrey_300,
      grey_400: templateAppColors.defGrey_400,
      grey_500: templateAppColors.defGrey_500,
      greyAlt_500: templateAppColors.defGreyAlt_500,
      grey_600: templateAppColors.defGrey_600,
      greyAlt_600: templateAppColors.defGreyAlt_600,
      grey_700: templateAppColors.defGrey_700,
      grey_800: templateAppColors.defGrey_800,
      grey_900: templateAppColors.defGrey_900,
      indigo_50: templateAppColors.defIndigo_50,
      indigo_700: templateAppColors.defIndigo_700,
      indigo_900: templateAppColors.defIndigo_900,
      lightBlue_100: templateAppColors.defLightBlue_100,
      lightBlue_200: templateAppColors.defLightBlue_200,
      lightBlue_300: templateAppColors.defLightBlue_300,
      primary_25: templateAppColors.defPrimary_25,
      primaryAlt_25: templateAppColors.defPrimaryAlt_25,
      primary_50: templateAppColors.defPrimary_50,
      primary_100: templateAppColors.defPrimary_100,
      primary_200: templateAppColors.defPrimary_200,
      primary_300: templateAppColors.defPrimary_300,
      primary_400: templateAppColors.defPrimary_400,
      primary_500: templateAppColors.defPrimary_500,
      primaryAlt_500: templateAppColors.defPrimaryAlt_500,
      primary_600: templateAppColors.defPrimary_600,
      primary_700: templateAppColors.defPrimary_700,
      primary_800: templateAppColors.defPrimary_800,
      primaryAlt_800: templateAppColors.defPrimaryAlt_800,
      primaryAltBtn_800: templateAppColors.defPrimaryAltBtn_800,
      primaryAltGuideBtn_800: templateAppColors.defPrimaryAltGuideBtn_800,
      primaryAltSwitchBtn_800: templateAppColors.defPrimaryAltSwitchBtn_800,
      primary_900: templateAppColors.defPrimary_900,
      primaryAlt_900: templateAppColors.defPrimaryAlt_900,
      secondary_25: templateAppColors.defSecondary_25,
      secondary_50: templateAppColors.defSecondary_50,
      secondary_100: templateAppColors.defSecondary_100,
      secondary_200: templateAppColors.defSecondary_200,
      secondary_300: templateAppColors.defSecondary_300,
      secondary_400: templateAppColors.defSecondary_400,
      secondary_500: templateAppColors.defSecondary_500,
      secondary_600: templateAppColors.defSecondary_600,
      secondaryAlt_600: templateAppColors.defSecondaryAlt_600,
      secondaryAltIconBtn_600: templateAppColors.defSecondaryAltIconBtn_600,
      secondary_700: templateAppColors.defSecondary_700,
      secondary_800: templateAppColors.defSecondary_800,
      secondary_900: templateAppColors.defSecondary_900,
      shadow: templateAppColors.defShadow,
      success_50: templateAppColors.defSuccess_50,
      success_300: templateAppColors.defSuccess_300,
      success_400: templateAppColors.defSuccess_400,
      success_700: templateAppColors.defSuccess_700,
      warning_50: templateAppColors.defWarning_50,
      warning_400: templateAppColors.defWarning_400,
      warning_700: templateAppColors.defWarning_700,
      blue: templateAppColors.defBlue,
      hyperLink: templateAppColors.defHyperLink,
      unlimited: templateAppColors.defUnlimited,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      baseBlack: Color.lerp(baseBlack, other.baseBlack, t),
      baseWhite: Color.lerp(baseWhite, other.baseWhite, t),
      baseNavy: Color.lerp(baseNavy, other.baseNavy, t),
      error_50: templateAppColors.defError_50,
      error_300: templateAppColors.defError_300,
      error_500: templateAppColors.defError_500,
      grey_1: templateAppColors.defGrey_1,
      grey_25: templateAppColors.defGrey_25,
      grey_50: templateAppColors.defGrey_50,
      grey_100: templateAppColors.defGrey_100,
      grey_200: templateAppColors.defGrey_200,
      greyAlt_200: templateAppColors.defGreyAlt_200,
      grey_300: templateAppColors.defGrey_300,
      grey_400: templateAppColors.defGrey_400,
      grey_500: templateAppColors.defGrey_500,
      greyAlt_500: templateAppColors.defGreyAlt_500,
      grey_600: templateAppColors.defGrey_600,
      greyAlt_600: templateAppColors.defGreyAlt_600,
      grey_700: templateAppColors.defGrey_700,
      grey_800: templateAppColors.defGrey_800,
      grey_900: templateAppColors.defGrey_900,
      indigo_50: templateAppColors.defIndigo_50,
      indigo_700: templateAppColors.defIndigo_700,
      indigo_900: templateAppColors.defIndigo_900,
      lightBlue_100: templateAppColors.defLightBlue_100,
      lightBlue_200: templateAppColors.defLightBlue_200,
      lightBlue_300: templateAppColors.defLightBlue_300,
      primary_25: templateAppColors.defPrimary_25,
      primaryAlt_25: templateAppColors.defPrimaryAlt_25,
      primary_50: templateAppColors.defPrimary_50,
      primary_100: templateAppColors.defPrimary_100,
      primary_200: templateAppColors.defPrimary_200,
      primary_300: templateAppColors.defPrimary_300,
      primary_400: templateAppColors.defPrimary_400,
      primary_500: templateAppColors.defPrimary_500,
      primaryAlt_500: templateAppColors.defPrimaryAlt_500,
      primary_600: templateAppColors.defPrimary_600,
      primary_700: templateAppColors.defPrimary_700,
      primary_800: templateAppColors.defPrimary_800,
      primaryAlt_800: templateAppColors.defPrimaryAlt_800,
      primaryAltBtn_800: templateAppColors.defPrimaryAltBtn_800,
      primaryAltGuideBtn_800: templateAppColors.defPrimaryAltGuideBtn_800,
      primaryAltSwitchBtn_800: templateAppColors.defPrimaryAltSwitchBtn_800,
      primary_900: templateAppColors.defPrimary_900,
      primaryAlt_900: templateAppColors.defPrimaryAlt_900,
      secondary_25: templateAppColors.defSecondary_25,
      secondary_50: templateAppColors.defSecondary_50,
      secondary_100: templateAppColors.defSecondary_100,
      secondary_200: templateAppColors.defSecondary_200,
      secondary_300: templateAppColors.defSecondary_300,
      secondary_400: templateAppColors.defSecondary_400,
      secondary_500: templateAppColors.defSecondary_500,
      secondary_600: templateAppColors.defSecondary_600,
      secondaryAlt_600: templateAppColors.defSecondaryAlt_600,
      secondaryAltIconBtn_600: templateAppColors.defSecondaryAltIconBtn_600,
      secondary_700: templateAppColors.defSecondary_700,
      secondary_800: templateAppColors.defSecondary_800,
      secondary_900: templateAppColors.defSecondary_900,
      shadow: templateAppColors.defShadow,
      success_50: templateAppColors.defSuccess_50,
      success_300: templateAppColors.defSuccess_300,
      success_400: templateAppColors.defSuccess_400,
      success_700: templateAppColors.defSuccess_700,
      warning_50: templateAppColors.defWarning_50,
      warning_400: templateAppColors.defWarning_400,
      warning_700: templateAppColors.defWarning_700,
      blue: templateAppColors.defBlue,
      hyperLink: templateAppColors.defHyperLink,
      unlimited: templateAppColors.defUnlimited,
    );
  }
//#endregion
}

// checking brightness to support dynamic theming
extension CustomColorSchemeX on ColorScheme {
  Color? get smallBoxColor1 =>
      brightness == Brightness.light ? Colors.blue : Colors.grey[400];

  Color cPrimaryColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.primaryColor);

  Color cBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.background);

  Color cForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.foreground);

  Color cCardBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.cardBackground);

  Color cCardForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.cardForeground);

  Color cToolbarBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.toolbarBackground);

  Color cToolbarForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.toolbarForeground);

  Color cBottomNavBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.bottomNavBackground);

  Color cBottomNavSelectedColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.bottomNavSelected);

  Color cBottomNavUnselectedColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.bottomNavUnselected);

  Color cButtonEnabledBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.buttonEnabledBackground);

  Color cButtonDisabledBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.buttonDisabledBackground);

  Color cButtonEnabledForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.buttonEnabledForeground);

  Color cButtonDisabledForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.buttonDisabledForeground);

  Color cHintTextColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.hintTextColor);

  Color cInputBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.inputBackground);

  Color cInputForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.inputForeground);

  Color cInputIconColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.inputIconColor);

  Color cOptionSelectedColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.optionSelected);

  Color cOptionUnselectedColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.optionUnselected);

  Color cDialogBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.dialogBackground);

  Color cDialogForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.dialogForeground);

  Color cDialogButtonEnabledBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.dialogButtonEnabledBackground);

  Color cDialogButtonDisabledBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.dialogButtonDisabledBackground);

  Color cDialogButtonEnabledForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.dialogButtonDisabledForeground);

  Color cDialogButtonDisabledForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.dialogButtonEnabledForeground);

  Color cSheetBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.sheetBackground);

  Color cSheetForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.sheetForeground);

  Color cSheetButtonEnabledBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.sheetButtonEnabledBackground);

  Color cSheetButtonDisabledBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.sheetButtonDisabledBackground);

  Color cSheetButtonEnabledForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.sheetButtonDisabledForeground);

  Color cSheetButtonDisabledForeground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.sheetButtonEnabledForeground);

  Color cError(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.error);

  Color cErrorLight(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.errorLight);

  Color cThumbColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.thumbColor);

  Color cHelpDividerColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.helpDividerColor);

  Color cNavigationActionsColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.navigationActionsColor);

  Color cNavigationBarTitleColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.navigationBarTitleColor);

  Color cNavigationBarBackground(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.navigationBarBackground);

  Color cProgressBarColor(BuildContext context) =>
      getColorForKey(context, ThemeColorsTag.progressBarColor);

  Color getColorForKey(BuildContext context, ThemeColorsTag tag) {
    AppColors color = Theme.of(context).extension<AppColors>()!;
    return color.baseWhite!;
  }
}

enum ThemeColorsTag {
  primaryColor,
  background,
  foreground,
  cardBackground,
  cardForeground,
  toolbarBackground,
  toolbarForeground,
  bottomNavBackground,
  bottomNavSelected,
  bottomNavUnselected,
  buttonEnabledBackground,
  buttonDisabledBackground,
  buttonEnabledForeground,
  buttonDisabledForeground,
  hintTextColor,
  inputBackground,
  inputForeground,
  inputIconColor,
  dialogBackground,
  dialogForeground,
  dialogButtonEnabledBackground,
  dialogButtonDisabledBackground,
  dialogButtonEnabledForeground,
  dialogButtonDisabledForeground,
  sheetBackground,
  sheetForeground,
  sheetButtonEnabledBackground,
  sheetButtonDisabledBackground,
  sheetButtonEnabledForeground,
  sheetButtonDisabledForeground,
  optionSelected,
  optionUnselected,
  error,
  errorLight,
  thumbColor,
  progressBarColor,
  helpDividerColor,
  navigationActionsColor,
  navigationBarTitleColor,
  navigationBarBackground,
}
