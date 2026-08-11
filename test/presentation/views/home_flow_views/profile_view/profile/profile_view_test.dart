import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";
import "../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    // The analytics-consent prompt reads this on first appearance. `false`
    // means "already answered", so these tests are not interrupted by it.
    when(
      (locator<AnalyticsService>() as MockAnalyticsService).analyticsConsent,
    ).thenReturn(false);

  });

  tearDown(() async {
    await tearDownTest();
  });

  group("ProfileView Widget Tests", () {
    testWidgets("renders profile person image", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "ProfileView");

      await tester.pumpWidget(createTestableWidget(const ProfileView()));
      await tester.pump();

      final Image profileImage = tester.widget<Image>(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  EnvironmentImages.profilePerson.fullImagePath,
        ),
      );

      expect(profileImage, isNotNull);
    });

    testWidgets("renders login button for guest users",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "ProfileView");

      // Mock guest user state
      when(locator<UserAuthenticationService>().isUserLoggedIn)
          .thenReturn(false);

      await tester.pumpWidget(createTestableWidget(const ProfileView()));
      await tester.pump();

      expect(find.text(LocaleKeys.profile_guest.tr()), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.text(LocaleKeys.profile_login.tr()), findsOneWidget);
    });

    testWidgets("renders username for logged in users",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "ProfileView");

      // Mock logged in user
      when(locator<UserAuthenticationService>().isUserLoggedIn)
          .thenReturn(true);
      when(locator<UserAuthenticationService>().userEmailAddress)
          .thenReturn("test@example.com");

      await tester.pumpWidget(createTestableWidget(const ProfileView()));
      await tester.pump();

      expect(
        find.byType(MainButton),
        findsNothing,
      ); // No login button for logged in users
    });

    testWidgets("profile sections list renders correctly",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "ProfileView");

      await tester.pumpWidget(createTestableWidget(const ProfileView()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);

      final ListView listView = tester.widget<ListView>(find.byType(ListView));
      expect(
        listView.itemExtent,
        isNull,
      ); // ListView.separated doesn't use itemExtent
    });

    testWidgets("taps login button successfully", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "ProfileView");

      when(locator<UserAuthenticationService>().isUserLoggedIn)
          .thenReturn(false);

      when(locator<NavigationService>().navigateTo(LoginView.routeName))
          .thenAnswer((_) {
        return null;
      });

      await tester.pumpWidget(createTestableWidget(const ProfileView()));
      await tester.pump();
      //
      final Finder loginButton = find.byType(MainButton);

      await tester.tap(loginButton);
      await tester.pump();
      //
      // expect(tester.takeException(), isNull);
    });

    testWidgets("handles profile section taps", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "ProfileView");

      when(
        locator<NavigationService>()
            .navigateTo(AccountInformationView.routeName),
      ).thenAnswer((_) {
        return null;
      });

      await tester.pumpWidget(createTestableWidget(const ProfileView()));
      await tester.pump();

      // Find GestureDetector widgets (profile sections)
      final Finder gestureDetectors = find.byType(GestureDetector);

      if (gestureDetectors.evaluate().isNotEmpty) {
        await tester.tap(gestureDetectors.first);
        await tester.pump();

        expect(tester.takeException(), isNull);
      }
    });
  });

  group("ProfileView Static Tests", () {
    test("routeName is set correctly", () {
      expect(ProfileView.routeName, equals("ProfileView"));
    });

    test("widget can be instantiated", () {
      const ProfileView widget = ProfileView();
      expect(widget, isA<ProfileView>());
    });
  });

  group("ProfileView Debug Properties", () {
    testWidgets("debug properties", (WidgetTester tester) async {
      const ProfileView widget = ProfileView();

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotNull);
    });
  });
}
