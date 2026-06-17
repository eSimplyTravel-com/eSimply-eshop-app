import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";

class GetUserInfoUseCase
    implements UseCase<Resource<AuthResponseModel?>, NoParams> {
  GetUserInfoUseCase(this.repository);

  final ApiAuthRepository repository;
  final UserAuthenticationService userAuthenticationService =
      locator<UserAuthenticationService>();

  @override
  FutureOr<Resource<AuthResponseModel?>> execute(NoParams params) async {
    Resource<AuthResponseModel?> response = await repository.getUserInfo();
    await userAuthenticationService.updateUserResponse(response.data);
    return response;
  }
}
