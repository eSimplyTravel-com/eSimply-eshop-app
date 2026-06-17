import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  late FaqViewModel viewModel;
  late MockApiAppRepository mockApiAppRepository;
  late MockLocalStorageService mockLocalStorageService;

  tearDown(() async {
    await tearDownTest();
  });

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "FaqView");
    mockApiAppRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;

    when(mockLocalStorageService.languageCode).thenReturn("en");
    // reset(mockApiAppRepository);
    // reset(mockNavigationService);
    // reset(mockLocalStorageService);
    viewModel = FaqViewModel();
  });

  group("FaqViewModel", () {
    test("get faqs , returns error", () async {
      when(mockLocalStorageService.languageCode).thenReturn("en");
      when(mockApiAppRepository.getFaq()).thenAnswer(
        (_) async => Resource<List<FaqResponse>?>.error(
          data: <FaqResponse>[],
          "Network error",
        ),
      );

      viewModel.getFaqs();
    });

    test("constructor", () {
      expect(viewModel, isA<FaqViewModel>());
      expect(viewModel.getFaqUseCase, isNotNull);
      expect(viewModel.state, isA<FaqState>());
      expect(viewModel.state.faqList, isEmpty);
    });

    test("onViewModelReady", () async {
      when(mockLocalStorageService.languageCode).thenReturn("en");
      when(mockApiAppRepository.getFaq()).thenAnswer(
        (_) async =>
            Resource<List<FaqResponse>?>.success(<FaqResponse>[], message: ""),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      verify(mockApiAppRepository.getFaq()).called(1);
    });

    test("faqTapped", () {
      viewModel.state.faqList = <FaqUiModel>[
        FaqUiModel(
          faqID: 1,
          faqQuestion: "Q1",
          faqAnswer: "A1",
        ),
        FaqUiModel(
          faqID: 2,
          faqQuestion: "Q2",
          faqAnswer: "A2",
          isExpanded: true,
        ),
      ];

      expect(viewModel.state.faqList[0].isExpanded, false);
      expect(viewModel.state.faqList[1].isExpanded, true);

      viewModel.faqTapped(index: 0);
      expect(viewModel.state.faqList[0].isExpanded, true);

      viewModel.faqTapped(index: 1);
      expect(viewModel.state.faqList[1].isExpanded, false);
    });

    test("handleFaqResult empty", () async {
      final Resource<List<FaqResponse>?> result =
          Resource<List<FaqResponse>?>.success(<FaqResponse>[], message: "");
      await viewModel.handleFaqResult(result: result);
      expect(viewModel.state.faqList, isEmpty);
    });

    test("handleFaqResult null", () async {
      final Resource<List<FaqResponse>?> result =
          Resource<List<FaqResponse>?>.success(null, message: "");
      await viewModel.handleFaqResult(result: result);
      expect(viewModel.state.faqList, isEmpty);
    });

    test("handleFaqResult with data", () async {
      final List<FaqResponse> data = <FaqResponse>[
        FaqResponse(question: "Q1", answer: "A1"),
        FaqResponse(),
      ];
      final Resource<List<FaqResponse>?> result =
          Resource<List<FaqResponse>?>.success(data, message: "");
      await viewModel.handleFaqResult(result: result);

      expect(viewModel.state.faqList.length, 2);
      expect(viewModel.state.faqList[0].faqQuestion, "Q1");
      expect(viewModel.state.faqList[0].faqAnswer, "A1");
      expect(viewModel.state.faqList[0].faqID, 0);
      expect(viewModel.state.faqList[0].isExpanded, false);
      expect(viewModel.state.faqList[1].faqQuestion, "N/A");
      expect(viewModel.state.faqList[1].faqAnswer, "N/A");
      expect(viewModel.state.faqList[1].faqID, 1);
    });

    test("state getter", () {
      expect(viewModel.state, isA<FaqState>());
      expect(viewModel.state.faqList, isA<List<FaqUiModel>>());
    });
  });

  group("FaqState", () {
    test("constructor", () {
      final FaqState state = FaqState();
      expect(state.faqList, isEmpty);
      expect(state.faqList, isA<List<FaqUiModel>>());
    });

    test("faqList modification", () {
      final FaqState state = FaqState();
      final FaqUiModel item =
          FaqUiModel(faqID: 1, faqQuestion: "Q", faqAnswer: "A");
      state.faqList.add(item);
      expect(state.faqList.length, 1);
      expect(state.faqList.first, item);
    });
  });
}
