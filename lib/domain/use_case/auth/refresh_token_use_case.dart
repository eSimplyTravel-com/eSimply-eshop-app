import "dart:async";

import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class RefreshTokenUseCase
    implements UseCase<Resource<AuthResponseModel>, NoParams> {
  RefreshTokenUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<AuthResponseModel>> execute(NoParams params) async {
    return await repository.refreshTokenAPITrigger();
  }
}
