import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetUserInfoUseCase
/// Tests retrieving and updating user information
Future<void> main() async {
  await prepareTest();

  late GetUserInfoUseCase useCase;
  late MockApiAuthRepository mockRepository;
  late MockUserAuthenticationService mockUserAuthService;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockUserAuthService = MockUserAuthenticationService();
    useCase = GetUserInfoUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("GetUserInfoUseCase Tests", () {
    test("execute returns success and updates user auth service", () async {
      // Arrange
      final AuthResponseModel mockAuthResponse = AuthResponseModel(
        accessToken: "test_token",
        refreshToken: "test_refresh",
        userInfo: UserInfoResponseModel(
          firstName: "John",
          lastName: "Doe",
          email: "john.doe@example.com",
          balance: 50,
          currencyCode: "USD",
        ),
      );

      final Resource<AuthResponseModel?> expectedResponse =
      Resource<AuthResponseModel?>.success(mockAuthResponse, message: "Success");

      when(mockRepository.getUserInfo())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.userInfo?.firstName, equals("John"));
      expect(result.data?.userInfo?.email, equals("john.doe@example.com"));

      verify(mockRepository.getUserInfo()).called(1);
    });

    test("execute returns error when repository fails", () async {
      // Arrange
      final Resource<AuthResponseModel?> expectedResponse =
      Resource<AuthResponseModel?>.error("Failed to fetch user info");

      when(mockRepository.getUserInfo())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch user info"));
      expect(result.data, isNull);

      verify(mockRepository.getUserInfo()).called(1);
    });

    test("execute handles null user info data", () async {
      // Arrange
      final Resource<AuthResponseModel?> expectedResponse =
      Resource<AuthResponseModel?>.success(null, message: "No user info available");

      when(mockRepository.getUserInfo())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);

      verify(mockRepository.getUserInfo()).called(1);
    });

    test("execute returns user with complete profile", () async {
      // Arrange
      final AuthResponseModel mockAuthResponse = AuthResponseModel(
        accessToken: "token_123",
        refreshToken: "refresh_123",
        userInfo: UserInfoResponseModel(
          firstName: "Alice",
          lastName: "Johnson",
          email: "alice@example.com",
          msisdn: "+1234567890",
          balance: 100,
          currencyCode: "EUR",
          referralCode: "ALICE123",
          isVerified: true,
          country: "France",
          language: "fr",
        ),
        isVerified: true,
      );

      final Resource<AuthResponseModel?> expectedResponse =
      Resource<AuthResponseModel?>.success(mockAuthResponse, message: null);

      when(mockRepository.getUserInfo())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.userInfo?.firstName, equals("Alice"));
      expect(result.data?.userInfo?.balance, equals(100.0));
      expect(result.data?.userInfo?.referralCode, equals("ALICE123"));
      expect(result.data?.isVerified, equals(true));
    });

    test("execute handles repository exception", () async {
      // Arrange
      when(mockRepository.getUserInfo())
          .thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(NoParams()),
        throwsException,
      );

      verify(mockRepository.getUserInfo()).called(1);
    });

    test("execute with NoParams works correctly", () async {
      // Arrange
      final AuthResponseModel mockAuthResponse = AuthResponseModel(
        userInfo: UserInfoResponseModel(firstName: "Test"),
      );

      final Resource<AuthResponseModel?> expectedResponse =
      Resource<AuthResponseModel?>.success(mockAuthResponse, message: null);

      when(mockRepository.getUserInfo())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result1 =
          await useCase.execute(NoParams());
      final Resource<AuthResponseModel?> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.data?.userInfo?.firstName, equals("Test"));
      expect(result2.data?.userInfo?.firstName, equals("Test"));
      verify(mockRepository.getUserInfo()).called(2);
    });

    test("execute handles user with zero balance", () async {
      // Arrange
      final AuthResponseModel mockAuthResponse = AuthResponseModel(
        userInfo: UserInfoResponseModel(
          firstName: "Bob",
          balance: 0,
          currencyCode: "USD",
        ),
      );

      final Resource<AuthResponseModel?> expectedResponse =
      Resource<AuthResponseModel?>.success(mockAuthResponse, message: null);

      when(mockRepository.getUserInfo())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.userInfo?.balance, equals(0.0));
    });

    test("execute handles unverified user", () async {
      // Arrange
      final AuthResponseModel mockAuthResponse = AuthResponseModel(
        accessToken: "temp_token",
        userInfo: UserInfoResponseModel(
          firstName: "Unverified",
          isVerified: false,
        ),
        isVerified: false,
      );

      final Resource<AuthResponseModel?> expectedResponse =
      Resource<AuthResponseModel?>.success(mockAuthResponse, message: null);

      when(mockRepository.getUserInfo())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.data?.isVerified, equals(false));
      expect(result.data?.userInfo?.isVerified, equals(false));
    });
  });
}
