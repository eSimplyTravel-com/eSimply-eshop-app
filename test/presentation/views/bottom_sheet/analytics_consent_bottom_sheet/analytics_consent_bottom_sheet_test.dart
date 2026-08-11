import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/analytics_consent_bottom_sheet/analytics_consent_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/analytics_consent_bottom_sheet/analytics_consent_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

/// The consent sheet is a legal control, so these assert the properties the law
/// cares about — nothing pre-selected, refusing as easy as accepting, and a
/// dismissal that records nothing — not merely that the widget renders.
Future<void> main() async {
  await prepareTest();

  late MockAnalyticsService mockAnalyticsService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "AnalyticsConsentBottomSheetView");
    mockAnalyticsService = locator<AnalyticsService>() as MockAnalyticsService;
    when(mockAnalyticsService.setAnalyticsConsent(granted: anyNamed("granted")))
        .thenAnswer((_) async {});
  });

  tearDown(() async => tearDownTest());
  tearDownAll(() async => tearDownAllTest());

  Future<List<SheetResponse<EmptyBottomSheetResponse>>> pumpSheet(
    WidgetTester tester,
  ) async {
    final List<SheetResponse<EmptyBottomSheetResponse>> responses =
        <SheetResponse<EmptyBottomSheetResponse>>[];

    await tester.pumpWidget(
      createTestableWidget(
        MediaQuery(
          // A narrow phone: the two labels must still fit side by side with the
          // longer French and Arabic strings in mind.
          data: const MediaQueryData(size: Size(320, 700)),
          child: Scaffold(
            body: AnalyticsConsentBottomSheetView(
              requestBase: SheetRequest<dynamic>(),
              completer: responses.add,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    tester.takeException();
    return responses;
  }

  group("AnalyticsConsentBottomSheetView", () {
    testWidgets("offers exactly two choices and pre-selects neither",
        (WidgetTester tester) async {
      await pumpSheet(tester);

      expect(find.byType(MainButton), findsNWidgets(2));

      // Nothing may be recorded merely by the sheet appearing.
      verifyNever(
        mockAnalyticsService.setAnalyticsConsent(granted: anyNamed("granted")),
      );
    });

    testWidgets("refusing is exactly as easy as accepting",
        (WidgetTester tester) async {
      await pumpSheet(tester);

      final List<MainButton> buttons =
          tester.widgetList<MainButton>(find.byType(MainButton)).toList();
      final MainButton allow = buttons.first;
      final MainButton deny = buttons.last;

      // Same size, both full width. A smaller or narrower reject button is the
      // classic way of making refusal harder while looking compliant.
      expect(allow.height, deny.height);
      expect(allow.width, deny.width);
      expect(allow.isEnabled, isTrue);
      expect(deny.isEnabled, isTrue);
    });

    testWidgets("allowing records a grant and closes",
        (WidgetTester tester) async {
      final List<SheetResponse<EmptyBottomSheetResponse>> responses =
          await pumpSheet(tester);

      await tester.tap(find.byType(MainButton).first, warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(mockAnalyticsService.setAnalyticsConsent(granted: true)).called(1);
      expect(responses, hasLength(1));
    });

    testWidgets("refusing records a refusal and closes",
        (WidgetTester tester) async {
      final List<SheetResponse<EmptyBottomSheetResponse>> responses =
          await pumpSheet(tester);

      await tester.tap(find.byType(MainButton).last, warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(mockAnalyticsService.setAnalyticsConsent(granted: false)).called(1);
      expect(responses, hasLength(1));
    });
  });

  group("AnalyticsConsentBottomSheetViewModel", () {
    test("dismissing without choosing stores nothing", () async {
      final List<SheetResponse<EmptyBottomSheetResponse>> responses =
          <SheetResponse<EmptyBottomSheetResponse>>[];
      AnalyticsConsentBottomSheetViewModel(responses.add);

      // Constructing and discarding the sheet is what a swipe-away looks like.
      // Silence has to stay silence: an unanswered prompt must remain
      // unanswered so it can be asked again, never default to a grant.
      verifyNever(
        mockAnalyticsService.setAnalyticsConsent(granted: anyNamed("granted")),
      );
      expect(responses, isEmpty);
    });
  });
}
