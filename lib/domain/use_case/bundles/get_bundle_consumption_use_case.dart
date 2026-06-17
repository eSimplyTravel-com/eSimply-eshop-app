import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetBundleConsumptionUseCase
    implements
        UseCase<Resource<BundleConsumptionResponse?>, BundleConsumptionParams> {
  GetBundleConsumptionUseCase(this.repository);

  final ApiBundlesRepository repository;

  @override
  FutureOr<Resource<BundleConsumptionResponse?>> execute(
    BundleConsumptionParams params,
  ) async {
    return await repository.getBundleConsumption(iccID: params.iccID);
  }
}

class BundleConsumptionParams {
  BundleConsumptionParams({
    required this.iccID,
  });

  final String iccID;
}
