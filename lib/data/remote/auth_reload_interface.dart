import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";

typedef AuthReloadListenerCallBack = void Function(AuthResponseModel?);

abstract interface class AuthReloadListener {
  void onAuthReloadListenerCallBackUseCase(
      AuthResponseModel? authResponse,
  );
}
