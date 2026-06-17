import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetRelatedTopupUseCase
    implements
        UseCase<Resource<List<BundleResponseModel>?>, GetRelatedTopupParam> {
  GetRelatedTopupUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<List<BundleResponseModel>?>> execute(
    GetRelatedTopupParam params,
  ) async {
    return await repository.getRelatedTopUp(
      iccID: params.iccID,
      bundleCode: params.bundleCode,
    );
  }
}

class GetRelatedTopupParam {
  GetRelatedTopupParam({
    required this.iccID,
    required this.bundleCode,
  });

  final String iccID;
  final String bundleCode;
}
