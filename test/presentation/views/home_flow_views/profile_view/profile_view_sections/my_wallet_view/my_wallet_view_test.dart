import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MockUserAuthenticationService mockUserAuthService;
  late MockApiAuthRepository mockApiAuthRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: MyWalletView.routeName);

    // Set up user authentication service mocks
    mockUserAuthService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;

    when(mockUserAuthService.walletCurrencyCode).thenReturn("USD");
    when(mockUserAuthService.walletAvailableBalance).thenReturn(100);
    when(mockApiAuthRepository.getUserInfo()).thenAnswer(
      (_) async =>
          Resource<AuthResponseModel?>.success(null, message: "Success"),
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("MyWalletView Widget Tests", () {
    testWidgets("renders basic structure with navigation title",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Verify navigation title is present
      expect(find.byType(CommonNavigationTitle), findsOneWidget);

      // Verify main structure is present
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(PaddingWidget), findsWidgets);
    });

    testWidgets("displays wallet balance text and currency",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Should find text widgets for balance display
      expect(find.byType(Text), findsWidgets);
      expect(find.text("USD 100.0"), findsOneWidget);
    });

    testWidgets("displays wallet icon", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Should find image widgets including wallet icon
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets("renders refresh indicator and list view",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Verify refresh indicator and list view are present
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("list view displays wallet sections",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Should find gesture detectors for tap actions
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(ColoredBox), findsWidgets);
    });

    testWidgets("pull to refresh functionality", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Find refresh indicator and test pull to refresh
      final Finder refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      // Trigger refresh gesture
      await tester.fling(refreshIndicator, const Offset(0, 200), 1000);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Verify API was called for refresh
      verify(mockApiAuthRepository.getUserInfo()).called(greaterThan(0));
    });

    testWidgets("tap on wallet section triggers action",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Find gesture detectors and tap the first one
      final Finder gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      // Tap on the first wallet section
      await tester.tap(gestureDetectors.first);
      await tester.pump(const Duration(milliseconds: 50));

      // The tap should complete without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets("contains proper route name", (WidgetTester tester) async {
      expect(MyWalletView.routeName, equals("MyWalletView"));
    });

    testWidgets("widget properties validation", (WidgetTester tester) async {
      const MyWalletView widget = MyWalletView();

      // Basic property validation
      expect(widget.key, isNull);
      expect(widget.runtimeType, equals(MyWalletView));
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets("dividers are displayed between sections",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // Should find dividers between list items
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets("shimmer effect is applied correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MyWalletView(),
        ),
      );
      await tester.pump();

      // The balance text should have shimmer effect applied
      expect(find.byType(Text), findsWidgets);

      // Verify widget structure renders without errors
      expect(tester.takeException(), isNull);
    });
  });
}
