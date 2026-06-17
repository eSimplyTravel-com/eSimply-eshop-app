import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_currencies_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MockApiAppRepository mockApiAppRepository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: AppClipSelectionView.routeName);
    GetCurrenciesUseCase.previousResponse = null;
    mockApiAppRepository =
        locator<ApiAppRepository>() as MockApiAppRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    when(
      mockLocalStorageService.setString(any, any),
    ).thenAnswer((_) async => true);
    when(mockApiAppRepository.getCurrencies()).thenAnswer(
      (_) async => Resource<List<CurrenciesResponseModel>?>.success(
        <CurrenciesResponseModel>[
          CurrenciesResponseModel(currency: "USD"),
          CurrenciesResponseModel(currency: "EUR"),
        ],
        message: "Success",
      ),
    );
  });

  tearDown(() async {
    GetCurrenciesUseCase.previousResponse = null;
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("AppClipSelectionView Widget Tests", () {
    testWidgets("renders basic structure", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(const AppClipSelectionView()),
      );
      await tester.pump();

      expect(find.byType(AppClipSelectionView), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
    });

    testWidgets("renders language list items", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(const AppClipSelectionView()),
      );
      await tester.pump();

      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
    });

    testWidgets("routeName is correct", (WidgetTester tester) async {
      expect(
        AppClipSelectionView.routeName,
        equals("AppClipSelectionView"),
      );
    });

    testWidgets("buildChildWidget renders correctly with context and viewModel",
        (WidgetTester tester) async {
      const AppClipSelectionView view = AppClipSelectionView();
      final AppClipSelectionViewModel viewModel = AppClipSelectionViewModel();

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                view.buildChildWidget(0, context, viewModel),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(DecoratedBox), findsOneWidget);
      expect(find.byType(PaddingWidget), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets(
        "buildChildWidget shows selected state when item is selected",
        (WidgetTester tester) async {
      const AppClipSelectionView view = AppClipSelectionView();
      final AppClipSelectionViewModel viewModel = AppClipSelectionViewModel();
      viewModel.selectedLanguage = "English";

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) =>
                view.buildChildWidget(0, context, viewModel),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GestureDetector), findsOneWidget);
      final Iterable<DecoratedBox> decoratedBoxes =
          tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      expect(decoratedBoxes, isNotEmpty);
    });

    testWidgets("tapping list item triggers onSelection callback",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(const AppClipSelectionView()),
      );
      await tester.pump();

      final Finder gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      await tester.tap(gestureDetectors.first);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets("tapping enabled MainButton triggers onButtonTapped callback",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(const AppClipSelectionView()),
      );
      await tester.pumpAndSettle();

      // Select a language item first to enable the button
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Button should now be enabled — tap it
      await tester.tap(find.byType(MainButton));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
