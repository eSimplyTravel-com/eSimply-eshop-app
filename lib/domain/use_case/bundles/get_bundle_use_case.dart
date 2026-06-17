import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetBundleUseCase
    implements UseCase<Resource<BundleResponseModel?>, BundleParams> {
  GetBundleUseCase(this.repository);

  final ApiBundlesRepository repository;

  @override
  FutureOr<Resource<BundleResponseModel?>> execute(
    BundleParams params,
  ) async {
    return await repository.getBundle(code: params.code);
  }
}

class BundleParams {
  BundleParams({
    required this.code,
  });

  final String code;
}
