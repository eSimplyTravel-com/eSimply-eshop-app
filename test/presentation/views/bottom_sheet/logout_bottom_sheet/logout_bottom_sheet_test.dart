import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/logout_bottom_sheet/logout_bottom_sheet.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
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
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("LogoutBottomSheet Widget Tests", () {
    testWidgets("renders basic structure", (WidgetTester tester) async {
      // Arrange
      onViewModelReadyMock(viewName: "LogoutBottomSheet");

      bool completerCalled = false;
      void completerFunction(
          SheetResponse<EmptyBottomSheetResponse> response,) {
        completerCalled = true;
      }

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          LogoutBottomSheet(
            requestBase: request,
            completer: completerFunction,
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(LogoutBottomSheet), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(MainButton), findsWidgets);
      expect(completerCalled, isFalse);
    });

    testWidgets("close button onTap callback is set up correctly",
        (WidgetTester tester) async {
      // Arrange
      onViewModelReadyMock(viewName: "LogoutBottomSheet");

      bool completerCalled = false;
      SheetResponse<EmptyBottomSheetResponse>? completerResponse;

      void completerFunction(
          SheetResponse<EmptyBottomSheetResponse> response,) {
        completerCalled = true;
        completerResponse = response;
      }

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      await tester.pumpWidget(
        createTestableWidget(
          LogoutBottomSheet(
            requestBase: request,
            completer: completerFunction,
          ),
        ),
      );
      await tester.pump();

      // Assert - BottomSheetCloseButton is rendered with onTap callback
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);

      // Find the BottomSheetCloseButton widget and verify it has onTap
      final BottomSheetCloseButton closeButton =
          tester.widget(find.byType(BottomSheetCloseButton));
      expect(closeButton.onTap, isNotNull);

      // Call the onTap callback directly to test it
      closeButton.onTap();

      // Verify completer was called with correct response
      expect(completerCalled, isTrue);
      expect(completerResponse, isNotNull);
      // confirmed can be false or null when not explicitly set to true
      expect(completerResponse!.confirmed, isNot(equals(true)));
    });

    testWidgets("cancel button onPressed callback is set up correctly",
        (WidgetTester tester) async {
      // Arrange
      onViewModelReadyMock(viewName: "LogoutBottomSheet");

      bool completerCalled = false;
      SheetResponse<EmptyBottomSheetResponse>? completerResponse;

      void completerFunction(
          SheetResponse<EmptyBottomSheetResponse> response,) {
        completerCalled = true;
        completerResponse = response;
      }

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      await tester.pumpWidget(
        createTestableWidget(
          LogoutBottomSheet(
            requestBase: request,
            completer: completerFunction,
          ),
        ),
      );
      await tester.pump();

      // Find the cancel button (second MainButton)
      final Finder cancelButtons = find.byType(MainButton);
      expect(cancelButtons, findsWidgets);
      expect(cancelButtons.evaluate().length, equals(2));

      // Get the cancel button widget (last MainButton)
      final MainButton cancelButton = tester.widget(cancelButtons.last);
      expect(cancelButton.onPressed, isNotNull);

      // Call the onPressed callback directly to test it
      cancelButton.onPressed();

      // Verify completer was called with correct response
      expect(completerCalled, isTrue);
      expect(completerResponse, isNotNull);
      // confirmed can be false or null when not explicitly set to true
      expect(completerResponse!.confirmed, isNot(equals(true)));
    });

    testWidgets("logout button onPressed callback is set up correctly",
        (WidgetTester tester) async {
      // Arrange
      onViewModelReadyMock(viewName: "LogoutBottomSheet");

      // Mock the logout API call
      final MockApiAuthRepository mockApiAuthRepository =
          locator<ApiAuthRepository>() as MockApiAuthRepository;
      when(mockApiAuthRepository.logout()).thenAnswer(
        (_) async => Resource<EmptyResponse>.success(
          EmptyResponse(),
          message: "Success",
        ),
      );

      bool completerCalled = false;
      SheetResponse<EmptyBottomSheetResponse>? completerResponse;

      void completerFunction(
          SheetResponse<EmptyBottomSheetResponse> response,) {
        completerCalled = true;
        completerResponse = response;
      }

      final SheetRequest<dynamic> request = SheetRequest<dynamic>();

      await tester.pumpWidget(
        createTestableWidget(
          LogoutBottomSheet(
            requestBase: request,
            completer: completerFunction,
          ),
        ),
      );
      await tester.pump();

      // Find the logout button (first MainButton)
      final Finder logoutButtons = find.byType(MainButton);
      expect(logoutButtons, findsWidgets);
      expect(logoutButtons.evaluate().length, equals(2));

      // Get the logout button widget (first MainButton)
      final MainButton logoutButton = tester.widget(logoutButtons.first);
      expect(logoutButton.onPressed, isNotNull);

      // Call the onPressed callback directly to test it
      logoutButton.onPressed();
      await tester.pump();

      // Verify completer was called with correct response
      expect(completerCalled, isTrue);
      expect(completerResponse, isNotNull);
      expect(completerResponse!.confirmed, isTrue);

      // Verify logout API was called
      verify(mockApiAuthRepository.logout()).called(1);
    });

    testWidgets("debug properties", (WidgetTester tester) async {
      // Arrange
      final SheetRequest<dynamic> request = SheetRequest<dynamic>();
      void completerFunction(
          SheetResponse<EmptyBottomSheetResponse> response,) {}

      final LogoutBottomSheet widget = LogoutBottomSheet(
        requestBase: request,
        completer: completerFunction,
      );

      final DiagnosticPropertiesBuilder builder =
          DiagnosticPropertiesBuilder();

      // Act
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;

      // Assert
      expect(props, isNotEmpty);
      expect(
        props.any((DiagnosticsNode p) => p.name == "requestBase"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "completer"),
        isTrue,
      );
    });
  });
}
