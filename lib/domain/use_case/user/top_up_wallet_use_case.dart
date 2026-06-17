import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class TopUpWalletUseCase
    implements UseCase<Resource<BundleAssignResponseModel?>, TopUpWalletParam> {
  TopUpWalletUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> execute(
    TopUpWalletParam params,
  ) async {
    return await repository.topUpWallet(
      amount: params.amount,
      currency: params.currencyCode,
    );
  }
}

class TopUpWalletParam {
  TopUpWalletParam({
    required this.amount,
    required this.currencyCode,
  });

  final double amount;
  final String currencyCode;
}
