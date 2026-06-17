import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/helpers/language_response_wrapper.dart";

class GetFaqUseCase implements UseCase<Resource<List<FaqResponse>?>, NoParams> {
  GetFaqUseCase(this.repository);
  final ApiAppRepository repository;
  static LanguageResponseWrapper<Resource<List<FaqResponse>?>>?
      previousResponse;

  @override
  FutureOr<Resource<List<FaqResponse>?>> execute(NoParams? params) async {
    if (previousResponse != null &&
        previousResponse!.code == locator<LocalStorageService>().languageCode) {
      return previousResponse!.data;
    }

    Resource<List<FaqResponse>?> response = await repository.getFaq();
    switch (response.resourceType) {
      case ResourceType.success:
        previousResponse =
            LanguageResponseWrapper<Resource<List<FaqResponse>?>>(
          data: response,
          code: locator<LocalStorageService>().languageCode,
        );
      case ResourceType.error:
      case ResourceType.loading:
    }
    return response;
  }
}
