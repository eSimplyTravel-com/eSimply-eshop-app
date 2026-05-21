import "package:easy_localization/easy_localization.dart" as lc;
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class MainInputField extends StatefulWidget {
  const MainInputField({
    required this.controller,
    required this.themeColor,
    super.key,
    this.backgroundColor,
    this.borderRadius = 12,
    this.cursorColor,
    this.initialValue,
    this.maxLength,
    this.leadingIcon,
    this.inputBorder,
    this.hintText,
    this.labelText,
    this.helperText,
    this.labelStyle,
    this.suffixIcon,
    this.prefixIcon,
    this.focusColor,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.textInputType,
    this.password = false,
    this.isReadOnly = false,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.onChanged,
    this.formatter,
    this.enterPressed,
    this.forceSuffixDirection = false,
    this.autofillHints,
    this.autofocus = false,
    this.isObscure,
    this.onObscureChange,
    this.hideInternalObfuscator = false,
    this.prefixText,
    this.prefixStyle,
    this.removeBorder = false,
    this.inputTextStyle,
    this.textAlign,
    this.maxLines = 1,
    this.labelTitleText,
    this.errorIcon,
    this.errorMessage,
    this.errorBorderColor,
    this.textFieldHeight = 55,
    this.hintTextStyle,
    this.onTap,
    this.clearSearchEnabled = false,
  });

  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool password;
  final bool? isObscure;
  final bool isReadOnly;
  final bool hideInternalObfuscator;
  final bool clearSearchEnabled;

  // final String placeholder;
  // final String? validationMessage;
  final void Function()? enterPressed;

  // final bool smallVersion;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;

  // final String? additionalNote;
  final VoidCallback? onTap;
  final void Function({required String text})? onChanged;
  final void Function({required bool value})? onObscureChange;
  final TextInputFormatter? formatter;
  final Color themeColor;
  final Color? backgroundColor;
  final Color? cursorColor;
  final Color? focusColor;
  final double borderRadius;
  final String? initialValue;
  final int? maxLength;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputBorder? inputBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? prefixText;
  final TextStyle? labelStyle;
  final TextStyle? prefixStyle;
  final bool forceSuffixDirection;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final bool removeBorder;
  final TextStyle? inputTextStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final String? labelTitleText;
  final String? errorMessage;
  final Color? errorBorderColor;
  final IconData? errorIcon;
  final double textFieldHeight;
  final TextStyle? hintTextStyle;

  static MainInputField securedPassword({
    required TextEditingController controller,
    required Color themeColor,
    MainInputFieldTextConfig? textConfig,
    MainInputFieldAppearanceConfig? appearanceConfig,
    MainInputFieldBehaviorConfig? behaviorConfig,
    MainInputFieldInputConfig? inputConfig,
    MainInputFieldInteractionConfig? interactionConfig,
  }) {
    return MainInputField(
      controller: controller,
      hintText: LocaleKeys.password.tr(),
      password: true,
      isReadOnly: behaviorConfig?.isReadOnly ?? false,
      themeColor: themeColor,
      autofocus: behaviorConfig?.autofocus ?? false,
      isObscure: behaviorConfig?.isObscure,
      onObscureChange: interactionConfig?.onObscureChange,
      hideInternalObfuscator: behaviorConfig?.hideInternalObfuscator ?? false,
      initialValue: textConfig?.initialValue,
      enterPressed: interactionConfig?.enterPressed,
      formatter: inputConfig?.formatter,
      autofillHints: inputConfig?.autofillHints,
      textInputType: inputConfig?.textInputType,
      removeBorder: behaviorConfig?.removeBorder ?? false,
      inputTextStyle: appearanceConfig?.inputTextStyle,
      textAlign: inputConfig?.textAlign,
      labelText: textConfig?.labelText,
      labelStyle: appearanceConfig?.labelStyle,
    );
  }

  static MainInputField text({
    required TextEditingController controller,
    required Color themeColor,
    MainInputFieldTextConfig? textConfig,
    MainInputFieldAppearanceConfig? appearanceConfig,
    MainInputFieldBehaviorConfig? behaviorConfig,
    MainInputFieldInputConfig? inputConfig,
    MainInputFieldInteractionConfig? interactionConfig,
  }) {
    return MainInputField(
      autofocus: behaviorConfig?.autofocus ?? false,
      controller: controller,
      textInputType: inputConfig?.textInputType,
      hintText: textConfig?.hintText,
      isReadOnly: behaviorConfig?.isReadOnly ?? false,
      initialValue: textConfig?.initialValue,
      enterPressed: interactionConfig?.enterPressed,
      formatter: inputConfig?.formatter,
      themeColor: themeColor,
      autofillHints: inputConfig?.autofillHints,
      removeBorder: behaviorConfig?.removeBorder ?? false,
      inputTextStyle: appearanceConfig?.inputTextStyle,
      textAlign: inputConfig?.textAlign,
      labelText: textConfig?.labelText,
      labelStyle: appearanceConfig?.labelStyle,
    );
  }

  static MainInputField multiline({
    required TextEditingController controller,
    required Color themeColor,
    MainInputFieldTextConfig? textConfig,
    MainInputFieldAppearanceConfig? appearanceConfig,
    MainInputFieldBehaviorConfig? behaviorConfig,
    MainInputFieldInputConfig? inputConfig,
    MainInputFieldInteractionConfig? interactionConfig,
  }) {
    return MainInputField(
      autofocus: behaviorConfig?.autofocus ?? false,
      controller: controller,
      textInputType: inputConfig?.textInputType ?? TextInputType.multiline,
      hintText: textConfig?.hintText,
      isReadOnly: behaviorConfig?.isReadOnly ?? false,
      initialValue: textConfig?.initialValue,
      enterPressed: interactionConfig?.enterPressed,
      formatter: inputConfig?.formatter,
      themeColor: themeColor,
      autofillHints: inputConfig?.autofillHints,
      removeBorder: behaviorConfig?.removeBorder ?? false,
      inputTextStyle: appearanceConfig?.inputTextStyle,
      textAlign: inputConfig?.textAlign,
      maxLines: inputConfig?.maxLines,
    );
  }

  static MainInputField formField({
    required TextEditingController controller,
    required Color themeColor,
    MainInputFieldTextConfig? textConfig,
    MainInputFieldAppearanceConfig? appearanceConfig,
    MainInputFieldInputConfig? inputConfig,
  }) =>
      MainInputField(
        themeColor: themeColor,
        labelTitleText: textConfig?.labelTitleText,
        hintText: textConfig?.hintText,
        controller: controller,
        backgroundColor: appearanceConfig?.backgroundColor,
        errorMessage: textConfig?.errorMessage,
        labelStyle: appearanceConfig?.labelStyle,
        enterPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        textInputType: inputConfig?.textInputType,
        hintTextStyle: appearanceConfig?.hintTextStyle,
        maxLines: inputConfig?.maxLines ?? 1,
        textFieldHeight: appearanceConfig?.textFieldHeight ?? 55,
      );

  static MainInputField promoCode({
    required TextEditingController controller,
    required Color themeColor,
    MainInputFieldTextConfig? textConfig,
    MainInputFieldAppearanceConfig? appearanceConfig,
    MainInputFieldBehaviorConfig? behaviorConfig,
    MainInputFieldInputConfig? inputConfig,
    MainInputFieldInteractionConfig? interactionConfig,
  }) =>
      MainInputField(
        isReadOnly: behaviorConfig?.isReadOnly ?? false,
        themeColor: themeColor,
        hintText: textConfig?.hintText,
        controller: controller,
        backgroundColor: appearanceConfig?.backgroundColor,
        errorMessage: textConfig?.errorMessage,
        errorBorderColor: appearanceConfig?.errorColor,
        errorIcon: appearanceConfig?.errorIcon,
        labelStyle: appearanceConfig?.labelStyle,
        inputTextStyle: appearanceConfig?.labelStyle,
        enterPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: interactionConfig?.onChanged,
        textInputType: inputConfig?.textInputType,
        hintTextStyle: appearanceConfig?.hintTextStyle,
        textFieldHeight: appearanceConfig?.textFieldHeight ?? 45,
      );

  static MainInputField searchField({
    required TextEditingController controller,
    required Color themeColor,
    MainInputFieldTextConfig? textConfig,
    MainInputFieldAppearanceConfig? appearanceConfig,
    MainInputFieldBehaviorConfig? behaviorConfig,
    MainInputFieldInteractionConfig? interactionConfig,
  }) =>
      MainInputField(
        themeColor: themeColor,
        controller: controller,
        backgroundColor: appearanceConfig?.backgroundColor,
        onTap: interactionConfig?.onTap,
        prefixIcon: PaddingWidget.applyPadding(
          end: 10,
          child: Image.asset(
            EnvironmentImages.searchIcon.fullImagePath,
            width: 15,
            height: 15,
          ),
        ),
        hintText: textConfig?.hintText,
        enterPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        labelStyle: appearanceConfig?.labelStyle,
        clearSearchEnabled: behaviorConfig?.clearSearchEnabled ?? false,
        onChanged: interactionConfig?.onChanged,
      );

  @override
  State<MainInputField> createState() => _MainInputFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(
      DiagnosticsProperty<TextEditingController>("controller", controller),
    )..add(DiagnosticsProperty<TextInputType?>(
        "textInputType", textInputType,),)..add(
        DiagnosticsProperty<bool>("password", password),)..add(
        DiagnosticsProperty<bool?>("isObscure", isObscure),)..add(
        DiagnosticsProperty<bool>("isReadOnly", isReadOnly),)..add(
      DiagnosticsProperty<bool>(
        "hideInternalObfuscator",
        hideInternalObfuscator,
      ),
    )..add(
      ObjectFlagProperty<void Function()?>.has(
        "enterPressed",
        enterPressed,
      ),
    )..add(
        DiagnosticsProperty<FocusNode?>("fieldFocusNode", fieldFocusNode),)..add(
        DiagnosticsProperty<FocusNode?>("nextFocusNode", nextFocusNode),)..add(
        EnumProperty<TextInputAction?>(
            "textInputAction", textInputAction,),)..add(
      ObjectFlagProperty<void Function({required String text})?>.has(
        "onChanged",
        onChanged,
      ),
    )..add(
      ObjectFlagProperty<void Function({required bool value})?>.has(
        "onObscureChange",
        onObscureChange,
      ),
    )..add(
        DiagnosticsProperty<TextInputFormatter?>("formatter", formatter),)..add(
        ColorProperty("themeColor", themeColor),)..add(
        ColorProperty("backgroundColor", backgroundColor),)..add(
        ColorProperty("cursorColor", cursorColor),)..add(
        ColorProperty("focusColor", focusColor),)..add(
        DoubleProperty("borderRadius", borderRadius),)..add(
        StringProperty("initialValue", initialValue),)..add(
        IntProperty("maxLength", maxLength),)..add(
        DiagnosticsProperty<InputBorder?>("inputBorder", inputBorder),)..add(
        DiagnosticsProperty<InputBorder?>("enabledBorder", enabledBorder),)..add(
        DiagnosticsProperty<InputBorder?>(
            "disabledBorder", disabledBorder,),)..add(
        DiagnosticsProperty<InputBorder?>("errorBorder", errorBorder),)..add(
        DiagnosticsProperty<InputBorder?>("focusedBorder", focusedBorder),)..add(
      DiagnosticsProperty<InputBorder?>(
        "focusedErrorBorder",
        focusedErrorBorder,
      ),
    )..add(StringProperty("hintText", hintText))..add(
        StringProperty("labelText", labelText),)..add(
        StringProperty("helperText", helperText),)..add(
        StringProperty("prefixText", prefixText),)..add(
        DiagnosticsProperty<TextStyle?>("labelStyle", labelStyle),)..add(
        DiagnosticsProperty<TextStyle?>("prefixStyle", prefixStyle),)..add(
      DiagnosticsProperty<bool>(
        "forceSuffixDirection",
        forceSuffixDirection,
      ),
    )..add(IterableProperty<String>("autofillHints", autofillHints))..add(
        DiagnosticsProperty<bool>("autofocus", autofocus),)..add(
        DiagnosticsProperty<bool>("removeBorder", removeBorder),)..add(
        DiagnosticsProperty<TextStyle?>("inputTextStyle", inputTextStyle),)..add(
        EnumProperty<TextAlign?>("textAlign", textAlign),)..add(
        IntProperty("maxLines", maxLines),)..add(
        StringProperty("placeHolderText", labelTitleText),)..add(
        StringProperty("errorMessage", errorMessage),)..add(
        DoubleProperty("textFieldHeight", textFieldHeight),)..add(
        DiagnosticsProperty<TextStyle?>("hintTextStyle", hintTextStyle),)..add(
        ObjectFlagProperty<VoidCallback?>.has("onTap", onTap),)..add(
        ColorProperty("errorBorderColor", errorBorderColor),)..add(
        DiagnosticsProperty<IconData?>("errorIcon", errorIcon),)..add(
      DiagnosticsProperty<bool>("clearSearchEnabled", clearSearchEnabled),);
  }
}

class _MainInputFieldState extends State<MainInputField> {
  bool isPassword = false;
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    isPassword = widget.password;
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
    hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MainInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.errorMessage != null ||
        (oldWidget.errorMessage?.isEmpty ?? true)) &&
        oldWidget.errorMessage != widget.errorMessage) {
      playHapticFeedback(HapticFeedbackType.validationError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.labelTitleText != null
            ? PaddingWidget.applySymmetricPadding(
          vertical: 5,
          child: Text(
            widget.labelTitleText ?? "",
            style: captionOneMediumTextStyle(
              context: context,
              fontColor: secondaryTextColor(context: context),
            ),
          ).textSupportsRTL(context),
        )
            : const SizedBox.shrink(),
        SizedBox(
          height: widget.maxLines == 1 ? widget.textFieldHeight : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.backgroundColor ??
                  Theme
                      .of(context)
                      .colorScheme
                      .cBackground(context),
              boxShadow: widget.removeBorder
                  ? null
                  : <BoxShadow>[
                BoxShadow(
                  color: _getBoxShadowColor(context),
                  spreadRadius: 1,
                ),
              ],
              // boxShadow: [
              //   BoxShadow(
              //       color: Theme.of(context).colorScheme.cHintTextColor(context).withAlpha(20), spreadRadius: 2, blurRadius: 1, offset: const Offset(0, 2)),
              //   BoxShadow(
              //       color: Theme.of(context).colorScheme.cHintTextColor(context).withAlpha(20), spreadRadius: 2, blurRadius: 1, offset: const Offset(0, -1)),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  getPrefixIcon(context) ?? Container(),
                  Expanded(
                    child: TextFormField(
                      enabled: !widget.isReadOnly,
                      autofocus: widget.autofocus,
                      autofillHints: widget.autofillHints,
                      controller: widget.controller,
                      keyboardType: widget.textInputType,
                      focusNode: widget.fieldFocusNode,
                      textInputAction: widget.textInputAction,
                      onTap: widget.onTap,
                      onChanged: (String value) =>
                          widget.onChanged?.call(text: value),
                      inputFormatters: widget.formatter != null
                          ? <TextInputFormatter>[widget.formatter!]
                          : null,
                      style: widget.inputTextStyle,
                      onEditingComplete: () {
                        if (widget.enterPressed != null) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.enterPressed?.call();
                        }
                      },
                      onFieldSubmitted: (String value) {
                        if (widget.nextFocusNode != null) {
                          widget.nextFocusNode?.requestFocus();
                        }
                      },
                      obscureText: widget.isObscure ?? isPassword,
                      readOnly: widget.isReadOnly,
                      cursorColor: widget.cursorColor ??
                          Theme
                              .of(context)
                              .colorScheme
                              .cHintTextColor(context),
                      // initialValue: widget.initialValue,
                      maxLines: widget.maxLines,
                      maxLength: widget.maxLength,
                      textAlign: widget.textAlign ?? TextAlign.start,
                      decoration: InputDecoration(
                        icon: widget.leadingIcon,
                        isDense: true,
                        //IconButton(icon: Icon(Icons.favorite),onPressed: () {}),
                        border: widget.inputBorder ?? InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: widget.hintTextStyle ?? widget.labelStyle,
                        labelText: widget.labelText,
                        labelStyle: widget.labelStyle,
                        helperText: widget.helperText,
                        prefixText: widget.prefixText,
                        prefixStyle: widget.prefixStyle,
                        // prefixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 28),
                        // prefixIcon: getPrefixIcon(context),
                        // suffixIcon: getSuffixIcon(context),
                        enabledBorder: widget.enabledBorder,
                        disabledBorder: widget.disabledBorder,
                        errorBorder: widget.errorBorder,
                        focusedBorder: widget.focusedBorder,
                        focusedErrorBorder: widget.focusedErrorBorder,
                        focusColor: widget.focusColor,
                      ),
                    ),
                  ),
                  getSuffixIcon(context) ?? Container(),
                ],
              ),
            ),
          ),
        ),
        _buildErrorMessageWidget(context),
      ],
    );
  }

  Widget? usePrefixIconWidget(BuildContext context) {
    return widget.prefixIcon;
  }

  Widget _buildErrorMessageWidget(BuildContext context) {
    if (widget.errorMessage == null) {
      return const SizedBox.shrink();
    }

    if (widget.errorMessage!.isEmpty) {
      return const SizedBox(height: 30);
    }

    return SizedBox(
      height: 30,
      child: PaddingWidget.applySymmetricPadding(
        vertical: 5,
        child: Text(
          widget.errorMessage!,
          style: captionOneNormalTextStyle(
            context: context,
            fontColor: widget.errorBorderColor ??
                errorTextColor(context: context),
          ),
        ).textSupportsRTL(context),
      ),
    );
  }

  Color _getBoxShadowColor(BuildContext context) {
    final bool hasNoError =
        widget.errorMessage == null || widget.errorMessage == "";
    if (hasNoError) {
      return greyBackGroundColor(context: context);
    }
    return widget.errorBorderColor ?? errorTextColor(context: context);
  }

  Widget? getSuffixIcon(BuildContext context) {
    if (_shouldShowClearButton()) {
      return _buildClearButton();
    }

    if (widget.forceSuffixDirection) {
      return _getSuffixIconWithForcedDirection(context);
    }

    return _getSuffixIconWithDefaultDirection(context);
  }

  bool _shouldShowClearButton() {
    return widget.clearSearchEnabled && hasText;
  }

  Widget _buildClearButton() {
    return IconButton(
      icon: Icon(
        Icons.clear,
        color: widget.themeColor,
        size: 20,
      ),
      onPressed: () {
        widget.controller.clear();
        widget.onChanged?.call(text: "");
      },
    );
  }

  Widget? _getSuffixIconWithForcedDirection(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    if (isRtl) {
      return usePrefixIconWidget(context);
    }

    return _getPasswordToggleOrSuffixIcon();
  }

  Widget? _getSuffixIconWithDefaultDirection(BuildContext context) {
    if (_shouldShowPasswordToggle()) {
      return _buildPasswordToggleButton();
    }

    if (_shouldShowErrorIcon()) {
      return _buildErrorIcon(context);
    }

    return widget.suffixIcon;
  }

  bool _shouldShowPasswordToggle() {
    return (widget.password && !widget.hideInternalObfuscator) ||
        (widget.isObscure != null && !widget.hideInternalObfuscator);
  }

  Widget? _getPasswordToggleOrSuffixIcon() {
    if (_shouldShowPasswordToggle()) {
      return _buildPasswordToggleButton();
    }
    return widget.suffixIcon;
  }

  Widget _buildPasswordToggleButton() {
    return IconButton(
      icon: Icon(
        _getPasswordToggleIcon(),
        color: widget.themeColor,
      ),
      onPressed: _handlePasswordToggle,
    );
  }

  IconData _getPasswordToggleIcon() {
    return (widget.isObscure ?? !isPassword)
        ? Icons.visibility_off
        : Icons.visibility;
  }

  void _handlePasswordToggle() {
    setState(() {
      isPassword = !isPassword;
      widget.onObscureChange?.call(value: !(widget.isObscure ?? false));
    });
  }

  bool _shouldShowErrorIcon() {
    return widget.errorMessage != null && widget.errorMessage!.isNotEmpty;
  }

  Widget _buildErrorIcon(BuildContext context) {
    return Icon(
      widget.errorIcon ?? Icons.error_outline,
      color: widget.errorBorderColor ?? errorTextColor(context: context),
      size: 16,
    );
  }

  Widget? getPrefixIcon(BuildContext context) {
    if (!widget.forceSuffixDirection) {
      return usePrefixIconWidget(context);
    }

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    if (!isRtl) {
      return usePrefixIconWidget(context);
    }

    return _getPasswordToggleOrSuffixIcon();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<bool>("isPassword", isPassword))..add(
        DiagnosticsProperty<bool>("hasText", hasText),);
  }
}

/// Configuration class for text-related properties of MainInputField
class MainInputFieldTextConfig {
  const MainInputFieldTextConfig({
    this.hintText,
    this.labelText,
    this.labelTitleText,
    this.initialValue,
    this.errorMessage,
  });

  final String? hintText;
  final String? labelText;
  final String? labelTitleText;
  final String? initialValue;
  final String? errorMessage;
}

/// Configuration class for appearance-related properties of MainInputField
/// Combines style and visual properties
class MainInputFieldAppearanceConfig {
  const MainInputFieldAppearanceConfig({
    this.labelStyle,
    this.inputTextStyle,
    this.hintTextStyle,
    this.backgroundColor,
    this.textFieldHeight,
    this.errorColor,
    this.errorIcon,
  });

  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? hintTextStyle;
  final Color? backgroundColor;
  final double? textFieldHeight;
  final Color? errorColor;
  final IconData? errorIcon;
}

/// Configuration class for behavior-related properties of MainInputField
class MainInputFieldBehaviorConfig {
  const MainInputFieldBehaviorConfig({
    this.isReadOnly = false,
    this.autofocus = false,
    this.isObscure,
    this.hideInternalObfuscator,
    this.removeBorder,
    this.clearSearchEnabled,
  });

  final bool isReadOnly;
  final bool autofocus;
  final bool? isObscure;
  final bool? hideInternalObfuscator;
  final bool? removeBorder;
  final bool? clearSearchEnabled;
}

/// Configuration class for input-related properties of MainInputField
class MainInputFieldInputConfig {
  const MainInputFieldInputConfig({
    this.textInputType,
    this.formatter,
    this.autofillHints,
    this.textAlign,
    this.maxLines,
  });

  final TextInputType? textInputType;
  final TextInputFormatter? formatter;
  final Iterable<String>? autofillHints;
  final TextAlign? textAlign;
  final int? maxLines;
}

/// Configuration class for interaction callbacks of MainInputField
class MainInputFieldInteractionConfig {
  const MainInputFieldInteractionConfig({
    this.enterPressed,
    this.onChanged,
    this.onTap,
    this.onObscureChange,
  });

  final void Function()? enterPressed;
  final void Function({required String text})? onChanged;
  final VoidCallback? onTap;
  final void Function({required bool value})? onObscureChange;
}

@AppPreview(name: "Main Input Field")
Widget mainInputFieldPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: MainInputField(
        controller: TextEditingController(),
        themeColor: Colors.blue,
        hintText: "Enter value",
      ),
    ),
  );
}
