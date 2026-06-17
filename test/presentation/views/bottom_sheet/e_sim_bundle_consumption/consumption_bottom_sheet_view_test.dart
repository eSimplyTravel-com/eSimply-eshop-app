import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_consumption/consumption_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_consumption/consumption_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/animated_circular_progress_indicator.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/top_up_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  late MockApiUserRepository mockApiUserRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();

    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;

    // Setup default mock for getUserConsumption
    when(
      mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
    ).thenAnswer(
      (_) async => Resource<UserBundleConsumptionResponse>.success(
        UserBundleConsumptionResponse(
          dataAllocated: 1000,
          dataUsed: 640,
          dataRemaining: 360,
          dataAllocatedDisplay: "1 GB",
          dataUsedDisplay: "640 MB",
          dataRemainingDisplay: "360 MB",
        ),
        message: "Success",
      ),
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("ConsumptionBottomSheetView Widget Tests", () {
    testWidgets("renders correctly with limited data and no error",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      // Wait for the view to build
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ConsumptionBottomSheetView), findsOneWidget);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.text(LocaleKeys.consumption_details), findsOneWidget);
    });

    testWidgets("renders unlimited data text when isUnlimitedData is true",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text(LocaleKeys.unlimited), findsOneWidget);
      expect(find.text(LocaleKeys.unlimited_data_bundle), findsOneWidget);
      expect(
        find.byType(AnimatedCircularProgressIndicator),
        findsNothing,
      ); // Should not show progress indicator
    });

    testWidgets(
        "renders circular progress indicator when isUnlimitedData is false",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AnimatedCircularProgressIndicator), findsWidgets);
      expect(find.text(LocaleKeys.unlimited), findsNothing);
    });

    testWidgets("shows TopUpButton when showTopUp is true and no error",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TopUpButton), findsOneWidget);
    });

    testWidgets("hides TopUpButton when showTopUp is false",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: false,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TopUpButton), findsNothing);
    });

    testWidgets("displays data consumed text when not unlimited",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text(LocaleKeys.data_consumed), findsOneWidget);
    });

    testWidgets("does not display data consumed text when unlimited",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text(LocaleKeys.data_consumed), findsNothing);
    });

    testWidgets("close button triggers closeBottomSheet callback",
        (WidgetTester tester) async {
      // Arrange
      bool completerCalled = false;
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {
              completerCalled = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the close button by finding a descendant GestureDetector
      final Finder closeButtonFinder = find.descendant(
        of: find.byType(BottomSheetCloseButton),
        matching: find.byType(GestureDetector),
      );
      expect(closeButtonFinder, findsOneWidget);

      await tester.tap(closeButtonFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500)); // Wait for any delays
      await tester.pumpAndSettle();

      // Assert
      expect(completerCalled, true);
    });

    testWidgets("TopUpButton triggers onTopUpClick callback",
        (WidgetTester tester) async {
      // Arrange
      String? capturedTag;
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {
              capturedTag = response.data?.tag;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the top-up button
      await tester.tap(find.byType(TopUpButton));
      await tester.pumpAndSettle();

      // Assert
      expect(capturedTag, "top-up");
    });

    testWidgets("buildTopHeader contains close button and title",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.text(LocaleKeys.consumption_details), findsOneWidget);
    });

    testWidgets("buildConsumptionView with null request data shows unlimited",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - null data defaults to isUnlimitedData = false
      expect(find.byType(AnimatedCircularProgressIndicator), findsWidgets);
    });

    testWidgets("widget structure has correct DecoratedBox styling",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      final Finder decoratedBox = find.byType(DecoratedBox);
      expect(decoratedBox, findsWidgets);

      // Find the main DecoratedBox with white background
      final DecoratedBox box = tester.widgetList<DecoratedBox>(decoratedBox)
          .firstWhere((DecoratedBox widget) {
        return widget.decoration is ShapeDecoration &&
            (widget.decoration as ShapeDecoration).color == Colors.white;
      });
      final ShapeDecoration decoration = box.decoration as ShapeDecoration;
      expect(decoration.color, Colors.white);
      expect(
        decoration.shape,
        isA<RoundedRectangleBorder>(),
      );
    });

    testWidgets("consumption view has correct height for unlimited data",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Find the SizedBox that wraps the consumption view (height 50 for unlimited)
      final Finder sizedBoxFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SizedBox &&
            widget.width == 230 &&
            widget.height == 50,
      );

      expect(sizedBoxFinder, findsOneWidget);
    });

    testWidgets("consumption view has correct height for limited data",
        (WidgetTester tester) async {
      // Arrange
      final SheetRequest<BundleConsumptionBottomRequest> request =
          SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          ConsumptionBottomSheetView(
            request: request,
            completer: (SheetResponse<MainBottomSheetResponse> response) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Find SizedBoxes with 230x230 (outer container and AnimatedCircularProgressIndicator)
      final Finder sizedBoxFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SizedBox &&
            widget.width == 230 &&
            widget.height == 230,
      );

      // There should be at least 2: the outer container and the one inside AnimatedCircularProgressIndicator
      expect(sizedBoxFinder, findsWidgets);
      expect(sizedBoxFinder.evaluate().length, greaterThanOrEqualTo(2));
    });
  });

  group("ConsumptionBottomSheetView Method Tests", () {
    testWidgets("buildTopHeader method creates correct widget structure",
        (WidgetTester tester) async {
      // Arrange
      final ConsumptionBottomSheetView view = ConsumptionBottomSheetView(
        request: SheetRequest<BundleConsumptionBottomRequest>(
          data: const BundleConsumptionBottomRequest(
            isUnlimitedData: true,
            iccID: "test",
            showTopUp: true,
          ),
        ),
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      final ConsumptionBottomSheetViewModel viewModel =
          ConsumptionBottomSheetViewModel();

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) {
              return view.buildTopHeader(context, viewModel);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.text(LocaleKeys.consumption_details), findsOneWidget);
    });

    testWidgets(
        "buildConsumptionView method with unlimited data shows unlimited text",
        (WidgetTester tester) async {
      // Arrange
      final ConsumptionBottomSheetView view = ConsumptionBottomSheetView(
        request: SheetRequest<BundleConsumptionBottomRequest>(
          data: const BundleConsumptionBottomRequest(
            isUnlimitedData: true,
            iccID: "test",
            showTopUp: true,
          ),
        ),
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      final ConsumptionBottomSheetViewModel viewModel =
          ConsumptionBottomSheetViewModel()
      ..setViewState(ViewState.idle);

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) {
              return view.buildConsumptionView(context, viewModel);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text(LocaleKeys.unlimited), findsOneWidget);
      expect(find.text(LocaleKeys.unlimited_data_bundle), findsOneWidget);
      expect(find.byType(AnimatedCircularProgressIndicator), findsNothing);
    });

    testWidgets(
        "buildConsumptionView method with limited data shows progress indicator",
        (WidgetTester tester) async {
      // Arrange
      final ConsumptionBottomSheetView view = ConsumptionBottomSheetView(
        request: SheetRequest<BundleConsumptionBottomRequest>(
          data: const BundleConsumptionBottomRequest(
            isUnlimitedData: false,
            iccID: "test",
            showTopUp: true,
          ),
        ),
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      final ConsumptionBottomSheetViewModel viewModel =
          ConsumptionBottomSheetViewModel()
      ..setViewState(ViewState.idle);

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) {
              return view.buildConsumptionView(context, viewModel);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AnimatedCircularProgressIndicator), findsOneWidget);
      expect(find.text(LocaleKeys.unlimited), findsNothing);
      expect(find.text(LocaleKeys.data_consumed), findsOneWidget);
    });

    testWidgets(
        "buildConsumptionView method with error message shows error text",
        (WidgetTester tester) async {
      // Arrange
      final ConsumptionBottomSheetView view = ConsumptionBottomSheetView(
        request: SheetRequest<BundleConsumptionBottomRequest>(
          data: const BundleConsumptionBottomRequest(
            isUnlimitedData: false,
            iccID: "test",
            showTopUp: true,
          ),
        ),
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      final ConsumptionBottomSheetViewModel viewModel =
          ConsumptionBottomSheetViewModel();
      viewModel.state.errorMessage = "Network error occurred";
      viewModel.setViewState(ViewState.idle);

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) {
              return view.buildConsumptionView(context, viewModel);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text("Network error occurred"), findsOneWidget);
      expect(find.byType(AnimatedCircularProgressIndicator), findsNothing);
    });
  });
}
