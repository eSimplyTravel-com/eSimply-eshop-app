import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MainButtonParams {
  MainButtonParams({
    required this.title,
    required this.onPressed,
    required this.themeColor,
    this.key,
    this.isEnabled = true,
    this.enabledBackgroundColor = Colors.white,
    this.disabledBackgroundColor = Colors.transparent,
    this.enabledTextColor,
    this.disabledTextColor,
    this.borderColor,
    this.width,
    this.height,
    this.hideShadows,
    this.containerPadding,
    this.titleTextStyle,
  });
  final String title;
  final VoidCallback onPressed;
  final Color themeColor;
  final Key? key;
  final bool isEnabled;
  final Color? enabledBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final bool? hideShadows;
  final EdgeInsets? containerPadding;
  final TextStyle? titleTextStyle;
}

class BannerButtonParams {
  BannerButtonParams({
    required this.title,
    required this.action,
    required this.themeColor,
    required this.textColor,
    required this.buttonColor,
    required this.titleTextStyle,
    this.height = 38,
    this.titleHorizontalPadding = 20,
    this.hideShadows = true,
  });
  final String title;
  final VoidCallback action;
  final Color themeColor;
  final Color? textColor;
  final Color? buttonColor;
  final TextStyle titleTextStyle;
  final double height;
  final double titleHorizontalPadding;
  final bool hideShadows;
}

class MainButton extends StatelessWidget {
  const MainButton({
    required this.title,
    required this.onPressed,
    required this.themeColor,
    super.key,
    this.isEnabled = true,
    this.width,
    this.height = 50,
    this.enabledBackgroundColor,
    this.disabledBackgroundColor,
    this.enabledTextColor,
    this.disabledTextColor,
    this.titleTextStyle,
    this.borderRadius,
    this.borderColor,
    this.leadingWidget,
    this.containerPadding = EdgeInsets.zero,
    this.hideShadows,
    this.textAlignment,
    this.trailingWidget,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.rowMainAxisSize,
    this.titleHorizontalPadding = 0,
  });
  final String title;
  final bool isEnabled;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color? enabledBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final TextStyle? titleTextStyle;
  final double? borderRadius;
  final Color themeColor;
  final Color? borderColor;
  final Widget? leadingWidget;
  final EdgeInsets containerPadding;
  final bool? hideShadows;
  final MainAxisAlignment? textAlignment;
  final Widget? trailingWidget;
  final double verticalPadding;
  final double horizontalPadding;
  final MainAxisSize? rowMainAxisSize;
  final double titleHorizontalPadding;

  static MainButton onlyText({
    required MainButtonParams params,
  }) {
    return MainButton(
      title: params.title,
      onPressed: params.onPressed,
      themeColor: params.themeColor,
      isEnabled: params.isEnabled,
      titleTextStyle: params.titleTextStyle,
      enabledBackgroundColor: params.enabledBackgroundColor,
      disabledBackgroundColor: params.disabledBackgroundColor,
      enabledTextColor: params.enabledTextColor ?? params.themeColor,
      disabledTextColor: params.disabledTextColor ?? params.themeColor,
      borderColor: params.borderColor ?? Colors.transparent,
      containerPadding: params.containerPadding ?? EdgeInsets.zero,
      width: params.width ?? double.infinity,
      hideShadows: params.hideShadows ?? true,
    );
  }

  static MainButton emptyBackground({
    required MainButtonParams params,
  }) {
    return MainButton(
      title: params.title,
      onPressed: params.onPressed,
      themeColor: params.themeColor,
      isEnabled: params.isEnabled,
      enabledBackgroundColor: params.enabledBackgroundColor,
      disabledBackgroundColor: params.disabledBackgroundColor,
      enabledTextColor: params.enabledTextColor ?? params.themeColor,
      disabledTextColor: params.disabledTextColor ?? params.themeColor,
      borderColor: params.borderColor ?? params.themeColor,
      containerPadding: params.containerPadding ?? EdgeInsets.zero,
      width: params.width ?? double.infinity,
      hideShadows: params.hideShadows,
      height: params.height ?? 50,
      titleTextStyle: params.titleTextStyle,
    );
  }

  static MainButton continueWith({
    required MainButtonParams params,
    required VoidCallback action,
    required Color buttonColor,
    required Color textColor,
    required String image,
    double leadingImageWidth = 25,
    double leadingImageHeight = 25,
  }) {
    return MainButton(
      title: params.title,
      borderRadius: 25,
      hideShadows: true,
      onPressed: action,
      themeColor: params.themeColor,
      enabledBackgroundColor: buttonColor,
      enabledTextColor: textColor,
      height: 53,
      leadingWidget: Image.asset(
        image,
        width: leadingImageWidth,
        height: leadingImageHeight,
      ),
      horizontalPadding: 20,
      textAlignment: MainAxisAlignment.spaceBetween,
      titleTextStyle: params.titleTextStyle,
      containerPadding: params.containerPadding ?? EdgeInsets.zero,
    );
  }

  static MainButton bannerButton({
    required BannerButtonParams params,
  }) {
    return MainButton(
      height: params.height,
      title: params.title,
      onPressed: params.action,
      themeColor: params.themeColor,
      hideShadows: params.hideShadows,
      enabledTextColor: params.textColor,
      enabledBackgroundColor: params.buttonColor,
      titleTextStyle: params.titleTextStyle,
      rowMainAxisSize: MainAxisSize.min,
      titleHorizontalPadding: params.titleHorizontalPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: containerPadding,
      child: GestureDetector(
        onTap: isEnabled
            ? () {
                playHapticFeedback(HapticFeedbackType.mainButtonTapped);
                onPressed();
              }
            : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              borderRadius ??
                  AppEnvironment.appEnvironmentHelper.environmentCornerRadius,
            ),
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
            color: isEnabled
                ? (enabledBackgroundColor ??
                    enabledMainButtonColor(context: context))
                : (disabledBackgroundColor ??
                    disabledMainButtonColor(context: context)),
            boxShadow: (hideShadows ?? false)
                ? null
                : <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .cHintTextColor(context)
                          .withAlpha(20),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .cHintTextColor(context)
                          .withAlpha(20),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: const Offset(0, -1),
                    ),
                  ],
          ),
          height: height,
          width: width,
          child: PaddingWidget.applySymmetricPadding(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
            child: Row(
              mainAxisAlignment: textAlignment ?? MainAxisAlignment.center,
              mainAxisSize: rowMainAxisSize ?? MainAxisSize.max,
              children: <Widget>[
                leadingWidget ?? Container(),
                PaddingWidget.applySymmetricPadding(
                  horizontal: titleHorizontalPadding,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: titleTextStyle?.copyWith(
                          color: isEnabled
                              ? (enabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context))
                              : (disabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context)),
                        ) ??
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEnabled
                              ? (enabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context))
                              : (disabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context)),
                        ),
                  ),
                ),
                trailingWidget ?? Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("title", title))
      ..add(DiagnosticsProperty<bool>("isEnabled", isEnabled))
      ..add(ObjectFlagProperty<VoidCallback>.has("onPressed", onPressed))
      ..add(DoubleProperty("width", width))
      ..add(DoubleProperty("height", height))
      ..add(ColorProperty("enabledBackgroundColor", enabledBackgroundColor))
      ..add(ColorProperty("disabledBackgroundColor", disabledBackgroundColor))
      ..add(ColorProperty("enabledTextColor", enabledTextColor))
      ..add(ColorProperty("disabledTextColor", disabledTextColor))
      ..add(DiagnosticsProperty<TextStyle?>("titleTextStyle", titleTextStyle))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(ColorProperty("themeColor", themeColor))
      ..add(ColorProperty("borderColor", borderColor))
      ..add(
        DiagnosticsProperty<EdgeInsets>("containerPadding", containerPadding),
      )
      ..add(DiagnosticsProperty<bool?>("hideShadows", hideShadows))
      ..add(EnumProperty<MainAxisAlignment?>("textAlignment", textAlignment))
      ..add(DoubleProperty("verticalPadding", verticalPadding))
      ..add(DoubleProperty("horizontalPadding", horizontalPadding))
      ..add(EnumProperty<MainAxisSize?>("rowMainAxisSize", rowMainAxisSize))
      ..add(DoubleProperty("titleHorizontalPadding", titleHorizontalPadding));
  }
}

@AppPreview(name: "Main Button")
Widget mainButtonPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: MainButton(
        title: "Continue",
        onPressed: () {},
        themeColor: Colors.blue,
      ),
    ),
  );
}
