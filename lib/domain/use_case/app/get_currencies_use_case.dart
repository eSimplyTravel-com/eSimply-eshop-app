import "dart:async";

import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetCurrenciesUseCase
    implements UseCase<Resource<List<CurrenciesResponseModel>?>, NoParams> {
  GetCurrenciesUseCase(this.repository);

  final ApiAppRepository repository;
  static Resource<List<CurrenciesResponseModel>?>? previousResponse;

  @override
  FutureOr<Resource<List<CurrenciesResponseModel>?>> execute(
    NoParams? params,
  ) async {
    if (previousResponse != null) {
      return previousResponse!;
    }

    Resource<List<CurrenciesResponseModel>?> response =
        await repository.getCurrencies();
    if (response.resourceType == ResourceType.success) {
      previousResponse = response;
    }

    return response;
  }
}
