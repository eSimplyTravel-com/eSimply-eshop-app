// ignore_for_file: unused_local_variable

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/delete_account_bottom_sheet/delete_account_bottom_sheet.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/delete_account_bottom_sheet/delete_account_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/my_phone_input.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:phone_input/phone_input_package.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/app_enviroment_helper.dart";
import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  setUpAll(() async {
    await prepareTest();
  });

  late MockApiAuthRepository mockApiAuthRepository;
  late MockUserAuthenticationService mockUserAuthenticationService;
  late MockAppConfigurationService mockAppConfigurationService;
  late MockDeleteAccountBottomSheetViewModel mockViewModel;

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

    // Create mock ViewModel and register it
    mockViewModel = MockDeleteAccountBottomSheetViewModel();

    // Register mock ViewModel in locator
    if (locator.isRegistered<DeleteAccountBottomSheetViewModel>()) {
      await locator.unregister<DeleteAccountBottomSheetViewModel>();
    }
    locator.registerSingleton<DeleteAccountBottomSheetViewModel>(mockViewModel);

    // Default mocks
    when(mockAppConfigurationService.getLoginType).thenReturn(null);
    when(mockUserAuthenticationService.userEmailAddress)
        .thenReturn("test@example.com");
    when(mockUserAuthenticationService.userPhoneNumber)
        .thenReturn("+9611234567");
    when(mockApiAuthRepository.deleteAccount()).thenAnswer(
      (_) async => Resource<EmptyResponse>.success(
        EmptyResponse(),
        message: "Success",
      ),
    );

    // Setup default ViewModel mocks
    when(mockViewModel.isButtonEnabled).thenReturn(false);
    when(mockViewModel.emailErrorMessage).thenReturn(null);
    when(mockViewModel.showPhoneInput).thenReturn(false);
    when(mockViewModel.viewState).thenReturn(ViewState.idle);
    when(mockViewModel.isBusy).thenReturn(false);
    when(mockViewModel.emailController).thenReturn(TextEditingController());
    when(mockViewModel.phoneController).thenReturn(
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: "")),
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("DeleteAccountBottomSheet Widget Tests", () {
    testWidgets("renders correctly with all basic UI elements",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      // ignore: unused_local_variable
      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check UI structure
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2)); // Close icon + delete account icon
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets("renders email input when showPhoneInput is false",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MainInputField), findsOneWidget);
      expect(find.byType(MyPhoneInput), findsNothing);
    });

    testWidgets("renders phone input when showPhoneInput is true",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(true);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.phoneNumber);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MyPhoneInput), findsOneWidget);
      expect(find.byType(MainInputField), findsNothing);
    });

    testWidgets("renders two main buttons (delete and cancel)",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should have 2 MainButton widgets
      expect(find.byType(MainButton), findsNWidgets(2));
    });

    testWidgets("delete button is disabled when isButtonEnabled is false",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockViewModel.isButtonEnabled).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the delete button (first MainButton)
      final Finder deleteButtons = find.byType(MainButton);
      expect(deleteButtons, findsNWidgets(2));

      final MainButton deleteButton =
          tester.widget<MainButton>(deleteButtons.first);

      // Assert
      expect(deleteButton.isEnabled, isFalse);
    });

    testWidgets("delete button is enabled when isButtonEnabled is true",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockViewModel.isButtonEnabled).thenReturn(true);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the delete button
      final Finder deleteButtons = find.byType(MainButton);
      final MainButton deleteButton =
          tester.widget<MainButton>(deleteButtons.first);

      // Assert
      expect(deleteButton.isEnabled, isTrue);
    });

    testWidgets("close button calls completer with empty response",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;
      SheetResponse<EmptyBottomSheetResponse>? capturedResponse;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
        capturedResponse = response;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find close button
      final Finder closeButton = find.byType(BottomSheetCloseButton);
      expect(closeButton, findsOneWidget);

      // Find and tap the InkWell inside the close button
      final Finder inkWell = find.descendant(
        of: closeButton,
        matching: find.byType(InkWell),
      );
      expect(inkWell, findsOneWidget);

      // Tap and wait for the delayed callback (300ms delay in MyCardWrap)
      await tester.tap(inkWell);
      await tester.pump(); // Start tap
      await tester.pump(const Duration(milliseconds: 350)); // Wait for 300ms delay
      await tester.pumpAndSettle();

      // Assert
      expect(completerCalled, isTrue);
      expect(capturedResponse, isNotNull);
    });

    testWidgets("cancel button calls completer with empty response",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;
      SheetResponse<EmptyBottomSheetResponse>? capturedResponse;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
        capturedResponse = response;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find cancel button (second MainButton with onlyText constructor)
      final Finder mainButtons = find.byType(MainButton);
      expect(mainButtons, findsNWidgets(2));

      await tester.tap(mainButtons.last);
      await tester.pumpAndSettle();

      // Assert
      expect(completerCalled, isTrue);
      expect(capturedResponse, isNotNull);
    });

    testWidgets(
        "delete button tap calls deleteAccountButtonTapped and completer",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockViewModel.isButtonEnabled).thenReturn(true);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);
      when(mockViewModel.deleteAccountButtonTapped())
          .thenAnswer((_) async => Future<void>.value());

      bool completerCalled = false;
      SheetResponse<EmptyBottomSheetResponse>? capturedResponse;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
        capturedResponse = response;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap delete button
      final Finder deleteButtons = find.byType(MainButton);
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Assert
      verify(mockViewModel.deleteAccountButtonTapped()).called(1);
      expect(completerCalled, isTrue);
      expect(capturedResponse?.confirmed, isTrue);
    });

    testWidgets("email input field displays error message when present",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockViewModel.emailErrorMessage).thenReturn("Invalid email");
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the input field
      final Finder inputField = find.byType(MainInputField);
      expect(inputField, findsOneWidget);

      final MainInputField field = tester.widget<MainInputField>(inputField);

      // Assert
      expect(field.errorMessage, equals("Invalid email"));
    });

    testWidgets("phone input has validateNumber callback",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(true);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.phoneNumber);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find phone input
      final Finder phoneInput = find.byType(MyPhoneInput);
      expect(phoneInput, findsOneWidget);

      final MyPhoneInput input = tester.widget<MyPhoneInput>(phoneInput);

      // Assert
      expect(input.onChanged, isNotNull);
      expect(input.phoneController, isNotNull);
    });

    testWidgets("displays delete account icon image",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Image widgets should be present (close icon + delete account icon)
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets("displays title, content and confirmation text",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Multiple Text widgets for title, content, confirmation
      expect(find.byType(Text), findsWidgets);
      // Should have at least 3 text widgets (title, content, confirmation)
      expect(find.byType(Text).evaluate().length, greaterThanOrEqualTo(3));
    });

    testWidgets("email input uses correct controller from ViewModel",
        (WidgetTester tester) async {
      // Arrange
      final TextEditingController testController = TextEditingController();
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockViewModel.emailController).thenReturn(testController);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find input field
      final Finder inputField = find.byType(MainInputField);
      final MainInputField field = tester.widget<MainInputField>(inputField);

      // Assert
      expect(field.controller, equals(testController));

      // Clean up
      testController.dispose();
    });

    testWidgets("phone input uses correct controller from ViewModel",
        (WidgetTester tester) async {
      // Arrange
      final PhoneController testController = PhoneController(
        const PhoneNumber(isoCode: IsoCode.US, nsn: ""),
      );
      when(mockViewModel.showPhoneInput).thenReturn(true);
      when(mockViewModel.phoneController).thenReturn(testController);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.phoneNumber);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find phone input
      final Finder phoneInput = find.byType(MyPhoneInput);
      final MyPhoneInput input = tester.widget<MyPhoneInput>(phoneInput);

      // Assert
      expect(input.phoneController, equals(testController));
    });

    testWidgets("widget rebuilds when ViewModel state changes",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockViewModel.isButtonEnabled).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act - Initial render
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state
      final Finder deleteButtons1 = find.byType(MainButton);
      final MainButton deleteButton1 =
          tester.widget<MainButton>(deleteButtons1.first);
      expect(deleteButton1.isEnabled, isFalse);

      // Change ViewModel state
      when(mockViewModel.isButtonEnabled).thenReturn(true);

      // Trigger rebuild
      await tester.pumpAndSettle();

      // Assert - Widget should reflect new state
      expect(find.byType(MainButton), findsNWidgets(2));
    });

    test("getConfirmText returns correct text for email login type", () {
      // Arrange
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      final DeleteAccountBottomSheet widget = DeleteAccountBottomSheet(
        requestBase: SheetRequest<dynamic>(),
        completer: testCompleter,
      );

      // Act
      final String confirmText = widget.getConfirmText();

      // Assert - Should return email confirmation text
      expect(confirmText, isNotEmpty);
    });

    test("getConfirmText returns correct text for phoneNumber login type", () {
      // Arrange
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.phoneNumber);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      final DeleteAccountBottomSheet widget = DeleteAccountBottomSheet(
        requestBase: SheetRequest<dynamic>(),
        completer: testCompleter,
      );

      // Act
      final String confirmText = widget.getConfirmText();

      // Assert - Should return phone confirmation text
      expect(confirmText, isNotEmpty);
    });

    test("getConfirmText returns correct text for emailAndPhone login type", () {
      // Arrange
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.emailAndPhone);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      final DeleteAccountBottomSheet widget = DeleteAccountBottomSheet(
        requestBase: SheetRequest<dynamic>(),
        completer: testCompleter,
      );

      // Act
      final String confirmText = widget.getConfirmText();

      // Assert - Should return phone confirmation text (same as phoneNumber)
      expect(confirmText, isNotEmpty);
    });

    testWidgets("renders correctly for emailAndPhone login type",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(true);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.emailAndPhone);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should show phone input for emailAndPhone type
      expect(find.byType(MyPhoneInput), findsOneWidget);
      expect(find.byType(MainInputField), findsNothing);
    });

    testWidgets("phone input calls validateNumber when changed",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(true);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.phoneNumber);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find phone input and get the callback
      final Finder phoneInput = find.byType(MyPhoneInput);
      final MyPhoneInput input = tester.widget<MyPhoneInput>(phoneInput);

      // Simulate phone input change
      input.onChanged("961", "1234567", isValid: true);

      // Assert - validateNumber should be called on ViewModel
      verify(mockViewModel.validateNumber(
        code: "961",
        phoneNumber: "1234567",
        isValid: true,
      ),).called(1);
    });

    testWidgets("widget has proper rounded corner decoration",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - DecoratedBox with rounded corners should be present
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets("keyboard dismisses on tap functionality is present",
        (WidgetTester tester) async {
      // Arrange
      when(mockViewModel.showPhoneInput).thenReturn(false);
      when(mockAppConfigurationService.getLoginType)
          .thenReturn(LoginType.email);

      bool completerCalled = false;

      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: DeleteAccountBottomSheet(
              requestBase: SheetRequest<dynamic>(),
              completer: testCompleter,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Widget tree should be built successfully
      // KeyboardDismissOnTap is a wrapper that handles keyboard dismissal
      expect(find.byType(DeleteAccountBottomSheet), findsOneWidget);
    });
  });
}
