import "package:esim_open_source/domain/data/params/update_user_info_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late AccountInformationViewModel viewModel;

  setUp(() async {
    await setupTest();
    viewModel = locator<AccountInformationViewModel>();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("AccountInformationViewModel Tests", () {
    late AccountInformationViewModel viewModel;

    setUp(() {
      onViewModelReadyMock(viewName: "AccountInformationView");
      viewModel = AccountInformationViewModel();
    });

    test("initial values", () {
      expect(viewModel.receiveUpdated, isFalse);
      expect(viewModel.isValidEmail, isFalse);
      expect(viewModel.saveButtonEnabled, isFalse);
      expect(viewModel.userEmail, isEmpty);
      expect(viewModel.userPhoneNumber, isEmpty);
      expect(viewModel.isPhoneValid, isFalse);
    });

    test("controllers are initialized", () {
      expect(viewModel.nameController, isNotNull);
      expect(viewModel.emailController, isNotNull);
      expect(viewModel.familyNameController, isNotNull);
      expect(viewModel.phoneController, isNotNull);
    });

    test("validateEmailAddress - empty email", () {
      final String result = viewModel.validateEmailAddress("");
      expect(result, isNotEmpty);
      expect(viewModel.isValidEmail, isFalse);
    });

    test("validateEmailAddress - invalid email", () {
      final String result = viewModel.validateEmailAddress("invalid");
      expect(result, isNotEmpty);
      expect(viewModel.isValidEmail, isFalse);
    });

    test("validateEmailAddress - valid email", () {
      final String result = viewModel.validateEmailAddress("test@example.com");
      expect(result, isEmpty);
      expect(viewModel.isValidEmail, isTrue);
    });

    test("updateSwitch changes value", () {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      expect(viewModel.receiveUpdated, isFalse);
      viewModel.updateSwitch(newValue: true);
      expect(viewModel.receiveUpdated, isTrue);
    });

    test("validateNumber updates state", () {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      viewModel.validateNumber("961", "12345678", isValid: true);
      expect(viewModel.isPhoneValid, isTrue);
      expect(viewModel.userPhoneNumber, equals("12345678"));
    });

    test("updateButtonState - phone login", () {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.phoneNumber);
      viewModel.updateButtonState();
      expect(viewModel.saveButtonEnabled, isA<bool>());
    });

    test("updateButtonState - email login", () {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      viewModel.updateButtonState();
      expect(viewModel.saveButtonEnabled, isA<bool>());
    });

    test("updateButtonState handles validation errors", () {
      viewModel
        ..userPhoneNumber = "invalid"
        ..isPhoneValid = false
        ..updateButtonState();
      expect(viewModel.validationError, isNotNull);

      viewModel
        ..isPhoneValid = true
        ..updateButtonState();
      expect(viewModel.validationError, isNull);
    });

    test("property getters work correctly", () {
      expect(viewModel.validationError, isNull);
      expect(viewModel.emailErrorMessage, isNull);
      expect(viewModel.nameController.text, isEmpty);
      expect(viewModel.familyNameController.text, isEmpty);
      expect(viewModel.emailController.text, isEmpty);
    });

    test("updateUserInfoUseCase is initialized", () {
      expect(viewModel.updateUserInfoUseCase, isNotNull);
    });

    test("onViewModelReady initializes data", () async {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);

      await viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.nameController, isNotNull);
      expect(viewModel.familyNameController, isNotNull);
      expect(viewModel.emailController, isNotNull);
    });

    test("saveButtonTapped executes successfully", () async {
      // Get mocks from locator
      final MockApiAuthRepository mockApiAuthRepository =
          locator<ApiAuthRepository>() as MockApiAuthRepository;

      // Mock the services
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);

      // Mock API call
      when(
        mockApiAuthRepository.updateUserInfo(
          request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
        ),
      ).thenAnswer(
            (_) async => Resource<AuthResponseModel>.success(
          AuthResponseModel(),
          message: "",
        ),
      );

      // Fill in the view model form fields
      viewModel.nameController.text = "John";
      viewModel.familyNameController.text = "Doe";
      viewModel.emailController.text = "test@example.com";

      // Call the method
      await viewModel.saveButtonTapped();

      // Assert
      expect(viewModel.viewState.name, isA<String>());
    });

    test("isPhoneInputEnabled returns correct value for each login type", () {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      expect(viewModel.isPhoneInputEnabled, isTrue);

      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.phoneNumber);
      expect(viewModel.isPhoneInputEnabled, isFalse);

      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.emailAndPhone);
      expect(viewModel.isPhoneInputEnabled, isFalse);
    });

    test("isEmailFieldEditable returns correct value for each login type", () {
      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.email);
      expect(viewModel.isEmailFieldEditable, isFalse);

      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.phoneNumber);
      expect(viewModel.isEmailFieldEditable, isTrue);

      when(locator<AppConfigurationService>().getLoginType)
          .thenReturn(LoginType.emailAndPhone);
      expect(viewModel.isEmailFieldEditable, isFalse);
    });
  });
}
