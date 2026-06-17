import "dart:async";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/get_faq_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";

class FaqViewModel extends BaseModel {
  //#region UseCases
  final GetFaqUseCase getFaqUseCase =
      GetFaqUseCase(locator<ApiAppRepository>());

  //#endregion

  //#region Variables
  final FaqState _state = FaqState();

  FaqState get state => _state;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(getFaqs());
  }

  void faqTapped({required int index}) {
    _state.faqList[index].isExpanded = !_state.faqList[index].isExpanded;
    notifyListeners();
  }

  Future<void> handleFaqResult({
    required Resource<List<FaqResponse>?> result,
  }) async {
    List<FaqResponse?> faqList = result.data ?? <FaqResponse>[];
    if (faqList.isEmpty) {
      _state.faqList = <FaqUiModel>[];
    } else {
      _state.faqList = faqList
          .mapIndexed(
            (FaqResponse? faqResponseItem, int index) => FaqUiModel(
              faqID: index,
              faqQuestion: faqResponseItem?.question ?? "N/A",
              faqAnswer: faqResponseItem?.answer ?? "N/A",
            ),
          )
          .toList();
    }
  }

//#endregion

//#region Apis
  Future<void> getFaqs() async {
    setViewState(ViewState.busy);
    _state.faqList = <FaqUiModel>[];
    Resource<List<FaqResponse>?> response =
        await getFaqUseCase.execute(NoParams());
    handleResponse(
      response,
      onSuccess: (Resource<List<FaqResponse>?> result) async {
        handleFaqResult(result: result);
      },
      onFailure: (Resource<List<FaqResponse>?> result) async {
        await handleError(result);
        navigationService.back();
      },
    );
    setViewState(ViewState.idle);
  }
//#endregion
}

class FaqState {
  List<FaqUiModel> faqList = <FaqUiModel>[];
}

class FaqUiModel {
  FaqUiModel({
    required this.faqID,
    required this.faqQuestion,
    required this.faqAnswer,
    this.isExpanded = false,
  });

  int faqID;
  String faqQuestion;
  String faqAnswer;
  bool isExpanded;

  static List<FaqUiModel> getShimmerList = <FaqUiModel>[
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
    FaqUiModel(faqID: 1, faqQuestion: "", faqAnswer: ""),
  ];

  static FaqUiModel mockFaq = FaqUiModel(
    faqID: 1,
    faqQuestion: "Is there a free trial available?",
    faqAnswer:
        "Yes, you can try us for free for 30 days. If you want, we’ll provide you with a free, personalized 30-minute onboarding call to get you up and running as soon as possible.",
  );
}
