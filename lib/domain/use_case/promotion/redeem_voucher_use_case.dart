import "dart:async";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class RedeemVoucherUseCaseParams {
  RedeemVoucherUseCaseParams({
    required this.voucherCode,
  });

  final String voucherCode;
}

class RedeemVoucherUseCase
    implements UseCase<Resource<EmptyResponse?>, RedeemVoucherUseCaseParams> {
  RedeemVoucherUseCase(this.repository);

  final ApiPromotionRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(
    RedeemVoucherUseCaseParams params,
  ) async {
    return await repository.redeemVoucher(
      voucherCode: params.voucherCode,
    );
  }
}
