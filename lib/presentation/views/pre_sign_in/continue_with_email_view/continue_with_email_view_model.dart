import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/display_message_helper.dart";
import "package:flutter/material.dart";
import "package:phone_input/phone_input_package.dart";
import "package:stacked_services/stacked_services.dart";

class ContinueWithEmailViewModel extends BaseModel {
  ContinueWithEmailViewModel({
    this.redirection,
    LoginType? localLoginType,
  }) : _localLoginType =
            localLoginType ?? AppEnvironment.appEnvironmentHelper.loginType;

  InAppRedirection? redirection;
  final LoginType _localLoginType;

  //#region UseCases
  final LoginUseCase loginUseCase = LoginUseCase(locator<ApiAuthRepository>());

  //#endregion

  //#region Variables
  final ContinueWithEmailState _state = ContinueWithEmailState();

  ContinueWithEmailState? get state => _state;

  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: ""));

  bool get showEmailField {
    switch (_localLoginType) {
      case LoginType.email:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        return true;
      case LoginType.phoneNumber:
        return false;
    }
  }

  bool get showPhoneField {
    switch (_localLoginType) {
      case LoginType.email:
        return false;
      case LoginType.emailAndPhone:
      case LoginType.phoneNumber:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        return true;
    }
  }


  String get selectedOtpChannel => _state.selectedOtpChannel;

  void selectOtpChannel(String channel) {
    _state.selectedOtpChannel = channel;
    _state.otpSendErrorMessage = null;
    notifyListeners();
  }

  String? get otpSendErrorMessage => _state.otpSendErrorMessage;

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();

    switch (_localLoginType) {
      case LoginType.phoneNumber:
        break;
      case LoginType.email:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        _state.emailController.addListener(_validateForm);
    }
  }

  void _validateForm() {
    final String emailAddress = _state.emailController.text;
    _state.emailErrorMessage = validateEmailAddress(emailAddress);

    switch (_localLoginType) {
      case LoginType.email:
        _state.isLoginEnabled =
            _state.emailErrorMessage == "" && _state.isTermsChecked;
      case LoginType.phoneNumber:
        _state.isLoginEnabled =
            _state.isValidPhoneNumber && _state.isTermsChecked;
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        _state.isLoginEnabled = _state.emailErrorMessage == "" &&
            _state.isTermsChecked &&
            _state.isValidPhoneNumber;
    }

    notifyListeners();
  }

  void validateNumber({
    required String code,
    required String number,
    required bool isValid,
  }) {
    _state.isValidPhoneNumber = isValid;

    switch (_localLoginType) {
      case LoginType.email:
        break;
      case LoginType.phoneNumber:
        _state.isLoginEnabled = isValid && _state.isTermsChecked;
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndEmailVerification:
      case LoginType.emailAndPhoneAndBothVerification:
        _state.isLoginEnabled =
            _state.emailErrorMessage == "" && isValid && _state.isTermsChecked;
    }

    notifyListeners();
  }

  Future<void>? loginButtonTapped() async {
    await _loginWithEmail();
  }

  Future<void> loginButtonTappedWithChannel(String channel) async {
    _state.selectedOtpChannel = channel;
    await _loginWithEmail();
  }

  //tested
  void updateTermsSelections() {
    _state.isTermsChecked = !_state.isTermsChecked;
    _validateForm();
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

  //tested
  void backButtonTapped() {
    navigationService.back();
  }

  Future<void>? showTermsSheet() async {
    SheetResponse<EmptyBottomSheetResponse>? response =
        await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.termsCondition,
      isScrollControlled: true,
      enableDrag: false,
    );
    if (response?.confirmed ?? false) {
      _state.isTermsChecked = true;
      _validateForm();
    }
  }

  //#endregion

  //#region Apis
  String? _determineOtpChannel() {
    switch (_localLoginType) {
      case LoginType.emailAndPhoneAndEmailVerification:
        return "EMAIL";
      case LoginType.emailAndPhoneAndBothVerification:
        return _state.selectedOtpChannel;
      default:
        return null;
    }
  }

  String? _getPhoneNumber() {
    return _state.isValidPhoneNumber
        ? "+${phoneController.value?.countryCode}${phoneController.value?.nsn}"
        : null;
  }

  String? _getEmail() {
    return _state.emailErrorMessage == "" ? _state.emailController.text : null;
  }

  VerifyLoginViewArgs _buildVerifyLoginArgs(OtpResponseModel? otpData) {
    return VerifyLoginViewArgs(
      redirection: redirection,
      phoneNumber: _getPhoneNumber(),
      email: _getEmail(),
      otpExpiration: otpData?.otpExpiration,
      localLoginType: _localLoginType,
      otpChannel: _state.selectedOtpChannel,
    );
  }

  Future<void> _handleLoginSuccess(Resource<OtpResponseModel?> response) async {
    final VerifyLoginViewArgs args = _buildVerifyLoginArgs(response.data);
    debugPrint("args: $args");
    navigationService.navigateTo(
      VerifyLoginView.routeName,
      arguments: args,
    );
  }

  Future<void> _handleRateLimitError(Resource<OtpResponseModel?> response) async {
    if (response.message != null && response.message!.isNotEmpty) {
      DisplayMessageHelper.toast(response.message!);
    }
    final VerifyLoginViewArgs args = _buildVerifyLoginArgs(response.data);
    navigationService.navigateTo(VerifyLoginView.routeName, arguments: args);
  }

  Future<void> _handleOtpSendError(Resource<OtpResponseModel?> response) async {
    if (_localLoginType == LoginType.emailAndPhoneAndBothVerification) {
      _state.otpSendErrorMessage = response.message ??
          (_state.selectedOtpChannel == "SMS"
              ? LocaleKeys.continueWithEmail_otpFailedViaSms.tr()
              : LocaleKeys.continueWithEmail_otpFailedViaEmail.tr());
      notifyListeners();
      return;
    }
    handleError(response);
  }

  Future<void> _loginWithEmail() async {
    setViewState(ViewState.busy);

    String? otpChannel = _determineOtpChannel();

    Resource<OtpResponseModel?> loginResponse = await loginUseCase.execute(
      LoginParams(
        phoneNumber: _getPhoneNumber(),
        email: _getEmail(),
        otpChannel: otpChannel,
      ),
    );

    await handleResponse(
      loginResponse,
      onSuccess: (Resource<OtpResponseModel?> response) async {
        await _handleLoginSuccess(response);
      },
      onFailure: (Resource<OtpResponseModel?> response) async {
        if (response.error?.errorCode == 429) {
          await _handleRateLimitError(response);
          return;
        }
        await _handleOtpSendError(response);
      },
    );

    setViewState(ViewState.idle);
  }
//#endregion
}

class ContinueWithEmailState {
  bool isTermsChecked = false;
  bool isLoginEnabled = false;
  String? emailErrorMessage;
  bool isValidPhoneNumber = false;
  String selectedOtpChannel = "SMS";
  String? otpSendErrorMessage;

  final TextEditingController emailController = TextEditingController();
}
