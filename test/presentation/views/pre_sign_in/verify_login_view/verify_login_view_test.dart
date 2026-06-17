import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/otp_text_field.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/haptic_helper.dart";
import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  // Mock platform channels for plugins
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel toastChannel =
      MethodChannel("PonnamKarthik/fluttertoast");

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    toastChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == "showToast") {
        return null; // Mock successful toast
      }
      return null;
    },
  );

  late NavigationService mockNavigationService;
  late MockLocalStorageService mockLocalStorageService;
  late MockApiAuthRepository mockApiAuthRepository;

  setUp(() async {
    await setupTest();

    // Initialize haptic feedback mocking
    HapticHelperTest.implementHaptic();
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;

    onViewModelReadyMock(viewName: "VerifyLoginView");
    when(mockNavigationService.back()).thenReturn(true);
    when(
      mockNavigationService.pushNamedAndRemoveUntil(
        "HomePager",
        predicate: anyNamed("predicate"),
        arguments: anyNamed("arguments"),
        id: anyNamed("id"),
      ),
    ).thenAnswer((_) async => true);
    when(mockLocalStorageService.getString(any)).thenReturn("test_utm");

    // Create VerifyLoginViewModel instance for testing
    locator<VerifyLoginViewModel>().email = "test@example.com";
  });

  testWidgets("renders correctly with state error not empty",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    // when(viewModel.errorMessage).thenReturn("Some error");
    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );

    await tester.pumpAndSettle();
  });

  testWidgets("renders correctly with initial state",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.byType(VerifyLoginView), findsOneWidget);
    expect(find.byType(OtpTextField), findsOneWidget);
    expect(find.byType(MainButton), findsOneWidget);
    expect(find.byType(Image), findsOneWidget); // Back button icon
  });

  testWidgets("displays back button", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets("displays OTP input field and verify button",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OtpTextField), findsOneWidget);
    expect(find.byType(MainButton), findsOneWidget);
  });

  testWidgets("displays title and content text", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsAtLeastNWidgets(2));
  });

  testWidgets("renders with redirection parameter",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    final InAppRedirection testRedirection = InAppRedirection.cashback();

    await tester.pumpWidget(
      createTestableWidget(
        VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
          redirection: testRedirection,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VerifyLoginView), findsOneWidget);
  });

  testWidgets("pressing back button triggers navigation back",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find and tap the back button
    final Finder backButton = find.byType(GestureDetector).first;
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Verify that the navigation service was called
    verify(mockNavigationService.back()).called(1);
  });

  testWidgets("verify button is disabled initially",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final MainButton mainButton =
        tester.widget<MainButton>(find.byType(MainButton));
    expect(mainButton.isEnabled, false);
  });

  testWidgets("displays resend code text", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Look for RichText widget that contains the resend code text
    expect(find.byType(RichText), findsAtLeastNWidgets(1));
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    final InAppRedirection redirection = InAppRedirection.cashback();
    final VerifyLoginView widget = VerifyLoginView(
      email: "test@example.com",
      phoneNumber: null,
      redirection: redirection,
    );

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);

    final List<DiagnosticsNode> props = builder.properties;

    final StringProperty usernameProp =
        props.firstWhere((DiagnosticsNode p) => p.name == "email")
            as StringProperty;
    final DiagnosticsProperty<InAppRedirection?> redirectionProp =
        props.firstWhere((DiagnosticsNode p) => p.name == "redirection")
            as DiagnosticsProperty<InAppRedirection?>;

    expect(usernameProp.value, "test@example.com");
    expect(redirectionProp.value, isNotNull);
  });

  test("VerifyLoginViewArgs creates instance with all fields", () {
    final InAppRedirection redirection = InAppRedirection.cashback();
    final VerifyLoginViewArgs args = VerifyLoginViewArgs(
      email: "test@example.com",
      phoneNumber: "1234567890",
      otpExpiration: 300,
      redirection: redirection,
      localLoginType: LoginType.email,
      otpChannel: "EMAIL",
    );
    expect(args.email, "test@example.com");
    expect(args.phoneNumber, "1234567890");
    expect(args.otpExpiration, 300);
    expect(args.redirection, isNotNull);
    expect(args.localLoginType, LoginType.email);
    expect(args.otpChannel, "EMAIL");
  });

  testWidgets("renders with phoneNumber login type",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: null,
          phoneNumber: "1234567890",
          localLoginType: LoginType.phoneNumber,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VerifyLoginView), findsOneWidget);
    expect(find.byType(OtpTextField), findsOneWidget);
    expect(find.byType(MainButton), findsOneWidget);
  });

  testWidgets("renders with emailAndPhone login type",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: "1234567890",
          localLoginType: LoginType.emailAndPhone,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VerifyLoginView), findsOneWidget);
  });

  testWidgets("renders with emailAndPhoneAndEmailVerification login type",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: null,
          localLoginType: LoginType.emailAndPhoneAndEmailVerification,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VerifyLoginView), findsOneWidget);
  });

  testWidgets(
      "renders emailAndPhoneAndBothVerification with EMAIL channel",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: "1234567890",
          localLoginType: LoginType.emailAndPhoneAndBothVerification,
          otpChannel: "EMAIL",
        ),
      ),
    );
    await tester.pump();
    // Fire the 15-second channel-switch timer to avoid pending timer errors
    await tester.pump(const Duration(seconds: 16));

    expect(find.byType(VerifyLoginView), findsOneWidget);
    expect(find.byType(OtpTextField), findsOneWidget);
  });

  testWidgets(
      "renders emailAndPhoneAndBothVerification with SMS channel",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: "1234567890",
          localLoginType: LoginType.emailAndPhoneAndBothVerification,
          otpChannel: "SMS",
        ),
      ),
    );
    await tester.pump();
    // Fire the 15-second channel-switch timer to avoid pending timer errors
    await tester.pump(const Duration(seconds: 16));

    expect(find.byType(VerifyLoginView), findsOneWidget);
  });

  testWidgets(
      "renders canSwitchOtpChannel section after 15s timer fires",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(
          email: "test@example.com",
          phoneNumber: "1234567890",
          localLoginType: LoginType.emailAndPhoneAndBothVerification,
          otpChannel: "EMAIL",
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 16));

    expect(find.byType(VerifyLoginView), findsOneWidget);
  });

  testWidgets("renders OTP field in error state when verifyOtp fails",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    when(
      mockApiAuthRepository.verifyOtp(
        email: anyNamed("email"),
        pinCode: anyNamed("pinCode"),
      ),
    ).thenAnswer(
      (_) async => Resource<AuthResponseModel>.error(
        "Invalid OTP",
        error: GeneralError(message: "Invalid OTP", errorCode: 400),
      ),
    );

    final VerifyLoginViewModel vm = locator<VerifyLoginViewModel>();
    await vm.otpFieldSubmitted("123456");
    await vm.verifyButtonTapped();

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(email: "test@example.com", phoneNumber: null),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OtpTextField), findsOneWidget);
  });

  testWidgets("verify button tap when enabled covers onPressed callback",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    when(
      mockApiAuthRepository.verifyOtp(
        email: anyNamed("email"),
        pinCode: anyNamed("pinCode"),
      ),
    ).thenAnswer(
      (_) async => Resource<AuthResponseModel>.error(
        "Error",
        error: GeneralError(message: "Error", errorCode: 400),
      ),
    );

    final VerifyLoginViewModel vm = locator<VerifyLoginViewModel>();
    await vm.otpFieldSubmitted("123456");

    await tester.pumpWidget(
      createTestableWidget(
        const VerifyLoginView(email: "test@example.com", phoneNumber: null),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MainButton).first);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}
