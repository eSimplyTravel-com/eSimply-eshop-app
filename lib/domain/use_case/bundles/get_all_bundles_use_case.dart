import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetAllBundlesUseCase
    implements UseCase<Resource<List<BundleResponseModel>>, NoParams> {
  GetAllBundlesUseCase(this.repository);

  final ApiBundlesRepository repository;

  @override
  FutureOr<Resource<List<BundleResponseModel>>> execute(
    NoParams params,
  ) async {
    return await repository.getAllBundles();
  }
}
