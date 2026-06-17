import "dart:async";

import "package:esim_open_source/domain/data/request/related_search.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class AssignUserBundleUseCase
    implements
        UseCase<Resource<BundleAssignResponseModel?>, AssignUserBundleParam> {
  AssignUserBundleUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> execute(
    AssignUserBundleParam params,
  ) async {
    return await repository.assignBundle(
      bundleCode: params.bundleCode,
      promoCode: params.promoCode,
      referralCode: params.referralCode,
      affiliateCode: params.affiliateCode,
      paymentType: params.paymentType,
      bearerToken: params.bearerToken,
      relatedSearch: params.relatedSearch,
    );
  }
}

class AssignUserBundleParam {
  AssignUserBundleParam({
    required this.bundleCode,
    required this.promoCode,
    required this.referralCode,
    required this.affiliateCode,
    required this.paymentType,
    required this.relatedSearch,
    this.bearerToken,
  });

  final String bundleCode;
  final String promoCode;
  final String referralCode;
  final String affiliateCode;
  final String paymentType;
  final RelatedSearchRequestModel relatedSearch;
  String? bearerToken;
}
