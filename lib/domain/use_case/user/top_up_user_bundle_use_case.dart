import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class TopUpUserBundleUseCase
    implements
        UseCase<Resource<BundleAssignResponseModel?>, TopUpUserBundleParam> {
  TopUpUserBundleUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> execute(
    TopUpUserBundleParam params,
  ) async {
    return await repository.topUpBundle(
      iccID: params.iccID,
      bundleCode: params.bundleCode,
      paymentType: params.paymentType,
    );
  }
}

class TopUpUserBundleParam {
  TopUpUserBundleParam({
    required this.iccID,
    required this.bundleCode,
    required this.paymentType,
  });

  final String iccID;
  final String bundleCode;
  final String paymentType;
}
