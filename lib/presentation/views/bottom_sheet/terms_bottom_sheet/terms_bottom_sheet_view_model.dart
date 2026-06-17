import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/use_case/app/get_terms_and_condition_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class TermsBottomSheetViewModel extends BaseModel {
  TermsBottomSheetViewModel(this.completer);
  Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  String viewTitle = "";
  String viewIntro = "";
  String viewContent = "";

  String get getHtmlContent => "$viewIntro $viewContent";

  final GetTermsAndConditionUseCase getTermsAndConditionUseCase =
      GetTermsAndConditionUseCase(locator());

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();

    setViewState(ViewState.busy);
    fetchTermsData();
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
        Future<void>.delayed(Duration.zero, () {
          completer(
            SheetResponse<EmptyBottomSheetResponse>(),
          );
        });
      },
    );

    setViewState(ViewState.idle);
  }
}
