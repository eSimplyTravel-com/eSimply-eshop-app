import "dart:ui" as ui;

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:phone_input/phone_input_package.dart";

class MyPhoneInput extends StatelessWidget {
  const MyPhoneInput({
    required this.onChanged,
    required this.phoneController,
    this.validateRequired = false,
    this.validateEmpty = false,
    this.enabled = true,
    super.key,
  });

  final Function(
    String countryCode,
    String phoneNumber, {
    required bool isValid,
  }) onChanged;

  final PhoneController phoneController;
  final bool validateRequired;
  final bool validateEmpty;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Widget phoneInput = Directionality(
      textDirection: ui.TextDirection.ltr,
      child: PhoneInput(
        enabled: enabled,
        controller: phoneController,
        style: _buildTextStyle(context),
        countryCodeStyle: _buildTextStyle(context),
        defaultCountry: IsoCode.LB,
        autovalidateMode:
            enabled ? AutovalidateMode.always : AutovalidateMode.disabled,
        validator: enabled ? _buildValidator() : null,
        flagShape: BoxShape.rectangle,
        decoration: _buildInputDecoration(context),
        onChanged: _buildOnChanged(),
        countrySelectorNavigator: _buildCountrySelectorNavigator(context),
      ),
    );

    // If disabled, wrap with AbsorbPointer to completely block all interactions
    return enabled
        ? phoneInput
        : AbsorbPointer(
            child: phoneInput,
          );
  }

  TextStyle _buildTextStyle(BuildContext context) {
    final Color? textColor = enabled
        ? context.appColors.grey_900
        : context.appColors.grey_400;

    return bodyNormalTextStyle(context: context).copyWith(color: textColor);
  }

  PhoneNumberInputValidator? _buildValidator() {
    final String? Function(PhoneNumber? phoneNumber) emptyValidator = validateEmpty
        ? PhoneValidator.required()
        : PhoneValidator.none;
    final String? Function(PhoneNumber? phoneNumber) validValidator = validateRequired
        ? PhoneValidator.valid()
        : PhoneValidator.none;
    return PhoneValidator.compose(
      <PhoneNumberInputValidator>[
        emptyValidator,
        validValidator,
      ],
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    final Color? hintColor = enabled
        ? secondaryTextColor(context: context)
        : context.appColors.grey_300;

    final Color borderColor = enabled
        ? context.appColors.grey_200!
        : context.appColors.grey_100!;

    return InputDecoration(
      focusColor: Colors.transparent,
      labelText: "",
      hintText: LocaleKeys.phoneInput_placeHolder.tr(),
      hintStyle: captionOneNormalTextStyle(
        context: context,
        fontColor: hintColor,
      ),
      labelStyle: TextStyle(color: enabled ? Colors.red : Colors.grey),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: enabled ? context.appColors.grey_200! : borderColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: enabled ? context.appColors.grey_200! : borderColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: enabled ? null : context.appColors.grey_50,
      filled: !enabled,
    );
  }

  void Function(PhoneNumber?)? _buildOnChanged() {
    return enabled
        ? (PhoneNumber? p) => onChanged(
              p?.countryCode ?? "961",
              p?.nsn ?? "",
              isValid: p?.isValid(type: PhoneNumberType.mobile) ?? false,
            )
        : null;
  }

  CountrySelectorNavigator _buildCountrySelectorNavigator(
    BuildContext context,
  ) {
    return CountrySelectorNavigator.modalBottomSheet(
      searchInputDecoration: InputDecoration(
        focusColor: Colors.green,
        labelText: LocaleKeys.phoneInput_countryPlaceHolder.tr(),
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.appColors.grey_200!),
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.appColors.grey_200!),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      searchInputTextStyle: const TextStyle(color: Colors.black),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            Function(
              String countryCode,
              String phoneNumber, {
              required bool isValid,
            })>.has("onChanged", onChanged),
      )
      ..add(
        DiagnosticsProperty<PhoneController>(
          "phoneController",
          phoneController,
        ),
      )
      ..add(DiagnosticsProperty<bool>("validateRequired", validateRequired))
      ..add(DiagnosticsProperty<bool>("validateEmpty", validateEmpty))
      ..add(DiagnosticsProperty<bool>("enabled", enabled));
  }
}

@AppPreview(name: "My Phone Input")
Widget myPhoneInputPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: MyPhoneInput(
        phoneController:
            PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: "")),
        onChanged: (
          String countryCode,
          String phoneNumber, {
          required bool isValid,
        }) {},
      ),
    ),
  );
}
