import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/contact_us_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class ContactUsViewModel extends BaseModel {
  //#region UseCases
  final ContactUsUseCase contactUsUseCase =
      ContactUsUseCase(locator<ApiAppRepository>());

  //#endregion

  //#region Variables
  final ContactUsState _state = ContactUsState();

  ContactUsState get state => _state;

  String? emailErrorMessage;
  String? contentErrorMessage;
  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();

    _state.emailController.addListener(_validateForm);
    _state.messageController.addListener(_validateForm);
  }

  void _validateForm() {
    final String emailAddress = _state.emailController.text;
    final String contentMessage = _state.messageController.text;
    emailErrorMessage = validateEmailAddress(emailAddress);
    contentErrorMessage = validateContentMessage(contentMessage);
    _state.isButtonEnabled = (emailErrorMessage?.isEmpty ?? false) &&
        (contentErrorMessage?.isEmpty ?? false);

    notifyListeners();
  }

  String validateEmailAddress(String text) {
    if (text.trim().isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    if (text.trim().isValidEmail()) {
      return "";
    }

    return LocaleKeys.enter_a_valid_email_address.tr();
  }

  String validateContentMessage(String text) {
    if (text.trim().isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    return "";
  }

  void onSendMessageClicked(BuildContext context) {
    if (context.mounted) {
      unawaited(_sendMessage(context));
    }
  }

//#endregion

//#region Apis
  Future<void> _sendMessage(BuildContext context) async {
    if (context.mounted) {
      setViewState(ViewState.busy);
      Resource<StringResponse?> response = await contactUsUseCase.execute(
        ContactUsParams(
          email: _state.emailController.text,
          message: _state.messageController.text,
        ),
      );
      handleResponse(
        response,
        onSuccess: (Resource<StringResponse?> result) async {
          setViewState(ViewState.idle);
          showToast(
            LocaleKeys.contactUs_successTitleText.tr(),
          );
          navigationService.back();
        },
      );
    }
  }
//#endregion
}

class ContactUsState {
  bool isButtonEnabled = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
}
