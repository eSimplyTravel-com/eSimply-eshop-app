import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:crypto/crypto.dart";
import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/auth/resend_otp_use_case.dart";
import "package:esim_open_source/domain/use_case/auth/verify_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class VerifyLoginViewModel extends BaseModel {
  VerifyLoginViewModel({this.email, this.phoneNumber, this.redirection});

  InAppRedirection? redirection;

  bool _isVerifyButtonEnabled = false;
  bool _canSwitchOtpChannel = false;
  Timer? _otpChannelSwitchTimer;

  bool get isVerifyButtonEnabled => _isVerifyButtonEnabled;
  bool get canSwitchOtpChannel => _canSwitchOtpChannel;

  String? email;
  String? phoneNumber;
  String _pinCode = "";
  String _errorMessage = "";

  LoginType? loginType;
  String? otpChannel;

  @override
  String get errorMessage => _errorMessage;

  final int otpCount = 6;

  final ResendOtpUseCase resendOtpUseCase =
      ResendOtpUseCase(locator<ApiAuthRepository>());
  final ResendOtpNewChannelUseCase resendOtpNewChannelUseCase =
      ResendOtpNewChannelUseCase(locator<ApiAuthRepository>());
  final VerifyOtpUseCase verifyOtpUseCase =
      VerifyOtpUseCase(locator<ApiAuthRepository>());

  List<String> initialVerificationCode = <String>[];

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    initialVerificationCode =
        List<String>.generate(otpCount, (int index) => "");

    // Start 15-second timer for channel switching if using email_phone_both
    if (loginType == LoginType.emailAndPhoneAndBothVerification) {
      _startChannelSwitchTimer();
    }
  }

  void _startChannelSwitchTimer() {
    _otpChannelSwitchTimer = Timer(const Duration(seconds: 15), () {
      _canSwitchOtpChannel = true;
      notifyListeners();
    });
  }

  String getAlternateChannel(String currentChannel) {
    return currentChannel == "EMAIL" ? "SMS" : "EMAIL";
  }

  @override
  void dispose() {
    _otpChannelSwitchTimer?.cancel();
    super.dispose();
  }

  Future<void> backButtonTapped() async {
    navigationService.back();
  }

  Future<void> verifyButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<AuthResponseModel> authResponse = await verifyOtpUseCase.execute(
      VerifyOtpParams(
        pinCode: _pinCode,
        email: email,
        phoneNumber: phoneNumber,

      ),
    );

    await handleResponse(
      authResponse,
      onSuccess: (Resource<AuthResponseModel> response) async {
        String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
        analyticsService.logEvent(
          event: AnalyticEvent.loginSuccess(
            utm: utm,
            platform: Platform.isAndroid ? "Android" : "iOS",
          ),
        );

        if (email != null && email!.isNotEmpty) {
          final String hashedEmail = hashEmail(email!);
          await analyticsService.setUserId(hashedEmail);
        }
        await navigateToHomePager(redirection: redirection);
      },
      onFailure: (Resource<AuthResponseModel> response) async {
        _errorMessage = response.message ?? LocaleKeys.verifyLogin_wrongCode.tr();
        notifyListeners();
      },
    );

    setViewState(ViewState.idle);
  }

  Future<void> resendCodeButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<OtpResponseModel?> resendOtpResponse =
        await resendOtpUseCase.execute(
      ResendOtpParams(
        email: email,
        phoneNumber: phoneNumber,
      ),
    );

    try {
      await handleResponse(
        resendOtpResponse,
        onSuccess: (Resource<OtpResponseModel?> response) async {},
      );
    } on Object catch (_) {}

    setViewState(ViewState.idle);
  }

  Future<void> resendCodeViaChannel(String channel) async {
    setViewState(ViewState.busy);

    Resource<ResendOtpResponseModel?> resendResponse =
        await resendOtpNewChannelUseCase.execute(
      ResendOtpNewChannelParams(
        email: email,
        phoneNumber: phoneNumber,
        otpChannel: channel,
      ),
    );

    await handleResponse(
      resendResponse,
      onSuccess: (Resource<ResendOtpResponseModel?> response) async {
        // OTP resent successfully
        _errorMessage = "";
        notifyListeners();
      },
      onFailure: (Resource<ResendOtpResponseModel?> response) async {
        _errorMessage = response.message ?? "";
        notifyListeners();
        await handleError(response);
      },
    );

    setViewState(ViewState.idle);
  }

  Future<void> resendViaAlternateChannel() async {
    if (otpChannel == null) {
      return;
    }

    final String alternateChannel = getAlternateChannel(otpChannel!);
    otpChannel = alternateChannel;

    // Restart the channel switch timer for the new channel
    _otpChannelSwitchTimer?.cancel();
    _canSwitchOtpChannel = false;
    _startChannelSwitchTimer();

    await resendCodeViaChannel(alternateChannel);
  }

  void otpFieldChanged(String verificationCode) {
    fillInitial(verificationCode);
    _isVerifyButtonEnabled = false;
    notifyListeners();
  }

  Future<void> otpFieldSubmitted(String verificationCode) async {
    fillInitial(verificationCode);
    _pinCode = verificationCode;
    _isVerifyButtonEnabled = true;
    notifyListeners();
  }

  void fillInitial(String verificationCode) {
    initialVerificationCode = List<String>.generate(
      otpCount,
      (int index) =>
          index < verificationCode.length ? verificationCode[index] : "",
    );
    notifyListeners();
  }

  String hashEmail(String email) {
    final Uint8List bytes = utf8.encode(email.toLowerCase());
    return sha256.convert(bytes).toString();
  }
}
