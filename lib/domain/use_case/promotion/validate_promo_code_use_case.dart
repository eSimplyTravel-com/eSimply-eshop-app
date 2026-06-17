import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ValidatePromoCodeUseCaseParams {
  ValidatePromoCodeUseCaseParams({
    required this.promoCode,
    required this.bundleCode,
  });

  final String promoCode;
  final String bundleCode;
}

class ValidatePromoCodeUseCase
    implements
        UseCase<Resource<BundleResponseModel?>,
            ValidatePromoCodeUseCaseParams> {
  ValidatePromoCodeUseCase(this.repository);

  final ApiPromotionRepository repository;

  @override
  FutureOr<Resource<BundleResponseModel?>> execute(
    ValidatePromoCodeUseCaseParams params,
  ) async => await repository.validatePromoCode(
      promoCode: params.promoCode,
      bundleCode: params.bundleCode,
    );
}
