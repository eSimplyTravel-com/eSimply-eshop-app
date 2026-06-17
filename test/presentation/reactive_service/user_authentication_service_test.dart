import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";
import "../../locator_test.dart";
import "../../locator_test.mocks.dart";

/// Unit tests for UserAuthenticationService - a reactive service that manages user authentication state
///
/// Tests cover:
/// - Service initialization and loading initial values from storage
/// - Saving and updating user authentication response
/// - User information getters (name, email, phone, wallet, etc.)
/// - Login status checking
/// - Clearing user information
/// - Reactive notifications to listeners
Future<void> main() async {
  await prepareTest();

  late UserAuthenticationService authService;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;

    // Default: no stored auth response
    when(mockLocalStorageService.authResponse).thenReturn(null);

    authService = UserAuthenticationService();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("UserAuthenticationService Initialization Tests", () {
    test("initializes with null auth model when storage is empty", () {
      // Assert
      expect(authService.isUserLoggedIn, isFalse);
      expect(authService.userFirstName, isEmpty);
      expect(authService.userLastName, isEmpty);
      expect(authService.userEmailAddress, isEmpty);
      expect(authService.userPhoneNumber, isEmpty);
      expect(authService.walletAvailableBalance, equals(0));
    });

    test("loads initial auth response from storage if available", () async {
      // Arrange
      final AuthResponseModel storedAuth = AuthResponseModel(
        accessToken: "stored_token",
        refreshToken: "stored_refresh",
        userInfo: UserInfoResponseModel(
          firstName: "John",
          lastName: "Doe",
        ),
      );

      when(mockLocalStorageService.authResponse).thenReturn(storedAuth);

      // Act
      final UserAuthenticationService serviceWithStorage =
          UserAuthenticationService();

      // Assert - wait a bit for initialization
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(serviceWithStorage.isUserLoggedIn, isTrue);
      expect(serviceWithStorage.userFirstName, equals("John"));
      expect(serviceWithStorage.userLastName, equals("Doe"));
    });
  });

  group("UserAuthenticationService Save User Response Tests", () {
    test("saves user response and updates reactive state", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "test_access_token",
        refreshToken: "test_refresh_token",
        userInfo: UserInfoResponseModel(
          firstName: "Jane",
          lastName: "Smith",
          email: "jane.smith@example.com",
          msisdn: "+1234567890",
          balance: 100.50,
          currencyCode: "USD",
          referralCode: "REF123",
        ),
        userToken: "user_token_123",
        isVerified: true,
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      verify(mockLocalStorageService.saveLoginResponse(authResponse)).called(1);
      expect(authService.isUserLoggedIn, isTrue);
      expect(authService.userFirstName, equals("Jane"));
      expect(authService.userLastName, equals("Smith"));
      expect(authService.userEmailAddress, equals("jane.smith@example.com"));
      expect(authService.userPhoneNumber, equals("+1234567890"));
      expect(authService.walletAvailableBalance, equals(100.50));
      expect(authService.walletCurrencyCode, equals("USD"));
      expect(authService.referralCode, equals("REF123"));
    });

    test("notifies listeners when user response is saved", () async {
      // Arrange
      int listenerCallCount = 0;
      authService.addListener(() {
        listenerCallCount++;
      });

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "test_token",
        userInfo: UserInfoResponseModel(firstName: "Test"),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(listenerCallCount, greaterThan(0));
    });

    test("handles null user response", () async {
      // Arrange
      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(null);

      // Assert
      verify(mockLocalStorageService.saveLoginResponse(null)).called(1);
      expect(authService.isUserLoggedIn, isFalse);
    });
  });

  group("UserAuthenticationService Update User Response Tests", () {
    test("updates user info while preserving tokens", () async {
      // Arrange - Set initial auth state
      final AuthResponseModel initialAuth = AuthResponseModel(
        accessToken: "original_access_token",
        refreshToken: "original_refresh_token",
        userInfo: UserInfoResponseModel(
          firstName: "John",
          balance: 50,
        ),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      await authService.saveUserResponse(initialAuth);

      // Act - Update with new user info
      final AuthResponseModel updatedUserInfo = AuthResponseModel(
        userInfo: UserInfoResponseModel(
          firstName: "Jane",
          balance: 100,
          email: "jane@example.com",
        ),
        userToken: "new_user_token",
        isVerified: true,
      );

      await authService.updateUserResponse(updatedUserInfo);

      // Assert - Tokens preserved, user info updated
      verify(mockLocalStorageService.saveLoginResponse(any)).called(2);
      expect(authService.userFirstName, equals("Jane"));
      expect(authService.walletAvailableBalance, equals(100.0));
      expect(authService.userEmailAddress, equals("jane@example.com"));
      expect(authService.isUserLoggedIn, isTrue); // Token still exists
    });

    test("notifies listeners when user response is updated", () async {
      // Arrange
      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      await authService.saveUserResponse(
        AuthResponseModel(
          accessToken: "token",
          refreshToken: "refresh",
        ),
      );

      int listenerCallCount = 0;
      authService.addListener(() {
        listenerCallCount++;
      });

      // Act
      await authService.updateUserResponse(
        AuthResponseModel(
          userInfo: UserInfoResponseModel(firstName: "Updated"),
        ),
      );

      // Assert
      expect(listenerCallCount, greaterThan(0));
    });

    test("handles update with null user info", () async {
      // Arrange
      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      await authService.saveUserResponse(
        AuthResponseModel(
          accessToken: "token",
          refreshToken: "refresh",
          userInfo: UserInfoResponseModel(firstName: "Original"),
        ),
      );

      // Act
      await authService.updateUserResponse(null);

      // Assert
      verify(mockLocalStorageService.saveLoginResponse(any)).called(2);
    });
  });

  group("UserAuthenticationService User Info Getters Tests", () {
    test("returns correct user information from auth model", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "token",
        userInfo: UserInfoResponseModel(
          firstName: "Alice",
          lastName: "Johnson",
          email: "alice@example.com",
          msisdn: "+9876543210",
          balance: 250.75,
          currencyCode: "EUR",
          referralCode: "ALICE123",
        ),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.userFirstName, equals("Alice"));
      expect(authService.userLastName, equals("Johnson"));
      expect(authService.userEmailAddress, equals("alice@example.com"));
      expect(authService.userPhoneNumber, equals("+9876543210"));
      expect(authService.walletAvailableBalance, equals(250.75));
      expect(authService.walletCurrencyCode, equals("EUR"));
      expect(authService.referralCode, equals("ALICE123"));
    });

    test("returns default values when user info is null", () {
      // Assert
      expect(authService.userFirstName, isEmpty);
      expect(authService.userLastName, isEmpty);
      expect(authService.userEmailAddress, isEmpty);
      expect(authService.userPhoneNumber, isEmpty);
      expect(authService.walletAvailableBalance, equals(0));
      expect(authService.walletCurrencyCode, isEmpty);
      expect(authService.referralCode, isEmpty);
    });

    test("returns default values when specific properties are null", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "token",
        userInfo: UserInfoResponseModel(
          // All properties null/omitted
        ),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.userFirstName, isEmpty);
      expect(authService.userLastName, isEmpty);
      expect(authService.walletAvailableBalance, equals(0));
    });
  });

  group("UserAuthenticationService Login Status Tests", () {
    test("returns true when access token exists and is not empty", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "valid_token",
        userInfo: UserInfoResponseModel(firstName: "Test"),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.isUserLoggedIn, isTrue);
    });

    test("returns false when access token is null", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        userInfo: UserInfoResponseModel(firstName: "Test"),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.isUserLoggedIn, isFalse);
    });

    test("returns false when access token is empty string", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "",
        userInfo: UserInfoResponseModel(firstName: "Test"),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.isUserLoggedIn, isFalse);
    });

    test("returns false when auth model is null", () {
      // Assert
      expect(authService.isUserLoggedIn, isFalse);
    });
  });

  group("UserAuthenticationService Clear User Info Tests", () {
    test("clears user info and storage", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "token_to_clear",
        userInfo: UserInfoResponseModel(
          firstName: "ToBeCleared",
          balance: 100,
        ),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());
      when(mockLocalStorageService.clear())
          .thenAnswer((_) async => Future<void>.value());

      await authService.saveUserResponse(authResponse);
      expect(authService.isUserLoggedIn, isTrue);

      // Act
      await authService.clearUserInfo();

      // Assert
      verify(mockLocalStorageService.clear()).called(1);
      expect(authService.isUserLoggedIn, isFalse);
      expect(authService.userFirstName, isEmpty);
      expect(authService.walletAvailableBalance, equals(0));
    });

    test("notifies listeners when user info is cleared", () async {
      // Arrange
      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());
      when(mockLocalStorageService.clear())
          .thenAnswer((_) async => Future<void>.value());

      await authService.saveUserResponse(
        AuthResponseModel(
          accessToken: "token",
          userInfo: UserInfoResponseModel(firstName: "Test"),
        ),
      );

      int listenerCallCount = 0;
      authService.addListener(() {
        listenerCallCount++;
      });

      // Act
      await authService.clearUserInfo();

      // Assert
      expect(listenerCallCount, greaterThan(0));
    });

    test("handles clear when already empty", () async {
      // Arrange
      when(mockLocalStorageService.clear())
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.clearUserInfo();

      // Assert
      verify(mockLocalStorageService.clear()).called(1);
      expect(authService.isUserLoggedIn, isFalse);
    });
  });

  group("UserAuthenticationService Reactive Behavior Tests", () {
    test("multiple operations trigger listeners correctly", () async {
      // Arrange
      int listenerCallCount = 0;
      authService.addListener(() {
        listenerCallCount++;
      });

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());
      when(mockLocalStorageService.clear())
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(
        AuthResponseModel(
          accessToken: "token1",
          userInfo: UserInfoResponseModel(firstName: "First"),
        ),
      );
      await authService.updateUserResponse(
        AuthResponseModel(
          userInfo: UserInfoResponseModel(firstName: "Second"),
        ),
      );
      await authService.clearUserInfo();

      // Assert
      expect(listenerCallCount, greaterThan(2));
    });
  });

  group("UserAuthenticationService Edge Cases Tests", () {
    test("handles very long string values", () async {
      // Arrange
      final String longString = "A" * 1000;
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: longString,
        userInfo: UserInfoResponseModel(
          firstName: longString,
          email: "$longString@example.com",
        ),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.isUserLoggedIn, isTrue);
      expect(authService.userFirstName.length, equals(1000));
    });

    test("handles special characters in user data", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "token",
        userInfo: UserInfoResponseModel(
          firstName: "José",
          lastName: "Müller",
          email: "test+special@example.com",
          msisdn: "+1-234-567-8900",
        ),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.userFirstName, equals("José"));
      expect(authService.userLastName, equals("Müller"));
      expect(authService.userEmailAddress, equals("test+special@example.com"));
      expect(authService.userPhoneNumber, equals("+1-234-567-8900"));
    });

    test("handles zero and negative wallet balance", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "token",
        userInfo: UserInfoResponseModel(
          balance: -10.5,
        ),
      );

      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await authService.saveUserResponse(authResponse);

      // Assert
      expect(authService.walletAvailableBalance, equals(-10.5));
    });

    test("handles rapid successive updates", () async {
      // Arrange
      when(mockLocalStorageService.saveLoginResponse(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      for (int i = 0; i < 10; i++) {
        await authService.saveUserResponse(
          AuthResponseModel(
            accessToken: "token_$i",
            userInfo: UserInfoResponseModel(firstName: "User$i"),
          ),
        );
      }

      // Assert
      expect(authService.userFirstName, equals("User9"));
      expect(authService.isUserLoggedIn, isTrue);
    });
  });
}
