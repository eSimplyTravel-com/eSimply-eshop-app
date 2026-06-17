import "dart:async";

import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetConfigurationsUseCase
    implements UseCase<Resource<List<ConfigurationResponseModel>?>, NoParams> {
  GetConfigurationsUseCase(this.repository);

  final ApiAppRepository repository;
  static Resource<List<ConfigurationResponseModel>?>? previousResponse;

  @override
  FutureOr<Resource<List<ConfigurationResponseModel>?>> execute(
    NoParams? params,
  ) async {
    if (previousResponse != null) {
      return previousResponse!;
    }

    Resource<List<ConfigurationResponseModel>?> response =
        await repository.getConfigurations();
    switch (response.resourceType) {
      case ResourceType.success:
        previousResponse = response;
      case ResourceType.error:
      case ResourceType.loading:
    }
    return response;
  }
}
