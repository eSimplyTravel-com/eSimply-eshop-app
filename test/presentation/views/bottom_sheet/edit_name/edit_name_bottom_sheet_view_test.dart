import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/edit_name/edit_name_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/edit_name/edit_name_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  late MockEditNameBottomSheetViewModel mockViewModel;

  setUpAll(() async {
    await prepareTest();
  });

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "EditNameBottomSheetView");

    mockViewModel = MockEditNameBottomSheetViewModel();
    if (locator.isRegistered<EditNameBottomSheetViewModel>()) {
      await locator.unregister<EditNameBottomSheetViewModel>();
    }
    locator.registerSingleton<EditNameBottomSheetViewModel>(mockViewModel);

    when(mockViewModel.isBusy).thenReturn(false);
    when(mockViewModel.viewState).thenReturn(ViewState.idle);
    when(mockViewModel.controller).thenReturn(TextEditingController());
    when(mockViewModel.isButtonEnabled).thenReturn(false);
    when(mockViewModel.request).thenReturn(
      SheetRequest<BundleEditNameRequest>(
        data: BundleEditNameRequest(name: "Test Name"),
      ),
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("EditNameBottomSheetView Tests", () {
    testWidgets("renders basic structure with all UI elements",
        (WidgetTester tester) async {
      void mockCompleter(SheetResponse<MainBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EditNameBottomSheetView(
              request: SheetRequest<BundleEditNameRequest>(
                data: BundleEditNameRequest(name: "Test Name"),
              ),
              completer: mockCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EditNameBottomSheetView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.byType(MainInputField), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
    });

    testWidgets("renders with button enabled when isButtonEnabled is true",
        (WidgetTester tester) async {
      when(mockViewModel.isButtonEnabled).thenReturn(true);

      void mockCompleter(SheetResponse<MainBottomSheetResponse> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EditNameBottomSheetView(
              request: SheetRequest<BundleEditNameRequest>(
                data: BundleEditNameRequest(name: "John Doe"),
              ),
              completer: mockCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final MainButton button = tester.widget<MainButton>(find.byType(MainButton));
      expect(button.isEnabled, isTrue);
    });

    test("debugFillProperties adds request and completer properties", () {
      void mockCompleter(SheetResponse<MainBottomSheetResponse> response) {}

      final SheetRequest<BundleEditNameRequest> request =
          SheetRequest<BundleEditNameRequest>(
        data: BundleEditNameRequest(name: "Debug Test"),
      );

      final EditNameBottomSheetView view = EditNameBottomSheetView(
        request: request,
        completer: mockCompleter,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      view.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;
      expect(
        properties.any((DiagnosticsNode node) => node.name == "request"),
        isTrue,
      );
      expect(
        properties.any((DiagnosticsNode node) => node.name == "completer"),
        isTrue,
      );
    });

    test("view properties are set correctly", () {
      void mockCompleter(SheetResponse<MainBottomSheetResponse> response) {}

      final SheetRequest<BundleEditNameRequest> request =
          SheetRequest<BundleEditNameRequest>(
        data: BundleEditNameRequest(name: "Test User"),
      );

      final EditNameBottomSheetView view = EditNameBottomSheetView(
        request: request,
        completer: mockCompleter,
      );

      expect(view.request, equals(request));
      expect(view.completer, equals(mockCompleter));
      expect(view.request.data?.name, equals("Test User"));
    });

    test("completer is callable and receives response", () {
      SheetResponse<MainBottomSheetResponse>? capturedResponse;

      void testCompleter(SheetResponse<MainBottomSheetResponse> response) {
        capturedResponse = response;
      }

      final EditNameBottomSheetView view = EditNameBottomSheetView(
        request: SheetRequest<BundleEditNameRequest>(),
        completer: testCompleter,
      );

      view.completer(SheetResponse<MainBottomSheetResponse>());
      expect(capturedResponse, isNotNull);
    });
  });
}
