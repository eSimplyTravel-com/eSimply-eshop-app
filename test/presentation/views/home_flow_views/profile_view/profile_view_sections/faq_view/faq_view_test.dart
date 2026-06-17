import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();
  late FaqViewModel viewModel;
  setUp(() async {
    await setupTest();
    viewModel = locator<FaqViewModel>();
  });

  tearDown(() async {
    tearDownTest();
  });

  testWidgets("renders basic structure, with data",
      (WidgetTester tester) async {
    onViewModelReadyMock(viewName: FaqView.routeName);
    when(locator<LocalStorageService>().languageCode).thenReturn("en");
    when(locator<ApiAppRepository>().getFaq()).thenAnswer(
      (_) async =>
          Resource<List<FaqResponse>?>.success(<FaqResponse>[], message: ""),
    );
    await viewModel.getFaqs();
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
    await tester.pumpWidget(
      createTestableWidget(
        const FaqView(),
      ),
    );
    await tester.pump();
  });

  group("FaqView", () {
    test("routeName", () {
      expect(FaqView.routeName, "FaqView");
    });

    test("debugFillProperties", () {
      const FaqView widget = FaqView();
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);
      expect(builder.properties, isNotNull);
    });
  });

  group("FaqWidget", () {
    test("debugFillProperties", () {
      final FaqUiModel model =
          FaqUiModel(faqID: 1, faqQuestion: "Q", faqAnswer: "A");
      final FaqWidget widget = FaqWidget(faqModel: model, onFaqTap: () {});
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);
      expect(builder.properties.length, greaterThan(0));
    });

    testWidgets("renders FaqWidget", (WidgetTester tester) async {
      final FaqUiModel model =
          FaqUiModel(faqID: 1, faqQuestion: "Q", faqAnswer: "A");
      final FaqWidget widget = FaqWidget(faqModel: model, onFaqTap: () {});

      await tester.pumpWidget(
        createTestableWidget(
          widget,
        ),
      );
      await tester.pump();
    });

    testWidgets("renders FaqWidget, expanded case",
        (WidgetTester tester) async {
      final FaqUiModel model = FaqUiModel(
        faqID: 1,
        faqQuestion: "Q",
        faqAnswer: "A",
        isExpanded: true,
      );
      final FaqWidget widget = FaqWidget(faqModel: model, onFaqTap: () {});

      await tester.pumpWidget(
        createTestableWidget(
          widget,
        ),
      );
      await tester.pump();
    });
  });

  group("FaqUiModel", () {
    test("constructor default", () {
      final FaqUiModel model =
          FaqUiModel(faqID: 1, faqQuestion: "Q", faqAnswer: "A");
      expect(model.faqID, 1);
      expect(model.faqQuestion, "Q");
      expect(model.faqAnswer, "A");
      expect(model.isExpanded, false);
    });

    test("constructor with isExpanded", () {
      final FaqUiModel model = FaqUiModel(
        faqID: 1,
        faqQuestion: "Q",
        faqAnswer: "A",
        isExpanded: true,
      );
      expect(model.isExpanded, true);
    });

    test("property mutation", () {
      final FaqUiModel model =
          FaqUiModel(faqID: 1, faqQuestion: "Q", faqAnswer: "A")
            ..faqID = 2
            ..faqQuestion = "Q2"
            ..faqAnswer = "A2"
            ..isExpanded = true;
      expect(model.faqID, 2);
      expect(model.faqQuestion, "Q2");
      expect(model.faqAnswer, "A2");
      expect(model.isExpanded, true);
    });

    test("getShimmerList", () {
      final List<FaqUiModel> shimmer = FaqUiModel.getShimmerList;
      expect(shimmer.length, 13);
      expect(shimmer.first.faqID, 1);
      expect(shimmer.first.faqQuestion, "");
      expect(shimmer.first.faqAnswer, "");
      expect(shimmer.first.isExpanded, false);
    });

    test("mockFaq", () {
      final FaqUiModel mock = FaqUiModel.mockFaq;
      expect(mock.faqID, 1);
      expect(mock.faqQuestion, "Is there a free trial available?");
      expect(mock.faqAnswer.contains("Yes"), true);
      expect(mock.isExpanded, false);
    });

    testWidgets("renders basic structure", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: FaqView.routeName);
      when(locator<LocalStorageService>().languageCode).thenReturn("en");
      when(locator<ApiAppRepository>().getFaq()).thenAnswer(
        (_) async =>
            Resource<List<FaqResponse>?>.success(<FaqResponse>[], message: ""),
      );
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
      await tester.pumpWidget(
        createTestableWidget(
          const FaqView(),
        ),
      );
      await tester.pump();
    });
  });
}
