import "dart:async";

import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetUserConsumptionUseCase
    implements
        UseCase<Resource<UserBundleConsumptionResponse?>,
            UserConsumptionParam> {
  GetUserConsumptionUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<UserBundleConsumptionResponse?>> execute(
    UserConsumptionParam params,
  ) async {
    return await repository.getUserConsumption(iccID: params.iccID);
  }
}

class UserConsumptionParam {
  UserConsumptionParam({required this.iccID});

  final String iccID;
}
