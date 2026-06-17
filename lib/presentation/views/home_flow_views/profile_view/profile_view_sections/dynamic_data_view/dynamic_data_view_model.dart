import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/use_case/app/get_about_us_use_case.dart";
import "package:esim_open_source/domain/use_case/app/get_terms_and_condition_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

enum DynamicDataViewType {
  aboutUs,
  termsConditions;

  String get viewTitle {
    switch (this) {
      case DynamicDataViewType.aboutUs:
        return LocaleKeys.profile_aboutUs.tr();
      case DynamicDataViewType.termsConditions:
        return LocaleKeys.profile_termsConditions.tr();
    }
  }
}

class DynamicDataViewModel extends BaseModel {
  late DynamicDataViewType viewType;

  String viewTitle = "";
  String viewIntro = "";
  String viewContent = "";

  String get getHtmlContent => "$viewIntro $viewContent";

  final GetAboutUsUseCase getAboutUsUseCase = GetAboutUsUseCase(locator());
  final GetTermsAndConditionUseCase getTermsAndConditionUseCase =
      GetTermsAndConditionUseCase(locator());

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();

    // unawaited(getPageData());
    setViewState(ViewState.busy);

    if (viewType == DynamicDataViewType.aboutUs) {
      fetchAboutUsData();
    } else if (viewType == DynamicDataViewType.termsConditions) {
      fetchTermsData();
    }
  }

  Future<void> fetchAboutUsData() async {
    Resource<DynamicPageResponse?> response =
        await getAboutUsUseCase.execute(NoParams());
    handleResponse(
      response,
      onSuccess: (Resource<DynamicPageResponse?> result) async {
        viewTitle = result.data?.pageTitle ?? "";
        viewIntro = result.data?.pageIntro ?? "";
        viewContent = result.data?.pageContent ?? "";
      },
      onFailure: (Resource<DynamicPageResponse?> result) async {
        await handleError(result);
        navigationService.back();
      },
    );

    setViewState(ViewState.idle);
  }

  Future<void> fetchTermsData() async {
    Resource<DynamicPageResponse?> response =
        await getTermsAndConditionUseCase.execute(NoParams());
    handleResponse(
      response,
      onSuccess: (Resource<DynamicPageResponse?> result) async {
        viewTitle = result.data?.pageTitle ?? "";
        viewIntro = result.data?.pageIntro ?? "";
        viewContent = result.data?.pageContent ?? "";
      },
      onFailure: (Resource<DynamicPageResponse?> result) async {
        await handleError(result);
        navigationService.back();
      },
    );
    setViewState(ViewState.idle);
  }
}
