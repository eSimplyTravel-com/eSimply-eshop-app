import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetUserPurchasedEsimByIccidUseCase
    implements
        UseCase<Resource<PurchaseEsimBundleResponseModel?>,
            GetUserPurchasedEsimByIccidParam> {
  GetUserPurchasedEsimByIccidUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<PurchaseEsimBundleResponseModel?>> execute(
    GetUserPurchasedEsimByIccidParam params,
  ) async {
    return await repository.getMyEsimByIccID(
      iccID: params.iccID,
    );
  }
}

class GetUserPurchasedEsimByIccidParam {
  GetUserPurchasedEsimByIccidParam({
    required this.iccID,
  });

  final String iccID;
}
