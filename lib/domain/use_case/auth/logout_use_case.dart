import "dart:async";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class LogoutUseCase implements UseCase<Resource<EmptyResponse>, NoParams> {
  LogoutUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<EmptyResponse>> execute(NoParams params) async {
    Resource<EmptyResponse> result = await repository.logout();

    return result;
  }
}
