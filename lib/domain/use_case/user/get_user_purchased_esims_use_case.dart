import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetUserPurchasedEsimsUseCase
    implements
        UseCase<Resource<List<PurchaseEsimBundleResponseModel>?>, NoParams> {
  GetUserPurchasedEsimsUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<List<PurchaseEsimBundleResponseModel>?>> execute(
    NoParams params,
  ) async {
    return await repository.getMyEsims();
  }
}
