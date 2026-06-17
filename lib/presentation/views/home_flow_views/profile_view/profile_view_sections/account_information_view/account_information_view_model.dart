import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/update_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:phone_input/phone_input_package.dart";

class AccountInformationViewModel extends BaseModel {
  bool _receiveUpdates = false;
  bool isValidEmail = false;
  String? emailErrorMessage;

  bool get receiveUpdated => _receiveUpdates;
  bool _saveButtonEnabled = false;

  String? _validationError;

  String? get validationError => _validationError;

  bool get saveButtonEnabled => _saveButtonEnabled;

  String userEmail = "";
  String userPhoneNumber = "";
  bool isPhoneValid = false;

  TextEditingController get nameController => _nameController;

  TextEditingController get emailController => _emailController;

  TextEditingController get familyNameController => _familyNameController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final UpdateUserInfoUseCase updateUserInfoUseCase =
      UpdateUserInfoUseCase(locator<ApiAuthRepository>());
  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: ""));

  bool get isPhoneInputEnabled {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
      case LoginType.emailAndPhoneAndEmailVerification:
        return true;
      case LoginType.phoneNumber:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndBothVerification:
        return false;
    }
  }

  bool get isEmailFieldEditable {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
        return false;
      case LoginType.phoneNumber:
        return true;
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndBothVerification:
      case LoginType.emailAndPhoneAndEmailVerification:
        return false;
    }
  }

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();
    PhoneNumber? parsed;
    try {
      parsed = PhoneNumber.parse(userMsisdn);
    } on Object catch (_) {
      //ignore
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userEmail = userEmailAddress;
      _nameController.text = userFirstName;
      _familyNameController.text = userLastName;
      _emailController.text = userEmailAddress;
      phoneController.value = PhoneNumber(
        isoCode: parsed?.isoCode ?? IsoCode.LB,
        nsn: parsed?.nsn ?? "",
      );

      _nameController.addListener(updateButtonState);
      _familyNameController.addListener(updateButtonState);
      _emailController.addListener(_validateForm);
      _validateForm();
      notifyListeners();
    });
  }

  void _validateForm() {
    final String emailAddress = _emailController.text;
    emailErrorMessage = validateEmailAddress(emailAddress);
    log("Message: $emailErrorMessage");
    log("email: $userEmailAddress");

    updateButtonState();
  }

  String validateEmailAddress(String text) {
    if (text.trim().isEmpty) {
      isValidEmail = false;

      return LocaleKeys.is_required_field.tr();
    }

    if (text.trim().isValidEmail()) {
      isValidEmail = true;
      return "";
    }
    isValidEmail = false;

    return LocaleKeys.enter_a_valid_email_address.tr();
  }

  void updateSwitch({
    required bool newValue,
  }) {
    _receiveUpdates = newValue;
    updateButtonState();
  }

  void validateNumber(
    String countryCode,
    String phoneNumber, {
    required bool isValid,
  }) {
    isPhoneValid = isValid;
    userPhoneNumber = phoneNumber;
    updateButtonState();
  }

  Future<void> saveButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<AuthResponseModel> updateInfoResponse =
        await updateUserInfoUseCase.execute(
      UpdateUserInfoParams(
        email: _emailController.text,
        msisdn: (phoneController.value?.nsn.isEmpty ?? true)
            ? ""
            : "+${phoneController.value?.countryCode}${phoneController.value?.nsn}",
        firstName: _nameController.text,
        lastName: _familyNameController.text,
      ),
    );

    await handleResponse(
      updateInfoResponse,
      onSuccess: (Resource<AuthResponseModel> response) async {
        navigationService.back();
      },
    );

    setViewState(ViewState.idle);
  }

  void updateButtonState() {
    bool isValidPhone = (userPhoneNumber.isEmpty)
        ? true
        : ((userPhoneNumber != userMsisdn) && isPhoneValid);

    _saveButtonEnabled = __saveButtonEnabled(isValidPhone);

    if (isPhoneValid) {
      _validationError = null;
    } else if (userPhoneNumber.isNotEmpty) {
      _validationError = LocaleKeys.invalid_phone_number.tr();
    }

    notifyListeners();
  }

  bool __saveButtonEnabled(bool isValidPhone) {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
        return ((_nameController.text != userFirstName) ||
                (_familyNameController.text != userLastName) ||
                (userPhoneNumber != userMsisdn)) &&
            isValidPhone;
      case LoginType.phoneNumber:
        return ((_nameController.text != userFirstName) ||
                (_familyNameController.text != userLastName) ||
                (_emailController.text != userEmailAddress)) &&
            isValidEmail;
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        return (_nameController.text != userFirstName) ||
            (_familyNameController.text != userLastName);
    }
  }
}
