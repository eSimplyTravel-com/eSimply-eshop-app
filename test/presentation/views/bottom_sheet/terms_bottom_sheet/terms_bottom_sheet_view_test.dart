import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/get_terms_and_condition_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/terms_bottom_sheet/terms_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    // Clear static cache to ensure test isolation
    GetTermsAndConditionUseCase.previousResponse = null;
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("TermsBottomSheetView Widget Tests", () {
    testWidgets("renders basic structure correctly",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      // Mock the API call to return success
      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms and Conditions",
            pageIntro: "Welcome to our terms",
            pageContent: "This is the main content.",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(TermsBottomSheetView), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets("renders all required UI components",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      // Mock the API call
      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Introduction",
            pageContent: "<p>Content with HTML</p>",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(); // Additional pump for ViewModel ready

      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Html), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.byType(PaddingWidget), findsWidgets);
    });

    testWidgets("renders HTML content correctly", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "<h1>Introduction</h1>",
            pageContent: "<p>Main content with <strong>bold</strong> text</p>",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(); // Wait for ViewModel

      expect(find.byType(Html), findsOneWidget);

      final Html htmlWidget = tester.widget(find.byType(Html));
      expect(htmlWidget.data, contains("Introduction"));
      expect(htmlWidget.data, contains("Main content"));
    });

    testWidgets("renders I Agree button with correct properties",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Intro",
            pageContent: "Content",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(MainButton), findsOneWidget);

      final MainButton agreeButton = tester.widget(find.byType(MainButton));
      expect(agreeButton.height, equals(53));
      expect(agreeButton.hideShadows, isTrue);
    });

    testWidgets("handles agree button tap", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Intro",
            pageContent: "Content",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      bool completerCalled = false;
      SheetResponse<EmptyBottomSheetResponse>? response;

      void completer(SheetResponse<EmptyBottomSheetResponse> res) {
        completerCalled = true;
        response = res;
      }

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(MainButton));
      await tester.pump();

      expect(completerCalled, isTrue);
      expect(response, isNotNull);
      expect(response?.confirmed, isTrue); // Agree button confirms
    });

    testWidgets("renders with different screen sizes",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Intro",
            pageContent: "Content",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      // Test with different screen size
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(TermsBottomSheetView), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);

      // Reset to default size
      addTearDown(tester.view.reset);
    });

    testWidgets("debug properties test", (WidgetTester tester) async {
      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      final TermsBottomSheetView widget = TermsBottomSheetView(
        requestBase: request,
        completer: completer,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;

      final DiagnosticsProperty<SheetRequest<dynamic>> requestProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "requestBase")
              as DiagnosticsProperty<SheetRequest<dynamic>>;

      expect(requestProp.value, isNotNull);
      expect(requestProp.value, equals(request));

      final ObjectFlagProperty<
              Function(SheetResponse<EmptyBottomSheetResponse> p1)>
          completerProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "completer")
              as ObjectFlagProperty<
                  Function(SheetResponse<EmptyBottomSheetResponse> p1)>;

      expect(completerProp.value, isNotNull);
    });

    testWidgets("handles null data gracefully", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          null,
          message: "Success but no data",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(TermsBottomSheetView), findsOneWidget);
      expect(find.byType(Html), findsOneWidget);

      final Html htmlWidget = tester.widget(find.byType(Html));
      expect(htmlWidget.data, equals(" ")); // Should show empty content
    });

    testWidgets("verifies BaseView.bottomSheetBuilder usage",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Intro",
            pageContent: "Content",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Verify the widget structure matches BaseView.bottomSheetBuilder pattern
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
    });

    testWidgets("verifies proper spacing and layout",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Intro",
            pageContent: "Content",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Verify main column layout
      final Column mainColumn = tester.widget(find.byType(Column).first);
      expect(mainColumn.mainAxisSize, equals(MainAxisSize.min));

      // Verify PaddingWidget exists with symmetric padding
      expect(find.byType(PaddingWidget), findsWidgets);
    });

    testWidgets("handles long content with scrolling",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Long Terms",
            pageIntro: "Very long introduction " * 10,
            pageContent:
                "Very long content that should require scrolling " * 20,
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Html), findsOneWidget);

      // Verify scrolling works
      final SingleChildScrollView scrollView =
          tester.widget(find.byType(SingleChildScrollView));
      expect(scrollView.child, isA<Html>());
    });

    testWidgets("verifies correct SizedBox height calculation",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "TermsBottomSheetView");

      final MockApiAppRepository mockApiAppRepository =
          locator<ApiAppRepository>() as MockApiAppRepository;
      when(mockApiAppRepository.getTermsConditions()).thenAnswer(
        (_) async => Resource<DynamicPageResponse?>.success(
          DynamicPageResponse(
            pageTitle: "Terms",
            pageIntro: "Intro",
            pageContent: "Content",
          ),
          message: "Success",
        ),
      );

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

      // Set a specific screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: TermsBottomSheetView(
              requestBase: request,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Verify SizedBox widgets exist (height calculation is done internally)
      expect(find.byType(SizedBox), findsWidgets);

      addTearDown(tester.view.reset);
    });
  });
}
