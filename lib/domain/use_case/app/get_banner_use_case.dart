import "dart:async";

import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/utils/value_stream.dart";

class GetBannerUseCase
    implements StreamUseCase<Resource<List<BannerResponseModel>?>, NoParams> {
  GetBannerUseCase(this.repository);

  final ApiAppRepository repository;

  @override
  ValueStream<Resource<List<BannerResponseModel>?>> execute(
    NoParams? params,
  ) {
    return repository.getBannerStream();
  }

  Future<void> resetBannerStream(){
    return repository.resetBannerStream();
  }
}
