import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_qr_code/qr_code_bottom_sheet.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();

  final SheetRequest<BundleQrBottomRequest> requestWithData =
      SheetRequest<BundleQrBottomRequest>(
    data: const BundleQrBottomRequest(
      iccID: "test-icc-id",
      smDpAddress: "test.smdp.address.com",
      activationCode: "test-activation-code-123",
    ),
  );

  void completer(SheetResponse<MainBottomSheetResponse> response) {}

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "ESimQrBottomSheet");
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("ESimQrBottomSheet Widget Tests", () {
    testWidgets("renders basic structure with smDpAddress set",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ESimQrBottomSheet(
              request: requestWithData,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ESimQrBottomSheet), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
    });

    testWidgets("displays localized texts", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ESimQrBottomSheet(
              request: requestWithData,
              completer: completer,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(LocaleKeys.qr_code_details.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.goToSettings.tr()), findsOneWidget);
    });

    testWidgets("tapping close button invokes completer",
        (WidgetTester tester) async {
      bool completerCalled = false;
      void testCompleter(SheetResponse<MainBottomSheetResponse> response) {
        completerCalled = true;
      }

      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ESimQrBottomSheet(
              request: requestWithData,
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(
        find.descendant(
          of: find.byType(BottomSheetCloseButton),
          matching: find.byType(InkWell),
        ),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(completerCalled, isTrue);
    });

    testWidgets("buildInfoRow renders label and value",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) => buildInfoRow(
                context: context,
                label: "SM-DP+ Address",
                value: "test.smdp.com",
                isLoading: false,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("SM-DP+ Address"), findsOneWidget);
      expect(find.text("test.smdp.com"), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets("buildInfoRow shows placeholder dashes when loading and empty",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) => buildInfoRow(
                context: context,
                label: "Activation Code",
                value: "",
                isLoading: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("------------"), findsOneWidget);
    });

    testWidgets("buildInfoRow copy button is tappable",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) => buildInfoRow(
                context: context,
                label: "Label",
                value: "some-value",
                isLoading: false,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets("debug properties", (WidgetTester tester) async {
      final ESimQrBottomSheet widget = ESimQrBottomSheet(
        request: requestWithData,
        completer: completer,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;

      final DiagnosticsProperty<SheetRequest<BundleQrBottomRequest>>
          requestProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "request")
              as DiagnosticsProperty<SheetRequest<BundleQrBottomRequest>>;

      final ObjectFlagProperty<
              Function(SheetResponse<MainBottomSheetResponse>)> completerProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "completer")
              as ObjectFlagProperty<
                  Function(SheetResponse<MainBottomSheetResponse>)>;

      expect(requestProp.value, equals(requestWithData));
      expect(completerProp.value, equals(completer));
    });
  });
}
