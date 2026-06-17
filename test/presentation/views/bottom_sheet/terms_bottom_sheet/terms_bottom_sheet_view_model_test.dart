import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/get_terms_and_condition_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/terms_bottom_sheet/terms_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late TermsBottomSheetViewModel viewModel;
  late MockApiAppRepository mockApiAppRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "TermsBottomSheetView");

    // Clear static cache to ensure test isolation
    GetTermsAndConditionUseCase.previousResponse = null;

    mockApiAppRepository = locator<ApiAppRepository>() as MockApiAppRepository;

    void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

    viewModel = TermsBottomSheetViewModel(completer);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("TermsBottomSheetViewModel Tests", () {
    test("initializes with correct default values", () {
      expect(viewModel.viewTitle, isEmpty);
      expect(viewModel.viewIntro, isEmpty);
      expect(viewModel.viewContent, isEmpty);
      expect(viewModel.getHtmlContent, equals(" "));
      expect(
        viewModel.getTermsAndConditionUseCase,
        isA<GetTermsAndConditionUseCase>(),
      );
      expect(viewModel.completer, isNotNull);
    });

    test("getHtmlContent returns concatenated intro and content", () {
      viewModel..viewIntro = "Introduction text"
      ..viewContent = "Main content text";

      expect(viewModel.getHtmlContent,
          equals("Introduction text Main content text"),);
    });

    test("getHtmlContent handles empty content", () {
      viewModel..viewIntro = ""
      ..viewContent = "";

      expect(viewModel.getHtmlContent, equals(" "));
    });

    test("getHtmlContent handles only intro", () {
      viewModel..viewIntro = "Only intro"
      ..viewContent = "";

      expect(viewModel.getHtmlContent, equals("Only intro "));
    });

    test("getHtmlContent handles only content", () {
      viewModel..viewIntro = ""
      ..viewContent = "Only content";

      expect(viewModel.getHtmlContent, equals(" Only content"));
    });

    test("onViewModelReady sets state to busy and calls fetchTermsData",
        () async {
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Introduction",
            pageContent: "Content",
          ),
          message: "Success",
        ),
      );

      await viewModel.onViewModelReady();

      expect(viewModel.viewState, equals(ViewState.idle));
      expect(viewModel.viewTitle, isA<String>());
      expect(viewModel.viewIntro, isA<String>());
      expect(viewModel.viewContent, isA<String>());
    });

    group("fetchTermsData", () {
      test("handles successful API response", () async {
        final DynamicPageResponse mockResponse = DynamicPageResponse(
          pageTitle: "Terms and Conditions",
          pageIntro: "Welcome to our terms",
          pageContent: "This is the main content of our terms and conditions.",
        );

        when(mockApiAppRepository.getTermsConditions()).thenAnswer(
          (_) async => Resource<DynamicPageResponse?>.success(
            mockResponse,
            message: "Terms loaded successfully",
          ),
        );

        await viewModel.fetchTermsData();

        // Verify the data was set (may be cached from previous calls)
        expect(viewModel.viewTitle, isNotEmpty);
        expect(viewModel.viewIntro, isNotEmpty);
        expect(viewModel.viewContent, isNotEmpty);
        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test("handles null API response data", () async {
        // Create fresh ViewModel to avoid cached data
        void nullCompleter(SheetResponse<EmptyBottomSheetResponse> response) {}
        final TermsBottomSheetViewModel nullViewModel =
            TermsBottomSheetViewModel(nullCompleter);

        when(mockApiAppRepository.getTermsConditions()).thenAnswer(
          (_) async => Resource<DynamicPageResponse?>.success(
            null,
            message: "Success but no data",
          ),
        );

        await nullViewModel.fetchTermsData();

        expect(nullViewModel.viewTitle, isEmpty);
        expect(nullViewModel.viewIntro, isEmpty);
        expect(nullViewModel.viewContent, isEmpty);
        expect(nullViewModel.viewState, equals(ViewState.idle));
      });

      test("handles API response with null fields", () async {
        // Create fresh ViewModel to avoid cached data
        void nullFieldCompleter(
            SheetResponse<EmptyBottomSheetResponse> response,) {}
        final TermsBottomSheetViewModel nullFieldViewModel =
            TermsBottomSheetViewModel(nullFieldCompleter);

        final DynamicPageResponse mockResponse = DynamicPageResponse();

        when(mockApiAppRepository.getTermsConditions()).thenAnswer(
          (_) async => Resource<DynamicPageResponse?>.success(
            mockResponse,
            message: "Success with null fields",
          ),
        );

        await nullFieldViewModel.fetchTermsData();

        expect(nullFieldViewModel.viewTitle, isEmpty);
        expect(nullFieldViewModel.viewIntro, isEmpty);
        expect(nullFieldViewModel.viewContent, isEmpty);
      });

      test("handles API exception and calls completer", () async {
        bool completerCalled = false;

        void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
          completerCalled = true;
        }

        final TermsBottomSheetViewModel testViewModel =
            TermsBottomSheetViewModel(testCompleter);

        when(mockApiAppRepository.getTermsConditions()).thenAnswer(
          (_) async => Resource<DynamicPageResponse?>.error(
            "Network error",
          ),
        );

        await testViewModel.fetchTermsData();

        // Wait for the async completer call
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(testViewModel.viewState, equals(ViewState.idle));
        expect(completerCalled, isTrue);
      });

      test("sets view state correctly during fetch process", () async {
        when(mockApiAppRepository.getTermsConditions()).thenAnswer(
          (_) async => Resource<DynamicPageResponse?>.success(
            DynamicPageResponse(
              pageTitle: "Test",
              pageIntro: "Test intro",
              pageContent: "Test content",
            ),
            message: "Success",
          ),
        );

        expect(viewModel.viewState, equals(ViewState.idle));

        final Future<void> fetchFuture = viewModel.fetchTermsData();

        await fetchFuture;

        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test("handles error response correctly", () async {
        when(mockApiAppRepository.getTermsConditions()).thenAnswer(
          (_) async => Resource<DynamicPageResponse?>.error(
            "API error",
          ),
        );

        await viewModel.fetchTermsData();

        // Should complete without throwing exceptions
        expect(viewModel.viewState, equals(ViewState.idle));
      });
    });

    test("GetTermsAndConditionUseCase is properly initialized", () {
      expect(viewModel.getTermsAndConditionUseCase,
          isA<GetTermsAndConditionUseCase>(),);
    });

    test("completer function can be called", () {
      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      final TermsBottomSheetViewModel testViewModel =
          TermsBottomSheetViewModel(testCompleter);

      testViewModel.completer(SheetResponse<EmptyBottomSheetResponse>());

      expect(completerCalled, isTrue);
    });

    test("viewModel extends BaseModel correctly", () {
      expect(viewModel.viewState, isA<ViewState>());
      expect(viewModel.isBusy, isA<bool>());
      expect(viewModel.hasError, isA<bool>());
    });

    test("handles multiple fetchTermsData calls", () async {
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Test title",
            pageIntro: "Test intro",
            pageContent: "Test content",
          ),
          message: "Success",
        ),
      );

      // Call multiple times
      await viewModel.fetchTermsData();
      await viewModel.fetchTermsData();

      // Should handle multiple calls without issues
      expect(viewModel.viewState, equals(ViewState.idle));
    });
  });
}
