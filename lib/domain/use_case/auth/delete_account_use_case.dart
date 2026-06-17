import "dart:async";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class DeleteAccountUseCase
    implements UseCase<Resource<EmptyResponse>, NoParams> {
  DeleteAccountUseCase(this.repository);
  final ApiAuthRepository repository;

  @override
  FutureOr<Resource<EmptyResponse>> execute(NoParams params) async {
    return await repository.deleteAccount();
  }
}
