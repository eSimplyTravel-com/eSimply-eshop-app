import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/delete_account_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:phone_input/phone_input_package.dart";

class DeleteAccountBottomSheetViewModel extends BaseModel {
  String? emailErrorMessage;
  bool _isButtonEnabled = false;

  bool get isButtonEnabled => _isButtonEnabled;

  TextEditingController get emailController => _emailController;
  final TextEditingController _emailController = TextEditingController();
  final DeleteAccountUseCase deleteAccountUseCase =
      DeleteAccountUseCase(locator<ApiAuthRepository>());

  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: ""));

  bool get showPhoneInput {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
      case LoginType.emailAndPhoneAndEmailVerification:
        return false;
      case LoginType.phoneNumber:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndBothVerification:
        return true;
    }
  }

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    _emailController.addListener(_validateForm);

    PhoneNumber? parsed;
    try {
      parsed = PhoneNumber.parse(userMsisdn);
    } on Object catch (_) {}
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (parsed != null) {
        phoneController.value = PhoneNumber(
          isoCode: parsed.isoCode,
          nsn: "",
        );
      }
    });
  }

  void _validateForm() {
    final String emailAddress = _emailController.text.trim();
    emailErrorMessage = validateEmailAddress(emailAddress.trim());
    _isButtonEnabled = emailErrorMessage?.isEmpty ?? false;

    notifyListeners();
  }

  String validateEmailAddress(String text) {
    if (text.isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    if (!text.isValidEmail()) {
      return LocaleKeys.enter_a_valid_email_address.tr();
    }

    if (text != userEmailAddress) {
      return LocaleKeys.email_address_mismatch.tr();
    }

    return "";
  }

  void validateNumber({
    required String code,
    required String phoneNumber,
    required bool isValid,
  }) {
    log(userMsisdn);
    bool phoneNumberMatches = userMsisdn == "+$code$phoneNumber";
    _isButtonEnabled = isValid && phoneNumberMatches;
    notifyListeners();
  }

  Future<void> deleteAccountButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<EmptyResponse?> deleteAccountResponse =
        await deleteAccountUseCase.execute(NoParams());

    await handleResponse(
      deleteAccountResponse,
      onSuccess: (Resource<EmptyResponse?> response) async {},
      onFailure: (Resource<EmptyResponse?> response) async {},
    );

    setViewState(ViewState.idle);
  }
}
