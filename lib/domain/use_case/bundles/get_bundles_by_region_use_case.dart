import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetBundlesByRegionUseCase
    implements
        UseCase<Resource<List<BundleResponseModel>>, BundleRegionParams> {
  GetBundlesByRegionUseCase(this.repository);

  final ApiBundlesRepository repository;

  @override
  FutureOr<Resource<List<BundleResponseModel>>> execute(
    BundleRegionParams params,
  ) async {
    return await repository.getBundlesByRegion(regionCode: params.regionCode);
  }
}

class BundleRegionParams {
  BundleRegionParams({
    required this.regionCode,
  });

  final String regionCode;
}
