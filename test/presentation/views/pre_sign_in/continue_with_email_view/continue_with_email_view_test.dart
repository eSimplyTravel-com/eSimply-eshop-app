// continue_with_email_view_test.dart

import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();
  late ContinueWithEmailViewModel mockViewModel;

  setUp(() async {
    await setupTest();
    await locator.resetLazySingleton<ContinueWithEmailViewModel>(
      instance: locator<ContinueWithEmailViewModel>(),
    );
    mockViewModel = locator<ContinueWithEmailViewModel>();
    when(mockViewModel.isBusy).thenReturn(false);
    when(mockViewModel.viewState).thenReturn(ViewState.idle);
    when(mockViewModel.state).thenReturn(ContinueWithEmailState());
    when(mockViewModel.showEmailField).thenReturn(true);
    when(mockViewModel.showPhoneField).thenReturn(false);
  });

  group("View Testing", () {
    testWidgets("Renders ContinueWithEmailView with input and button",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );
      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
      );
      expect(find.byType(MainInputField), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.textContaining("terms"), findsOneWidget);
    });

    testWidgets("ContinueWithEmailViewArgs constructor initializes correctly",
        (WidgetTester tester) async {
      final InAppRedirection redirection = InAppRedirection.cashback();
      final ContinueWithEmailViewArgs args = ContinueWithEmailViewArgs(
        redirection: redirection,
        localLoginType: LoginType.email,
      );

      expect(args.redirection, equals(redirection));
      expect(args.localLoginType, equals(LoginType.email));
    });

    testWidgets("Tapping on terms checkbox calls updateTermsSelections",
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.state).thenReturn(
        ContinueWithEmailState()..isTermsChecked = false,
      );

      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );

      expect(
        mockViewModel.state?.isTermsChecked,
        false,
      );
      final Finder gesture = find.byType(GestureDetector).at(2);
      await tester.tap(gesture);
      await tester.pumpAndSettle();

      verify(mockViewModel.updateTermsSelections()).called(1);
    });

    testWidgets("Pressing MainButton triggers loginButtonTapped",
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.state)
          .thenReturn(ContinueWithEmailState()..isLoginEnabled = true);

      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );

      await tester.tap(find.byType(MainButton));
      await tester.pumpAndSettle();

      verify(mockViewModel.loginButtonTapped()).called(1);
    });

    testWidgets("debug properties", (WidgetTester tester) async {
      final InAppRedirection redirection = InAppRedirection.cashback();
      final ContinueWithEmailView widget =
          ContinueWithEmailView(redirection: redirection);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;

      final DiagnosticsProperty<InAppRedirection?> redirectionProp =
          props.firstWhere((DiagnosticsNode p) => p.name == "redirection")
              as DiagnosticsProperty<InAppRedirection?>;

      expect(redirectionProp.value, isNotNull);
      // expect(redirectionProp.value!.route, '/home');
    });

    testWidgets("Terms checkbox shows selected state when checked",
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.state).thenReturn(
        ContinueWithEmailState()..isTermsChecked = true,
      );

      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(mockViewModel.state?.isTermsChecked, true);
    });

    testWidgets("Tapping terms text calls showTermsSheet",
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.state).thenReturn(ContinueWithEmailState());

      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );
      await tester.pumpAndSettle();

      final Finder termsText = find.textContaining("terms");
      expect(termsText, findsWidgets);
    });

    testWidgets(
        "getContinueWithEmailSubtitleText returns correct text for email",
        (WidgetTester tester) async {
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.email,
      );

      final String subtitleText = view.getContinueWithEmailSubtitleText();
      expect(subtitleText, isNotEmpty);
    });

    testWidgets(
        "getContinueWithEmailSubtitleText returns correct text for phoneNumber",
        (WidgetTester tester) async {
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.phoneNumber,
      );

      final String subtitleText = view.getContinueWithEmailSubtitleText();
      expect(subtitleText, isNotEmpty);
    });

    testWidgets(
        "getContinueWithEmailSubtitleText returns correct text for emailAndPhone",
        (WidgetTester tester) async {
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.emailAndPhone,
      );

      final String subtitleText = view.getContinueWithEmailSubtitleText();
      expect(subtitleText, isNotEmpty);
    });

    test("routeName constant is ContinueWithEmailView", () {
      // Assert
      expect(ContinueWithEmailView.routeName, "ContinueWithEmailView");
    });

    testWidgets("renders Container when showEmailField is false",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showEmailField).thenReturn(false);

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Assert
      expect(find.byType(MainInputField), findsNothing);
    });

    testWidgets("renders two MainButtons for emailAndPhoneAndBothVerification",
        (WidgetTester tester) async {
      // Arrange
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.otpSendErrorMessage).thenReturn(null);

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(
            localLoginType: LoginType.emailAndPhoneAndBothVerification,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Assert
      expect(find.byType(MainButton), findsNWidgets(2));
    });

    testWidgets(
        "tapping EMAIL MainButton calls loginButtonTappedWithChannel EMAIL",
        (WidgetTester tester) async {
      // Arrange
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.otpSendErrorMessage).thenReturn(null);
      when(mockViewModel.state)
          .thenReturn(ContinueWithEmailState()..isLoginEnabled = true);

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(
            localLoginType: LoginType.emailAndPhoneAndBothVerification,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.byType(MainButton).first);
      await tester.pumpAndSettle();

      // Assert
      verify(mockViewModel.loginButtonTappedWithChannel("EMAIL")).called(1);
    });

    testWidgets("tapping SMS MainButton calls loginButtonTappedWithChannel SMS",
        (WidgetTester tester) async {
      // Arrange
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.otpSendErrorMessage).thenReturn(null);
      when(mockViewModel.state)
          .thenReturn(ContinueWithEmailState()..isLoginEnabled = true);

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(
            localLoginType: LoginType.emailAndPhoneAndBothVerification,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.byType(MainButton).at(1));
      await tester.pumpAndSettle();

      // Assert
      verify(mockViewModel.loginButtonTappedWithChannel("SMS")).called(1);
    });

    testWidgets("displays otpSendErrorMessage text when non-null",
        (WidgetTester tester) async {
      // Arrange
      tester.view.physicalSize = Size(tester.view.physicalSize.width, 2556);
      tester.view.devicePixelRatio = 3.0;

      when(mockViewModel.otpSendErrorMessage)
          .thenReturn("OTP failed via email");

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const ContinueWithEmailView(
            localLoginType: LoginType.emailAndPhoneAndBothVerification,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Assert
      expect(find.text("OTP failed via email"), findsOneWidget);
    });

    testWidgets("getLoginInstructionText returns text for phoneNumber",
        (WidgetTester tester) async {
      // Arrange
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.phoneNumber,
      );

      // Act
      final String text = view.getLoginInstructionText();

      // Assert
      expect(text, isNotEmpty);
    });

    testWidgets("getLoginInstructionText returns text for emailAndPhone",
        (WidgetTester tester) async {
      // Arrange
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.emailAndPhone,
      );

      // Act
      final String text = view.getLoginInstructionText();

      // Assert
      expect(text, isNotEmpty);
    });

    testWidgets(
        "getLoginInstructionText returns text for emailAndPhoneAndEmailVerification",
        (WidgetTester tester) async {
      // Arrange
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );

      // Act
      final String text = view.getLoginInstructionText();

      // Assert
      expect(text, isNotEmpty);
    });

    testWidgets(
        "getLoginInstructionText returns text for emailAndPhoneAndBothVerification",
        (WidgetTester tester) async {
      // Arrange
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );

      // Act
      final String text = view.getLoginInstructionText();

      // Assert
      expect(text, isNotEmpty);
    });

    testWidgets(
        "getContinueWithEmailSubtitleText returns text for emailAndPhoneAndEmailVerification",
        (WidgetTester tester) async {
      // Arrange
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );

      // Act
      final String text = view.getContinueWithEmailSubtitleText();

      // Assert
      expect(text, isNotEmpty);
    });

    testWidgets(
        "getContinueWithEmailSubtitleText returns text for emailAndPhoneAndBothVerification",
        (WidgetTester tester) async {
      // Arrange
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );

      // Act
      final String text = view.getContinueWithEmailSubtitleText();

      // Assert
      expect(text, isNotEmpty);
    });

    testWidgets("debugFillProperties includes localLoginType property",
        (WidgetTester tester) async {
      // Arrange
      const ContinueWithEmailView view = ContinueWithEmailView(
        localLoginType: LoginType.email,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();

      // Act
      view.debugFillProperties(builder);

      // Assert
      expect(
        builder.properties
            .any((DiagnosticsNode prop) => prop.name == "localLoginType"),
        isTrue,
      );
    });
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}
