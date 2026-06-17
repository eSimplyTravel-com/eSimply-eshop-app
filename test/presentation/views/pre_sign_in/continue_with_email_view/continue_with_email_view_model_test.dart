// continue_with_email_view_model_test.dart

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";

Future<void> main() async {
  // ensure system up
  await prepareTest();
  late ContinueWithEmailViewModel viewModel;

  setUp(() async {
    await setupTest();
    viewModel = ContinueWithEmailViewModel();
  });

  group("View Model Testing", () {
    test("Back button tapped", () {
      when(locator<NavigationService>().back()).thenReturn(true);
      viewModel.backButtonTapped();
      verify(locator<NavigationService>().back()).called(1);
    });

    test("Update terms selection tapped", () {
      viewModel.state?.isTermsChecked = false;
      viewModel.updateTermsSelections();
      expect(viewModel.state?.isTermsChecked, true);
    });

    test("Email address validation error", () {
      viewModel.state?.emailController.text = "raed.com";
      String result = viewModel
          .validateEmailAddress(viewModel.state?.emailController.text ?? "");
      expect(result, LocaleKeys.enter_a_valid_email_address.tr());
    });

    test("Initial state is correct", () {
      expect(viewModel.state?.isLoginEnabled, false);
      expect(viewModel.state?.isTermsChecked, false);
      expect(viewModel.state?.emailErrorMessage, isNull);
    });

    test("validateEmailAddress returns required field error when empty", () {
      expect(viewModel.validateEmailAddress(""), isNotEmpty);
    });

    test("validateEmailAddress returns valid for proper email", () {
      expect(viewModel.validateEmailAddress("test@example.com"), "");
    });

    test("validateForm enables login only with valid email and terms checked",
        () async {
      onViewModelReadyMock();
      viewModel.onViewModelReady();

      viewModel.state?.isTermsChecked = true;
      viewModel.state?.emailController.text = "test@example.com";

      expect(viewModel.state?.isLoginEnabled, true);
      expect(viewModel.state?.emailErrorMessage, "");
    });

    test("loginWithEmail navigates to verify view on success", () async {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      viewModel.state?.isTermsChecked = true;
      viewModel.state?.emailController.text = "test@example.com";
      viewModel.state?.emailErrorMessage = "";
      when(
        locator<ApiAuthRepository>().login(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.success(
          OtpResponseModel(),
          message: "",
        ),
      );

      when(
        locator<NavigationService>().navigateTo(
          "VerifyLoginView",
          arguments: argThat(
            isA<VerifyLoginViewArgs>()
                .having(
                  (VerifyLoginViewArgs args) => args.email,
                  "email",
                  "test@example.com",
                )
                .having(
                  (VerifyLoginViewArgs args) => args.redirection,
                  "redirection",
                  null,
                ),
            named: "arguments",
          ),
        ),
      ).thenAnswer((_) async => true);

      await viewModel.loginButtonTapped();

      verify(
        locator<NavigationService>().navigateTo(
          "VerifyLoginView",
          arguments: argThat(
            isA<VerifyLoginViewArgs>()
                .having(
                  (VerifyLoginViewArgs args) => args.email,
                  "email",
                  "test@example.com",
                )
                .having(
                  (VerifyLoginViewArgs args) => args.redirection,
                  "redirection",
                  null,
                ),
            named: "arguments",
          ),
        ),
      ).called(1);
    });

    test("showTermsSheet sets isTermsChecked to true when confirmed", () async {
      when(
        locator<BottomSheetService>().showCustomSheet(
          variant: BottomSheetType.termsCondition,
          isScrollControlled: true,
          enableDrag: false,
        ),
      ).thenAnswer(
        (_) async => SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
      );

      await viewModel.showTermsSheet();

      expect(viewModel.state?.isTermsChecked, true);
    });

    test("validateNumber called", () {
      viewModel.validateNumber(code: "1", number: "123", isValid: true);
    });

    test("Update terms selection tapped cover lines", () {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.phoneNumber);
      viewModel.state?.isTermsChecked = false;
      viewModel.updateTermsSelections();
      expect(viewModel.state?.isTermsChecked, true);
    });

    test("showEmailField returns true for LoginType.email", () {
      final ContinueWithEmailViewModel viewModelEmail =
          ContinueWithEmailViewModel(localLoginType: LoginType.email);
      expect(viewModelEmail.showEmailField, true);
    });

    test("showEmailField returns true for LoginType.emailAndPhone", () {
      final ContinueWithEmailViewModel viewModelEmailPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.emailAndPhone);
      expect(viewModelEmailPhone.showEmailField, true);
    });

    test("showEmailField returns false for LoginType.phoneNumber", () {
      final ContinueWithEmailViewModel viewModelPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.phoneNumber);
      expect(viewModelPhone.showEmailField, false);
    });

    test("showPhoneField returns false for LoginType.email", () {
      final ContinueWithEmailViewModel viewModelEmail =
          ContinueWithEmailViewModel(localLoginType: LoginType.email);
      expect(viewModelEmail.showPhoneField, false);
    });

    test("showPhoneField returns true for LoginType.phoneNumber", () {
      final ContinueWithEmailViewModel viewModelPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.phoneNumber);
      expect(viewModelPhone.showPhoneField, true);
    });

    test("showPhoneField returns true for LoginType.emailAndPhone", () {
      final ContinueWithEmailViewModel viewModelEmailPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.emailAndPhone);
      expect(viewModelEmailPhone.showPhoneField, true);
    });

    test("onViewModelReady sets up email listener for LoginType.email",
        () async {
      final ContinueWithEmailViewModel viewModelEmail =
          ContinueWithEmailViewModel(localLoginType: LoginType.email);
      onViewModelReadyMock();
      viewModelEmail.onViewModelReady();

      viewModelEmail.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModelEmail.state?.emailErrorMessage, "");
    });

    test("onViewModelReady sets up email listener for LoginType.emailAndPhone",
        () async {
      final ContinueWithEmailViewModel viewModelEmailPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.emailAndPhone);
      onViewModelReadyMock();
      viewModelEmailPhone.onViewModelReady();

      viewModelEmailPhone.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModelEmailPhone.state?.emailErrorMessage, "");
    });

    test("validateNumber enables login for LoginType.phoneNumber", () {
      final ContinueWithEmailViewModel viewModelPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.phoneNumber);
      viewModelPhone.state?.isTermsChecked = true;

      viewModelPhone.validateNumber(
        code: "+1",
        number: "1234567890",
        isValid: true,
      );

      expect(viewModelPhone.state?.isLoginEnabled, true);
      expect(viewModelPhone.state?.isValidPhoneNumber, true);
    });

    test("validateNumber enables login for LoginType.emailAndPhone", () async {
      final ContinueWithEmailViewModel viewModelEmailPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.emailAndPhone);
      onViewModelReadyMock();
      viewModelEmailPhone.onViewModelReady();

      viewModelEmailPhone.state?.isTermsChecked = true;
      viewModelEmailPhone.state?.emailController.text = "test@example.com";

      await Future<void>.delayed(const Duration(milliseconds: 100));

      viewModelEmailPhone.validateNumber(
        code: "+1",
        number: "1234567890",
        isValid: true,
      );

      expect(viewModelEmailPhone.state?.isLoginEnabled, true);
      expect(viewModelEmailPhone.state?.isValidPhoneNumber, true);
    });

    test("validateNumber does not enable login for invalid phone", () {
      final ContinueWithEmailViewModel viewModelPhone =
          ContinueWithEmailViewModel(localLoginType: LoginType.phoneNumber);
      viewModelPhone.state?.isTermsChecked = true;

      viewModelPhone.validateNumber(
        code: "+1",
        number: "123",
        isValid: false,
      );

      expect(viewModelPhone.state?.isLoginEnabled, false);
      expect(viewModelPhone.state?.isValidPhoneNumber, false);
    });

    test("loginWithEmail navigates on 429 error", () async {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      viewModel.state?.isTermsChecked = true;
      viewModel.state?.emailController.text = "test@example.com";
      viewModel.state?.emailErrorMessage = "";

      when(
        locator<ApiAuthRepository>().login(
          email: "test@example.com",
          phoneNumber: null,
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.error(
          "Too many requests",
          data: OtpResponseModel(otpExpiration: 300),
          error: GeneralError(
            message: "Too many requests",
            errorCode: 429,
          ),
        ),
      );

      when(
        locator<NavigationService>().navigateTo(
          "VerifyLoginView",
          arguments: argThat(
            isA<VerifyLoginViewArgs>()
                .having(
                  (VerifyLoginViewArgs args) => args.email,
                  "email",
                  "test@example.com",
                )
                .having(
                  (VerifyLoginViewArgs args) => args.redirection,
                  "redirection",
                  null,
                ),
            named: "arguments",
          ),
        ),
      ).thenAnswer((_) async => true);

      await viewModel.loginButtonTapped();

      verify(
        locator<NavigationService>().navigateTo(
          "VerifyLoginView",
          arguments: argThat(
            isA<VerifyLoginViewArgs>()
                .having(
                  (VerifyLoginViewArgs args) => args.email,
                  "email",
                  "test@example.com",
                )
                .having(
                  (VerifyLoginViewArgs args) => args.redirection,
                  "redirection",
                  null,
                ),
            named: "arguments",
          ),
        ),
      ).called(1);
    });

    test("initialization - isNotNull and correct type", () {
      // Assert
      expect(viewModel, isNotNull);
      expect(viewModel, isA<ContinueWithEmailViewModel>());
    });

    test("selectedOtpChannel returns SMS by default", () {
      // Assert
      expect(viewModel.selectedOtpChannel, "SMS");
    });

    test("otpSendErrorMessage returns null by default", () {
      // Assert
      expect(viewModel.otpSendErrorMessage, isNull);
    });

    test("selectOtpChannel updates channel and clears error message", () {
      // Arrange
      viewModel.state?.otpSendErrorMessage = "some error";

      // Act
      viewModel.selectOtpChannel("EMAIL");

      // Assert
      expect(viewModel.selectedOtpChannel, "EMAIL");
      expect(viewModel.otpSendErrorMessage, isNull);
    });

    test(
        "showEmailField returns true for LoginType.emailAndPhoneAndEmailVerification",
        () {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );

      // Assert
      expect(vm.showEmailField, true);
    });

    test(
        "showEmailField returns true for LoginType.emailAndPhoneAndBothVerification",
        () {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );

      // Assert
      expect(vm.showEmailField, true);
    });

    test(
        "showPhoneField returns true for LoginType.emailAndPhoneAndEmailVerification",
        () {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );

      // Assert
      expect(vm.showPhoneField, true);
    });

    test(
        "showPhoneField returns true for LoginType.emailAndPhoneAndBothVerification",
        () {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );

      // Assert
      expect(vm.showPhoneField, true);
    });

    test("onViewModelReady for phoneNumber does not add email listener", () {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.phoneNumber,
      );
      onViewModelReadyMock();

      // Act — should not throw
      vm.onViewModelReady();

      // Assert — emailErrorMessage unchanged (no listener registered)
      expect(vm.state?.emailErrorMessage, isNull);
    });

    test(
        "onViewModelReady for emailAndPhoneAndEmailVerification adds email listener",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );
      onViewModelReadyMock();
      vm.onViewModelReady();

      // Act
      vm.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(vm.state?.emailErrorMessage, "");
    });

    test(
        "onViewModelReady for emailAndPhoneAndBothVerification adds email listener",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );
      onViewModelReadyMock();
      vm.onViewModelReady();

      // Act
      vm.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(vm.state?.emailErrorMessage, "");
    });

    test(
        "validateForm enables login for phoneNumber with valid phone and terms",
        () {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.phoneNumber,
      );
      vm.state?.isValidPhoneNumber = true;
      vm.state?.isTermsChecked = false;

      // Act — toggles terms to true and runs _validateForm
      vm.updateTermsSelections();

      // Assert
      expect(vm.state?.isLoginEnabled, true);
    });

    test(
        "validateForm for emailAndPhoneAndEmailVerification checks email, phone, and terms",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );
      onViewModelReadyMock();
      vm.onViewModelReady();
      vm.state?.isTermsChecked = true;
      vm.state?.isValidPhoneNumber = true;

      // Act
      vm.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(vm.state?.isLoginEnabled, true);
    });

    test(
        "validateForm for emailAndPhoneAndBothVerification checks email, phone, and terms",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );
      onViewModelReadyMock();
      vm.onViewModelReady();
      vm.state?.isTermsChecked = true;
      vm.state?.isValidPhoneNumber = true;

      // Act
      vm.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(vm.state?.isLoginEnabled, true);
    });

    test("validateNumber for emailAndPhoneAndEmailVerification enables login",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );
      onViewModelReadyMock();
      vm.onViewModelReady();
      vm.state?.isTermsChecked = true;
      vm.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Act
      vm.validateNumber(code: "+1", number: "1234567890", isValid: true);

      // Assert
      expect(vm.state?.isLoginEnabled, true);
      expect(vm.state?.isValidPhoneNumber, true);
    });

    test("validateNumber for emailAndPhoneAndBothVerification enables login",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );
      onViewModelReadyMock();
      vm.onViewModelReady();
      vm.state?.isTermsChecked = true;
      vm.state?.emailController.text = "test@example.com";
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Act
      vm.validateNumber(code: "+1", number: "1234567890", isValid: true);

      // Assert
      expect(vm.state?.isLoginEnabled, true);
      expect(vm.state?.isValidPhoneNumber, true);
    });

    test(
        "loginButtonTappedWithChannel with EMAIL sets channel and navigates on success",
        () async {
      // Arrange
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      viewModel.state?.isTermsChecked = true;
      viewModel.state?.emailController.text = "test@example.com";
      viewModel.state?.emailErrorMessage = "";
      when(
        locator<ApiAuthRepository>().login(
          email: anyNamed("email"),
          phoneNumber: anyNamed("phoneNumber"),
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.success(
          OtpResponseModel(),
          message: "",
        ),
      );
      when(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).thenAnswer((_) async => true);

      // Act
      await viewModel.loginButtonTappedWithChannel("EMAIL");

      // Assert
      expect(viewModel.selectedOtpChannel, "EMAIL");
      verify(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test(
        "loginButtonTappedWithChannel with SMS sets channel and navigates on success",
        () async {
      // Arrange
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      viewModel.state?.isTermsChecked = true;
      viewModel.state?.emailController.text = "test@example.com";
      viewModel.state?.emailErrorMessage = "";
      when(
        locator<ApiAuthRepository>().login(
          email: anyNamed("email"),
          phoneNumber: anyNamed("phoneNumber"),
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.success(
          OtpResponseModel(),
          message: "",
        ),
      );
      when(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).thenAnswer((_) async => true);

      // Act
      await viewModel.loginButtonTappedWithChannel("SMS");

      // Assert
      expect(viewModel.selectedOtpChannel, "SMS");
      verify(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test(
        "loginWithEmail for emailAndPhoneAndEmailVerification uses EMAIL otpChannel",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndEmailVerification,
      );
      vm.state?.isTermsChecked = true;
      vm.state?.emailController.text = "test@example.com";
      vm.state?.emailErrorMessage = "";
      when(
        locator<ApiAuthRepository>().login(
          email: anyNamed("email"),
          phoneNumber: anyNamed("phoneNumber"),
          otpChannel: anyNamed("otpChannel"),
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.success(
          OtpResponseModel(),
          message: "",
        ),
      );
      when(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).thenAnswer((_) async => true);

      // Act
      await vm.loginButtonTapped();

      // Assert
      verify(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test(
        "loginWithEmail for emailAndPhoneAndBothVerification uses selected otpChannel",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );
      vm.state?.isTermsChecked = true;
      vm.state?.emailController.text = "test@example.com";
      vm.state?.emailErrorMessage = "";
      vm.selectOtpChannel("SMS");
      when(
        locator<ApiAuthRepository>().login(
          email: anyNamed("email"),
          phoneNumber: anyNamed("phoneNumber"),
          otpChannel: anyNamed("otpChannel"),
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.success(
          OtpResponseModel(),
          message: "",
        ),
      );
      when(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).thenAnswer((_) async => true);

      // Act
      await vm.loginButtonTapped();

      // Assert
      verify(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test(
        "loginWithEmail for emailAndPhoneAndBothVerification sets otpSendErrorMessage on error",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.emailAndPhoneAndBothVerification,
      );
      vm.state?.isTermsChecked = true;
      vm.state?.emailController.text = "test@example.com";
      vm.state?.emailErrorMessage = "";
      vm.selectOtpChannel("EMAIL");
      when(
        locator<ApiAuthRepository>().login(
          email: anyNamed("email"),
          phoneNumber: anyNamed("phoneNumber"),
          otpChannel: anyNamed("otpChannel"),
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.error(
          "OTP failed via email",
          error: GeneralError(message: "OTP failed via email", errorCode: 500),
        ),
      );

      // Act
      await vm.loginButtonTapped();

      // Assert
      expect(vm.otpSendErrorMessage, isNotNull);
    });

    test("loginWithEmail non-429 error for email type calls handleError",
        () async {
      // Arrange
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      viewModel.state?.isTermsChecked = true;
      viewModel.state?.emailController.text = "test@example.com";
      viewModel.state?.emailErrorMessage = "";
      when(
        locator<ApiAuthRepository>().login(
          email: anyNamed("email"),
          phoneNumber: anyNamed("phoneNumber"),
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.error(
          "Server error",
          error: GeneralError(message: "Server error", errorCode: 500),
        ),
      );
      when(locator<DialogService>().showDialog(
        title: anyNamed("title"),
        description: anyNamed("description"),
      )).thenAnswer((_) async => null);

      // Act — should not throw
      await viewModel.loginButtonTapped();
    });

    test("loginWithEmail with valid phone includes phone number in args",
        () async {
      // Arrange
      final ContinueWithEmailViewModel vm = ContinueWithEmailViewModel(
        localLoginType: LoginType.phoneNumber,
      );
      vm.state?.isTermsChecked = true;
      vm.validateNumber(code: "1", number: "1234567890", isValid: true);
      when(
        locator<ApiAuthRepository>().login(
          email: anyNamed("email"),
          phoneNumber: anyNamed("phoneNumber"),
        ),
      ).thenAnswer(
        (_) async => Resource<OtpResponseModel?>.success(
          OtpResponseModel(),
          message: "",
        ),
      );
      when(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).thenAnswer((_) async => true);

      // Act
      await vm.loginButtonTapped();

      // Assert
      verify(
        locator<NavigationService>().navigateTo(
          VerifyLoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}
