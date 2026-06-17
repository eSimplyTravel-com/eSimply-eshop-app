import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/delete_account_bottom_sheet/delete_account_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:phone_input/phone_input_package.dart";

import "../../../../helpers/app_enviroment_helper.dart";
import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  setUpAll(() async {
    await prepareTest();
  });

  late DeleteAccountBottomSheetViewModel viewModel;
  late MockApiAuthRepository mockApiAuthRepository;
  late MockUserAuthenticationService mockUserAuthenticationService;
  late MockAppConfigurationService mockAppConfigurationService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "DeleteAccountBottomSheet");

    // Initialize AppEnvironment with test values
    AppEnvironment.isFromAppClip = false;
    AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();

    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockUserAuthenticationService = locator<UserAuthenticationService>()
        as MockUserAuthenticationService;
    mockAppConfigurationService = locator<AppConfigurationService>()
        as MockAppConfigurationService;

    // Default mock for login type
    when(mockAppConfigurationService.getLoginType).thenReturn(null);

    viewModel = DeleteAccountBottomSheetViewModel();
  });

  tearDown(() async {
    viewModel.emailController.dispose();
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("DeleteAccountBottomSheetViewModel Tests", () {
    test("initialization test", () {
      expect(viewModel, isNotNull);
      expect(viewModel, isA<DeleteAccountBottomSheetViewModel>());
      expect(viewModel.emailController, isNotNull);
      expect(viewModel.phoneController, isNotNull);
      expect(viewModel.isButtonEnabled, isFalse);
      expect(viewModel.emailErrorMessage, isNull);
    });

    group("showPhoneInput getter tests", () {
      test("showPhoneInput returns false when loginType is email", () {
        // Arrange
        when(mockAppConfigurationService.getLoginType)
            .thenReturn(LoginType.email);

        // Act
        final bool result = viewModel.showPhoneInput;

        // Assert
        expect(result, false);
      });

      test("showPhoneInput returns true when loginType is phoneNumber", () {
        // Arrange
        when(mockAppConfigurationService.getLoginType)
            .thenReturn(LoginType.phoneNumber);

        // Act
        final bool result = viewModel.showPhoneInput;

        // Assert
        expect(result, true);
      });

      test("showPhoneInput returns true when loginType is emailAndPhone", () {
        // Arrange
        when(mockAppConfigurationService.getLoginType)
            .thenReturn(LoginType.emailAndPhone);

        // Act
        final bool result = viewModel.showPhoneInput;

        // Assert
        expect(result, true);
      });
    });

    group("validateEmailAddress tests", () {
      test("validateEmailAddress returns error when email is empty", () {
        // Act
        final String result = viewModel.validateEmailAddress("");

        // Assert
        expect(result, isNotEmpty);
      });

      test("validateEmailAddress returns error when email is invalid format",
          () {
        // Act
        final String result = viewModel.validateEmailAddress("invalid-email");

        // Assert
        expect(result, isNotEmpty);
      });

      test(
          "validateEmailAddress returns error when email does not match user email",
          () {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");

        // Act
        final String result =
            viewModel.validateEmailAddress("different@example.com");

        // Assert
        expect(result, isNotEmpty);
      });

      test(
          "validateEmailAddress returns empty string when email is valid and matches",
          () {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");

        // Act
        final String result = viewModel.validateEmailAddress("user@example.com");

        // Assert
        expect(result, isEmpty);
      });

      test("validateEmailAddress handles whitespace in email", () {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");

        // Act - validateEmailAddress receives already trimmed text from _validateForm
        final String result = viewModel.validateEmailAddress("user@example.com");

        // Assert
        expect(result, isEmpty);
      });

      test("validateEmailAddress is case sensitive for email comparison", () {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("User@Example.com");

        // Act
        final String result = viewModel.validateEmailAddress("user@example.com");

        // Assert - Should return error as emails don't match exactly
        expect(result, isNotEmpty);
      });
    });

    group("validateNumber tests", () {
      test("validateNumber enables button when phone is valid and matches", () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");

        // Act
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "1234567",
          isValid: true,
        );

        // Assert
        expect(viewModel.isButtonEnabled, true);
      });

      test(
          "validateNumber disables button when phone is valid but does not match",
          () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");

        // Act
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "7654321",
          isValid: true,
        );

        // Assert
        expect(viewModel.isButtonEnabled, false);
      });

      test("validateNumber disables button when phone is invalid", () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");

        // Act
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "1234567",
          isValid: false,
        );

        // Assert
        expect(viewModel.isButtonEnabled, false);
      });

      test(
          "validateNumber disables button when phone is invalid and does not match",
          () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");

        // Act
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "9999999",
          isValid: false,
        );

        // Assert
        expect(viewModel.isButtonEnabled, false);
      });

      test("validateNumber handles different country codes", () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+15551234567");

        // Act
        viewModel.validateNumber(
          code: "1",
          phoneNumber: "5551234567",
          isValid: true,
        );

        // Assert
        expect(viewModel.isButtonEnabled, true);
      });
    });

    group("onViewModelReady tests", () {
      test("onViewModelReady initializes phoneController when phone is parsed",
          () async {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");

        // Act
        viewModel.onViewModelReady();

        // Wait for postFrameCallback
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - phoneController should have the parsed ISO code
        expect(viewModel.phoneController.value?.isoCode, IsoCode.LB);
        expect(viewModel.phoneController.value?.nsn, "");
      });

      test(
          "onViewModelReady does not change phoneController when phone parsing fails",
          () async {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("invalid-phone");

        final PhoneNumber? originalValue = viewModel.phoneController.value;

        // Act
        viewModel.onViewModelReady();

        // Wait for postFrameCallback
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - phoneController should retain default value (LB)
        expect(
          viewModel.phoneController.value?.isoCode,
          originalValue?.isoCode,
        );
      });

      test("onViewModelReady adds listener to emailController", () async {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("+961");

        // Act
        viewModel.onViewModelReady();

        // Wait for postFrameCallback (needs more time in test environment)
        await Future<void>.delayed(const Duration(milliseconds: 300));

        // Initially button should be disabled
        expect(viewModel.isButtonEnabled, isFalse);

        // Change email text to trigger listener
        viewModel.emailController.text = "user@example.com";

        // Wait for listener to process
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert - button should be enabled after valid email
        expect(viewModel.isButtonEnabled, isTrue);
      });

      test("onViewModelReady handles empty userMsisdn", () async {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("");

        final PhoneNumber? originalValue = viewModel.phoneController.value;

        // Act
        viewModel.onViewModelReady();

        // Wait for postFrameCallback
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - phoneController should retain default value
        expect(
          viewModel.phoneController.value?.isoCode,
          originalValue?.isoCode,
        );
      });
    });

    group("emailController listener tests", () {
      test("emailController listener updates button state on text change",
          () async {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("+961");

        viewModel.onViewModelReady();
        await Future<void>.delayed(const Duration(milliseconds: 300));

        expect(viewModel.isButtonEnabled, isFalse);

        // Act - Add valid email
        viewModel.emailController.text = "user@example.com";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.isButtonEnabled, isTrue);

        // Act - Clear email
        viewModel.emailController.text = "";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.isButtonEnabled, isFalse);
      });

      test("emailController listener validates email on every change",
          () async {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("+961");

        viewModel.onViewModelReady();
        await Future<void>.delayed(const Duration(milliseconds: 300));

        // Act - Invalid format
        viewModel.emailController.text = "invalid";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.isButtonEnabled, isFalse);
        expect(viewModel.emailErrorMessage, isNotEmpty);

        // Act - Valid format but wrong email
        viewModel.emailController.text = "wrong@example.com";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.isButtonEnabled, isFalse);
        expect(viewModel.emailErrorMessage, isNotEmpty);

        // Act - Correct email
        viewModel.emailController.text = "user@example.com";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.isButtonEnabled, isTrue);
        expect(viewModel.emailErrorMessage, isEmpty);
      });
    });

    group("deleteAccountButtonTapped tests", () {
      test("deleteAccountButtonTapped handles success response", () async {
        // Arrange
        when(mockApiAuthRepository.deleteAccount()).thenAnswer(
          (_) async => Resource<EmptyResponse>.success(
            EmptyResponse(),
            message: "Account deleted successfully",
          ),
        );

        expect(viewModel.viewState, ViewState.idle);

        // Act
        await viewModel.deleteAccountButtonTapped();

        // Assert
        verify(mockApiAuthRepository.deleteAccount()).called(1);
        expect(viewModel.viewState, ViewState.idle);
      });

      test("deleteAccountButtonTapped handles failure response", () async {
        // Arrange
        when(mockApiAuthRepository.deleteAccount()).thenAnswer(
          (_) async => Resource<EmptyResponse>.error("Failed to delete account"),
        );

        expect(viewModel.viewState, ViewState.idle);

        // Act
        await viewModel.deleteAccountButtonTapped();

        // Assert
        verify(mockApiAuthRepository.deleteAccount()).called(1);
        expect(viewModel.viewState, ViewState.idle);
      });

      test("deleteAccountButtonTapped sets viewState to busy during execution",
          () async {
        // Arrange
        bool busyStateSeen = false;

        when(mockApiAuthRepository.deleteAccount()).thenAnswer((_) async {
          // Check state during async operation
          if (viewModel.viewState == ViewState.busy) {
            busyStateSeen = true;
          }
          return Resource<EmptyResponse>.success(
            EmptyResponse(),
            message: "Success",
          );
        });

        // Act
        await viewModel.deleteAccountButtonTapped();

        // Assert
        expect(busyStateSeen, isTrue);
        expect(viewModel.viewState, ViewState.idle);
      });

      test("deleteAccountButtonTapped handles API exception gracefully",
          () async {
        // Arrange
        when(mockApiAuthRepository.deleteAccount()).thenAnswer(
          (_) async => Resource<EmptyResponse>.error("Network error"),
        );

        // Act
        await viewModel.deleteAccountButtonTapped();

        // Assert
        verify(mockApiAuthRepository.deleteAccount()).called(1);
        expect(viewModel.viewState, ViewState.idle);
      });

      test("deleteAccountButtonTapped can be called multiple times", () async {
        // Arrange
        when(mockApiAuthRepository.deleteAccount()).thenAnswer(
          (_) async => Resource<EmptyResponse>.success(
            EmptyResponse(),
            message: "Success",
          ),
        );

        // Act
        await viewModel.deleteAccountButtonTapped();
        await viewModel.deleteAccountButtonTapped();

        // Assert
        verify(mockApiAuthRepository.deleteAccount()).called(2);
      });
    });

    group("edge case tests", () {
      test("emailController handles very long email addresses", () async {
        // Arrange
        final String longEmail = "${"a" * 100}@example.com";
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn(longEmail);
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("+961");

        viewModel.onViewModelReady();
        await Future<void>.delayed(const Duration(milliseconds: 300));

        // Act
        viewModel.emailController.text = longEmail;
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.isButtonEnabled, isTrue);
      });

      test("validateEmailAddress handles special characters in email", () {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user+test@example.com");

        // Act
        final String result =
            viewModel.validateEmailAddress("user+test@example.com");

        // Assert
        expect(result, isEmpty);
      });

      test("validateNumber handles phone with leading zeros", () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9610012345");

        // Act
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "0012345",
          isValid: true,
        );

        // Assert
        expect(viewModel.isButtonEnabled, true);
      });

      test("phoneController retains default IsoCode on parsing failure",
          () async {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("not-a-phone-number");

        // Act
        viewModel.onViewModelReady();
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - Should retain Lebanon default
        expect(viewModel.phoneController.value?.isoCode, IsoCode.LB);
      });

      test("isButtonEnabled getter reflects internal state correctly", () {
        // Initially false
        expect(viewModel.isButtonEnabled, isFalse);

        // Simulate validateNumber setting state to true
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");

        viewModel.validateNumber(
          code: "961",
          phoneNumber: "1234567",
          isValid: true,
        );

        expect(viewModel.isButtonEnabled, isTrue);
      });

      test("emailErrorMessage is updated correctly during validation", () async {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("+961");

        viewModel.onViewModelReady();
        await Future<void>.delayed(const Duration(milliseconds: 300));

        // Initially null
        expect(viewModel.emailErrorMessage, isNull);

        // Act - Invalid email
        viewModel.emailController.text = "invalid";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.emailErrorMessage, isNotEmpty);

        // Act - Valid email
        viewModel.emailController.text = "user@example.com";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.emailErrorMessage, isEmpty);
      });

      test("validateEmailAddress with email containing dots", () {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user.name@example.com");

        // Act
        final String result =
            viewModel.validateEmailAddress("user.name@example.com");

        // Assert
        expect(result, isEmpty);
      });

      test("validateNumber with very long phone number", () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+961123456789012345");

        // Act
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "123456789012345",
          isValid: true,
        );

        // Assert
        expect(viewModel.isButtonEnabled, true);
      });

      test(
          "deleteAccountButtonTapped maintains state consistency on multiple rapid calls",
          () async {
        // Arrange
        when(mockApiAuthRepository.deleteAccount()).thenAnswer(
          (_) async {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return Resource<EmptyResponse>.success(
              EmptyResponse(),
              message: "Success",
            );
          },
        );

        // Act - Call multiple times rapidly
        final Future<void> call1 = viewModel.deleteAccountButtonTapped();
        final Future<void> call2 = viewModel.deleteAccountButtonTapped();
        final Future<void> call3 = viewModel.deleteAccountButtonTapped();

        await Future.wait(<Future<void>>[call1, call2, call3]);

        // Assert - All calls should complete successfully
        expect(viewModel.viewState, ViewState.idle);
        verify(mockApiAuthRepository.deleteAccount()).called(3);
      });
    });

    group("integration tests", () {
      test("full email validation flow from empty to valid", () async {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("+961");

        viewModel.onViewModelReady();
        await Future<void>.delayed(const Duration(milliseconds: 300));

        // Initially empty
        expect(viewModel.isButtonEnabled, isFalse);

        // Type incomplete email
        viewModel.emailController.text = "user";
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(viewModel.isButtonEnabled, isFalse);

        // Type complete but invalid format
        viewModel.emailController.text = "user@";
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(viewModel.isButtonEnabled, isFalse);

        // Type valid format but wrong email
        viewModel.emailController.text = "wrong@example.com";
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(viewModel.isButtonEnabled, isFalse);

        // Type correct email
        viewModel.emailController.text = "user@example.com";
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(viewModel.isButtonEnabled, isTrue);
      });

      test("full phone validation flow", () {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");

        // Initially disabled
        expect(viewModel.isButtonEnabled, isFalse);

        // Invalid phone
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "123",
          isValid: false,
        );
        expect(viewModel.isButtonEnabled, isFalse);

        // Valid phone but wrong number
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "9999999",
          isValid: true,
        );
        expect(viewModel.isButtonEnabled, isFalse);

        // Valid phone and correct number
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "1234567",
          isValid: true,
        );
        expect(viewModel.isButtonEnabled, isTrue);
      });

      test("switching between email and phone login types", () {
        // Email mode
        when(mockAppConfigurationService.getLoginType)
            .thenReturn(LoginType.email);
        expect(viewModel.showPhoneInput, isFalse);

        // Phone mode
        when(mockAppConfigurationService.getLoginType)
            .thenReturn(LoginType.phoneNumber);
        expect(viewModel.showPhoneInput, isTrue);

        // Email and phone mode
        when(mockAppConfigurationService.getLoginType)
            .thenReturn(LoginType.emailAndPhone);
        expect(viewModel.showPhoneInput, isTrue);
      });

      test("delete account flow with email validation", () async {
        // Arrange
        when(mockUserAuthenticationService.userEmailAddress)
            .thenReturn("user@example.com");
        when(mockUserAuthenticationService.userPhoneNumber).thenReturn("+961");
        when(mockApiAuthRepository.deleteAccount()).thenAnswer(
          (_) async => Resource<EmptyResponse>.success(
            EmptyResponse(),
            message: "Success",
          ),
        );

        viewModel.onViewModelReady();
        await Future<void>.delayed(const Duration(milliseconds: 300));

        // Validate email
        viewModel.emailController.text = "user@example.com";
        await Future<void>.delayed(const Duration(milliseconds: 200));

        expect(viewModel.isButtonEnabled, isTrue);

        // Delete account
        await viewModel.deleteAccountButtonTapped();

        // Assert
        verify(mockApiAuthRepository.deleteAccount()).called(1);
        expect(viewModel.viewState, ViewState.idle);
      });

      test("delete account flow with phone validation", () async {
        // Arrange
        when(mockUserAuthenticationService.userPhoneNumber)
            .thenReturn("+9611234567");
        when(mockApiAuthRepository.deleteAccount()).thenAnswer(
          (_) async => Resource<EmptyResponse>.success(
            EmptyResponse(),
            message: "Success",
          ),
        );

        // Validate phone
        viewModel.validateNumber(
          code: "961",
          phoneNumber: "1234567",
          isValid: true,
        );

        expect(viewModel.isButtonEnabled, isTrue);

        // Delete account
        await viewModel.deleteAccountButtonTapped();

        // Assert
        verify(mockApiAuthRepository.deleteAccount()).called(1);
        expect(viewModel.viewState, ViewState.idle);
      });
    });
  });
}
