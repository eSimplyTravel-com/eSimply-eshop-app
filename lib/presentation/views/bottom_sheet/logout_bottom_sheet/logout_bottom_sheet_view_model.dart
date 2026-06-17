import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/logout_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";

class LogoutBottomSheetViewModel extends BaseModel {
  final LogoutUseCase logoutUseCase =
      LogoutUseCase(locator<ApiAuthRepository>());

  Future<void> logoutButtonTapped() async {
    //setViewState(ViewState.busy);

    Resource<EmptyResponse?> logoutResponse =
        await logoutUseCase.execute(NoParams());

    await handleResponse(
      logoutResponse,
      onSuccess: (Resource<EmptyResponse?> response) async {},
      onFailure: (Resource<EmptyResponse?> response) async {},
    );

    //setViewState(ViewState.idle);
  }
}
