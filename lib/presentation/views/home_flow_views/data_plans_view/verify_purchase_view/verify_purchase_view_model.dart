import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/user/resend_order_otp_use_case.dart";
import "package:esim_open_source/domain/use_case/user/verify_order_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class VerifyPurchaseViewModel extends BaseModel {
  VerifyPurchaseViewModel({
    this.iccid,
    this.orderID,
  });

  String? iccid;
  String? orderID;

  bool _isVerifyButtonEnabled = false;
  bool get isVerifyButtonEnabled => _isVerifyButtonEnabled;

  String _pinCode = "";
  String _errorMessage = "";
  @override
  String get errorMessage => _errorMessage;

  final int otpCount = 6;

  final ResendOrderOtpUseCase resendOrderOtpUseCase =
      ResendOrderOtpUseCase(locator<ApiUserRepository>());
  final VerifyOrderOtpUseCase verifyOrderOtpUseCase =
      VerifyOrderOtpUseCase(locator<ApiUserRepository>());

  List<String> initialVerificationCode = <String>[];

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    initialVerificationCode =
        List<String>.generate(otpCount, (int index) => "");
  }

  Future<void> backButtonTapped() async {
    navigationService.back(result: false);
  }

  Future<void> verifyButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<EmptyResponse?> authResponse = await verifyOrderOtpUseCase.execute(
      VerifyOrderOtpParam(
        otp: _pinCode,
        iccid: iccid ?? "",
        orderID: orderID ?? "",
      ),
    );

    await handleResponse(
      authResponse,
      onSuccess: (Resource<EmptyResponse?> response) async {
        String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
        analyticsService.logEvent(
          event: AnalyticEvent.loginSuccess(
            utm: utm,
            platform: Platform.isAndroid ? "Android" : "iOS",
          ),
        );
        navigationService.back(result: true);
      },
      onFailure: (Resource<EmptyResponse?> response) async {
        _errorMessage = response.message ?? LocaleKeys.verifyLogin_wrongCode.tr();
        notifyListeners();
      },
    );

    setViewState(ViewState.idle);
  }

  Future<void> resendCodeButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<EmptyResponse?> resendOtpResponse =
        await resendOrderOtpUseCase.execute(
      ResendOrderOtpParam(
        orderID: orderID ?? "",
      ),
    );

    await handleResponse(
      resendOtpResponse,
      onSuccess: (Resource<EmptyResponse?> response) async {},
    );

    setViewState(ViewState.idle);
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
}
