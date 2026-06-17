// api_auth_repository_impl_test.dart

import "dart:async";

import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/otp_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/resend_otp_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/data/repository/api_auth_repository_impl.dart";
import "package:esim_open_source/domain/data/api_auth.dart";
import "package:esim_open_source/domain/data/params/update_user_info_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "api_auth_repository_impl_test.mocks.dart";

// Test implementations for listener interfaces
class TestUnauthorizedAccessListener implements UnauthorizedAccessListener {
  @override
  void onUnauthorizedAccessCallBackUseCase(
    http.BaseResponse? response,
    Exception? e,
  ) {}
}

class TestAuthReloadListener implements AuthReloadListener {
  @override
  void onAuthReloadListenerCallBackUseCase(
      AuthResponseModel? authResponse,
  ) {}
}

@GenerateMocks(<Type>[APIAuth])
void main() {
  late ApiAuthRepository repository;
  late MockAPIAuth mockApiAuth;

  setUp(() {
    mockApiAuth = MockAPIAuth();
    repository = ApiAuthRepositoryImpl(mockApiAuth);
  });

  group("ApiAuthRepositoryImpl", () {
    group("login", () {
      const String testEmail = "test@example.com";
      const String testPhone = "+1234567890";

      test("should return success resource when login with email succeeds",
          () async {
        // Arrange
        final OtpResponseModelDto expectedResponse = OtpResponseModelDto(
          otpExpiration: 300, // 5 minutes
        );
        final ResponseMainDto<OtpResponseModelDto?> responseMain =
            ResponseMainDto<OtpResponseModelDto?>.createErrorWithData(
          data: expectedResponse,
          message: "OTP sent successfully",
          statusCode: 200,
        );

        when(
          mockApiAuth.login(email: testEmail, phoneNumber: null),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<OtpResponseModel?> result = await repository.login(
          email: testEmail,
          phoneNumber: null,
        ) as Resource<OtpResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.otpExpiration, 300);
        expect(result.message, "OTP sent successfully");
        expect(result.error, isNull);

        verify(mockApiAuth.login(email: testEmail, phoneNumber: null))
            .called(1);
      });

      test("should return success resource when login with phone succeeds",
          () async {
        // Arrange
        final OtpResponseModelDto expectedResponse = OtpResponseModelDto(
          otpExpiration: 300, // 5 minutes
        );
        final ResponseMainDto<OtpResponseModelDto?> responseMain =
            ResponseMainDto<OtpResponseModelDto?>.createErrorWithData(
          data: expectedResponse,
          message: "OTP sent to phone",
          statusCode: 200,
        );

        when(
          mockApiAuth.login(email: null, phoneNumber: testPhone),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<OtpResponseModel?> result = await repository.login(
          email: null,
          phoneNumber: testPhone,
        ) as Resource<OtpResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.otpExpiration, 300);
        expect(result.message, "OTP sent to phone");

        verify(mockApiAuth.login(email: null, phoneNumber: testPhone))
            .called(1);
      });

      test("should return error resource when login fails", () async {
        // Arrange
        final ResponseMainDto<OtpResponseModelDto?> responseMain =
            ResponseMainDto<OtpResponseModelDto?>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid email format",
          title: "Invalid email format",
        );

        when(
          mockApiAuth.login(email: testEmail, phoneNumber: null),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<OtpResponseModel?> result = await repository.login(
          email: testEmail,
          phoneNumber: null,
        ) as Resource<OtpResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid email format");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiAuth.login(email: testEmail, phoneNumber: null))
            .called(1);
      });

      test("should handle both email and phone null", () async {
        // Arrange
        final ResponseMainDto<OtpResponseModelDto?> responseMain =
            ResponseMainDto<OtpResponseModelDto?>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Email or phone required",
          title: "Email or phone required",
        );

        when(
          mockApiAuth.login(email: null, phoneNumber: null),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<OtpResponseModel?> result = await repository.login(
          email: null,
          phoneNumber: null,
        ) as Resource<OtpResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Email or phone required");

        verify(mockApiAuth.login(email: null, phoneNumber: null)).called(1);
      });
    });

    group("logout", () {
      test("should return success resource when logout succeeds", () async {
        // Arrange
        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Logged out successfully",
          statusCode: 200,
        );

        when(mockApiAuth.logout()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse> result =
            await repository.logout() as Resource<EmptyResponse>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());
        expect(result.message, "Logged out successfully");
        expect(result.error, isNull);

        verify(mockApiAuth.logout()).called(1);
      });

      test("should return error resource when logout fails", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Unauthorized",
          title: "Unauthorized",
        );

        when(mockApiAuth.logout()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse> result =
            await repository.logout() as Resource<EmptyResponse>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Unauthorized");
        expect(result.data, isNull);

        verify(mockApiAuth.logout()).called(1);
      });
    });

    group("resendOtp", () {
      const String testEmail = "test@example.com";

      test("should return success resource when resend OTP succeeds",
          () async {
        // Arrange
        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "OTP resent successfully",
          statusCode: 200,
        );

        when(
          mockApiAuth.resendOtp(email: testEmail),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.resendOtp(
          email: testEmail,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());
        expect(result.message, "OTP resent successfully");
        expect(result.error, isNull);

        verify(mockApiAuth.resendOtp(email: testEmail)).called(1);
      });

      test("should return error resource when resend OTP fails", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 429,
          developerMessage: "Too many requests",
          title: "Too many requests",
        );

        when(
          mockApiAuth.resendOtp(email: testEmail),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.resendOtp(
          email: testEmail,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Too many requests");
        expect(result.data, isNull);

        verify(mockApiAuth.resendOtp(email: testEmail)).called(1);
      });

      test("should handle empty email parameter", () async {
        // Arrange
        const String emptyEmail = "";
        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiAuth.resendOtp(email: emptyEmail),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.resendOtp(
          email: emptyEmail,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        verify(mockApiAuth.resendOtp(email: emptyEmail)).called(1);
      });
    });

    group("resendOtpNewChannel", () {
      const String testEmail = "test@example.com";
      const String testPhone = "+1234567890";
      const String testChannel = "SMS";

      test(
          "should return success resource when resend via new channel with email succeeds",
          () async {
        // Arrange — mock the API contract (DTO) with the impl's nullable inner
        final ResendOtpResponseModelDto expectedResponse =
            ResendOtpResponseModelDto(
          status: "success",
          message: "OTP sent via SMS",
          data: "otp-reference-123",
          responseCode: 200,
        );
        final ResponseMainDto<ResendOtpResponseModelDto?> responseMain =
            ResponseMainDto<ResendOtpResponseModelDto?>.createErrorWithData(
          data: expectedResponse,
          message: "OTP sent via SMS",
          statusCode: 200,
        );

        when(
          mockApiAuth.resendOtpNewChannel(
            email: testEmail,
            phone: null,
            otpChannel: testChannel,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act — repo converts to the domain model
        final Resource<ResendOtpResponseModel?> result =
            await repository.resendOtpNewChannel(
          email: testEmail,
          phone: null,
          otpChannel: testChannel,
        );

        // Assert — field-level, since data is a fresh domain instance
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.status, "success");
        expect(result.data?.message, "OTP sent via SMS");
        expect(result.data?.data, "otp-reference-123");
        expect(result.message, "OTP sent via SMS");
        expect(result.error, isNull);

        verify(
          mockApiAuth.resendOtpNewChannel(
            email: testEmail,
            phone: null,
            otpChannel: testChannel,
          ),
        ).called(1);
      });

      test(
          "should return success resource when resend via new channel with phone succeeds",
          () async {
        // Arrange
        final ResendOtpResponseModelDto expectedResponse =
            ResendOtpResponseModelDto(
          status: "success",
          message: "OTP sent via SMS to phone",
        );
        final ResponseMainDto<ResendOtpResponseModelDto?> responseMain =
            ResponseMainDto<ResendOtpResponseModelDto?>.createErrorWithData(
          data: expectedResponse,
          message: "OTP sent via SMS to phone",
          statusCode: 200,
        );

        when(
          mockApiAuth.resendOtpNewChannel(
            email: null,
            phone: testPhone,
            otpChannel: testChannel,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<ResendOtpResponseModel?> result =
            await repository.resendOtpNewChannel(
          email: null,
          phone: testPhone,
          otpChannel: testChannel,
        );

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.message, "OTP sent via SMS to phone");

        verify(
          mockApiAuth.resendOtpNewChannel(
            email: null,
            phone: testPhone,
            otpChannel: testChannel,
          ),
        ).called(1);
      });

      test(
          "should return success resource with null data when API returns 200 with null data",
          () async {
        // Arrange — a 200 with data: null is a valid success, not an error
        final ResponseMainDto<ResendOtpResponseModelDto?> responseMain =
            ResponseMainDto<ResendOtpResponseModelDto?>.createErrorWithData(
          message: "OTP sent",
          statusCode: 200,
        );

        when(
          mockApiAuth.resendOtpNewChannel(
            email: testEmail,
            phone: null,
            otpChannel: testChannel,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<ResendOtpResponseModel?> result =
            await repository.resendOtpNewChannel(
          email: testEmail,
          phone: null,
          otpChannel: testChannel,
        );

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNull);
        expect(result.error, isNull);
      });

      test("should return error resource when resend via new channel fails",
          () async {
        // Arrange
        final ResponseMainDto<ResendOtpResponseModelDto?> responseMain =
            ResponseMainDto<ResendOtpResponseModelDto?>.createErrorWithData(
          statusCode: 429,
          developerMessage: "Too many requests",
          title: "Too many requests",
        );

        when(
          mockApiAuth.resendOtpNewChannel(
            email: testEmail,
            phone: null,
            otpChannel: testChannel,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<ResendOtpResponseModel?> result =
            await repository.resendOtpNewChannel(
          email: testEmail,
          phone: null,
          otpChannel: testChannel,
        );

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Too many requests");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiAuth.resendOtpNewChannel(
            email: testEmail,
            phone: null,
            otpChannel: testChannel,
          ),
        ).called(1);
      });
    });

    group("verifyOtp", () {
      const String testEmail = "test@example.com";
      const String testPhone = "+1234567890";
      const String testPinCode = "123456";
      const String testProviderToken = "google-token-123";
      const String testProviderType = "google";

      test(
          "should return success resource when OTP verification with email succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "access-token-123",
          refreshToken: "refresh-token-456",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "OTP verified successfully",
          statusCode: 200,
        );

        when(
          mockApiAuth.verifyOtp(
            email: testEmail,
            pinCode: testPinCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.verifyOtp(
          email: testEmail,
          pinCode: testPinCode,
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, "access-token-123");
        expect(result.data?.refreshToken, "refresh-token-456");
        expect(result.message, "OTP verified successfully");
        expect(result.error, isNull);

        verify(
          mockApiAuth.verifyOtp(
            email: testEmail,
            pinCode: testPinCode,
          ),
        ).called(1);
      });

      test(
          "should return success resource when OTP verification with phone succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "access-token-123",
          refreshToken: "refresh-token-456",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "Phone verified",
          statusCode: 200,
        );

        when(
          mockApiAuth.verifyOtp(
            phoneNumber: testPhone,
            pinCode: testPinCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.verifyOtp(
          phoneNumber: testPhone,
          pinCode: testPinCode,
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, expectedResponse.accessToken);
        expect(result.data?.refreshToken, expectedResponse.refreshToken);
        expect(result.message, "Phone verified");

        verify(
          mockApiAuth.verifyOtp(
            phoneNumber: testPhone,
            pinCode: testPinCode,
          ),
        ).called(1);
      });

      test(
          "should return success resource when social login verification succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "access-token-social",
          refreshToken: "refresh-token-social",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "Social login successful",
          statusCode: 200,
        );

        when(
          mockApiAuth.verifyOtp(
            email: testEmail,
            providerToken: testProviderToken,
            providerType: testProviderType,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.verifyOtp(
          email: testEmail,
          providerToken: testProviderToken,
          providerType: testProviderType,
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, expectedResponse.accessToken);
        expect(result.data?.refreshToken, expectedResponse.refreshToken);
        expect(result.message, "Social login successful");

        verify(
          mockApiAuth.verifyOtp(
            email: testEmail,
            providerToken: testProviderToken,
            providerType: testProviderType,
          ),
        ).called(1);
      });

      test("should return error resource when OTP verification fails",
          () async {
        // Arrange
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid OTP",
          title: "Invalid OTP",
        );

        when(
          mockApiAuth.verifyOtp(
            email: testEmail,
            pinCode: testPinCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.verifyOtp(
          email: testEmail,
          pinCode: testPinCode,
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid OTP");
        expect(result.data, isNull);

        verify(
          mockApiAuth.verifyOtp(
            email: testEmail,
            pinCode: testPinCode,
          ),
        ).called(1);
      });

      test("should handle incorrect OTP code", () async {
        // Arrange
        const String wrongPinCode = "000000";
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          statusCode: 401,
          developerMessage: "OTP does not match",
          title: "OTP does not match",
        );

        when(
          mockApiAuth.verifyOtp(
            email: testEmail,
            pinCode: wrongPinCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.verifyOtp(
          email: testEmail,
          pinCode: wrongPinCode,
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "OTP does not match");

        verify(
          mockApiAuth.verifyOtp(
            email: testEmail,
            pinCode: wrongPinCode,
          ),
        ).called(1);
      });
    });

    group("deleteAccount", () {
      test("should return success resource when account deletion succeeds",
          () async {
        // Arrange
        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Account deleted successfully",
          statusCode: 200,
        );

        when(mockApiAuth.deleteAccount())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse> result =
            await repository.deleteAccount() as Resource<EmptyResponse>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());
        expect(result.message, "Account deleted successfully");
        expect(result.error, isNull);

        verify(mockApiAuth.deleteAccount()).called(1);
      });

      test("should return error resource when account deletion fails",
          () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 403,
          developerMessage: "Cannot delete account with active orders",
          title: "Cannot delete account with active orders",
        );

        when(mockApiAuth.deleteAccount())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse> result =
            await repository.deleteAccount() as Resource<EmptyResponse>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Cannot delete account with active orders");
        expect(result.data, isNull);

        verify(mockApiAuth.deleteAccount()).called(1);
      });
    });

    group("updateUserInfo", () {
      const String testEmail = "updated@example.com";
      const String testPhone = "+9876543210";
      const String testFirstName = "John";
      const String testLastName = "Doe";
      const String testCurrencyCode = "USD";
      const String testLanguageCode = "en";

      test("should return success resource when user info update succeeds", () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "updated-token",
          refreshToken: "updated-refresh",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
        ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "User info updated successfully",
          statusCode: 200,
        );

        // Use anyNamed("request") to match any UpdateUserInfoRequest
        when(
          mockApiAuth.updateUserInfo(request: anyNamed("request")),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result =
        await repository.updateUserInfo(
          request: UpdateUserInfoRequest(
            email: testEmail,
            msisdn: testPhone,
            firstName: testFirstName,
            lastName: testLastName,
            currencyCode: testCurrencyCode,
            languageCode: testLanguageCode,
          ),
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, expectedResponse.accessToken);
        expect(result.data?.refreshToken, expectedResponse.refreshToken);
        expect(result.message, "User info updated successfully");
        expect(result.error, isNull);

        verify(mockApiAuth.updateUserInfo(request: anyNamed("request"))).called(1);
      });

      test("should return error resource when user info update fails", () async {
        // Arrange
        final ResponseMainDto<AuthResponseModelDto> responseMain =
        ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          statusCode: 422,
          developerMessage: "Invalid email format",
          title: "Invalid email format",
        );

        when(
          mockApiAuth.updateUserInfo(request: anyNamed("request")),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result =
        await repository.updateUserInfo(
          request: UpdateUserInfoRequest(
            email: testEmail,
            msisdn: testPhone,
            firstName: testFirstName,
            lastName: testLastName,
            currencyCode: testCurrencyCode,
            languageCode: testLanguageCode,
          ),
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid email format");
        expect(result.data, isNull);

        verify(mockApiAuth.updateUserInfo(request: anyNamed("request"))).called(1);
      });

      test("should handle partial user info updates", () async {
        // Arrange - only updating first name and newsletter subscription
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "updated-token",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
        ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "Partial update successful",
          statusCode: 200,
        );

        when(
          mockApiAuth.updateUserInfo(request: anyNamed("request")),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result =
        await repository.updateUserInfo(
          request: UpdateUserInfoRequest(
            firstName: testFirstName,
          ),
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.message, "Partial update successful");

        verify(mockApiAuth.updateUserInfo(request: anyNamed("request"))).called(1);
      });
    });


    group("getUserInfo", () {
      const String testBearerToken = "bearer-token-123";

      test("should return success resource when get user info succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "access-token",
          refreshToken: "refresh-token",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "User info retrieved",
          statusCode: 200,
        );

        when(
          mockApiAuth.getUserInfo(bearerToken: testBearerToken),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.getUserInfo(
          bearerToken: testBearerToken,
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, expectedResponse.accessToken);
        expect(result.data?.refreshToken, expectedResponse.refreshToken);
        expect(result.message, "User info retrieved");
        expect(result.error, isNull);

        verify(mockApiAuth.getUserInfo(bearerToken: testBearerToken))
            .called(1);
      });

      test(
          "should return success resource when get user info without token succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "access-token",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "User info retrieved",
          statusCode: 200,
        );

        when(
          mockApiAuth.getUserInfo(),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.getUserInfo(
          
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, expectedResponse.accessToken);

        verify(mockApiAuth.getUserInfo()).called(1);
      });

      test("should return error resource when get user info fails", () async {
        // Arrange
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Invalid or expired token",
          title: "Invalid or expired token",
        );

        when(
          mockApiAuth.getUserInfo(bearerToken: testBearerToken),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository.getUserInfo(
          bearerToken: testBearerToken,
        ) as Resource<AuthResponseModel>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid or expired token");
        expect(result.data, isNull);

        verify(mockApiAuth.getUserInfo(bearerToken: testBearerToken))
            .called(1);
      });
    });

    group("refreshTokenAPITrigger", () {
      test("should return success resource when token refresh succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "new-access-token",
          refreshToken: "new-refresh-token",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "Token refreshed successfully",
          statusCode: 200,
        );

        when(mockApiAuth.refreshTokenAPITrigger())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository
            .refreshTokenAPITrigger();

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, "new-access-token");
        expect(result.data?.refreshToken, "new-refresh-token");
        expect(result.message, "Token refreshed successfully");
        expect(result.error, isNull);

        verify(mockApiAuth.refreshTokenAPITrigger()).called(1);
      });

      test("should return error resource when token refresh fails", () async {
        // Arrange
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Refresh token expired",
          title: "Refresh token expired",
        );

        when(mockApiAuth.refreshTokenAPITrigger())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel> result = await repository
            .refreshTokenAPITrigger();

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Refresh token expired");
        expect(result.data, isNull);

        verify(mockApiAuth.refreshTokenAPITrigger()).called(1);
      });
    });

    group("tmpLogin", () {
      const String testEmail = "temp@example.com";
      const String testPhone = "+1234567890";

      test(
          "should return success resource when temporary login with email succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "temp-access-token",
          refreshToken: "temp-refresh-token",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "Temporary login successful",
          statusCode: 200,
        );

        when(
          mockApiAuth.tmpLogin(email: testEmail, phone: null),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel?> result = await repository.tmpLogin(
          email: testEmail,
          phone: null,
        ) as Resource<AuthResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, "temp-access-token");
        expect(result.message, "Temporary login successful");
        expect(result.error, isNull);

        verify(mockApiAuth.tmpLogin(email: testEmail, phone: null)).called(1);
      });

      test(
          "should return success resource when temporary login with phone succeeds",
          () async {
        // Arrange
        final AuthResponseModelDto expectedResponse = AuthResponseModelDto(
          accessToken: "temp-access-token",
        );
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          data: expectedResponse,
          message: "Temporary phone login successful",
          statusCode: 200,
        );

        when(
          mockApiAuth.tmpLogin(email: null, phone: testPhone),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel?> result = await repository.tmpLogin(
          email: null,
          phone: testPhone,
        ) as Resource<AuthResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.accessToken, expectedResponse.accessToken);
        expect(result.message, "Temporary phone login successful");

        verify(mockApiAuth.tmpLogin(email: null, phone: testPhone)).called(1);
      });

      test("should return error resource when temporary login fails",
          () async {
        // Arrange
        final ResponseMainDto<AuthResponseModelDto> responseMain =
            ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Temporary login not allowed",
          title: "Temporary login not allowed",
        );

        when(
          mockApiAuth.tmpLogin(email: testEmail, phone: null),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<AuthResponseModel?> result = await repository.tmpLogin(
          email: testEmail,
          phone: null,
        ) as Resource<AuthResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Temporary login not allowed");
        expect(result.data, isNull);

        verify(mockApiAuth.tmpLogin(email: testEmail, phone: null)).called(1);
      });
    });

    group("Listener Management", () {
      late TestUnauthorizedAccessListener mockUnauthorizedListener;
      late TestAuthReloadListener mockAuthReloadListener;

      setUp(() {
        mockUnauthorizedListener = TestUnauthorizedAccessListener();
        mockAuthReloadListener = TestAuthReloadListener();
      });

      test("should add unauthorized access listener", () {
        // Act
        repository.addUnauthorizedAccessListener(mockUnauthorizedListener);

        // Assert
        verify(
          mockApiAuth.addUnauthorizedAccessListener(mockUnauthorizedListener),
        ).called(1);
      });

      test("should remove unauthorized access listener", () {
        // Act
        repository.removeUnauthorizedAccessListener(mockUnauthorizedListener);

        // Assert
        verify(
          mockApiAuth
              .removeUnauthorizedAccessListener(mockUnauthorizedListener),
        ).called(1);
      });

      test("should add auth reload listener", () {
        // Act
        repository.addAuthReloadListenerCallBack(mockAuthReloadListener);

        // Assert
        verify(
          mockApiAuth.addAuthReloadListenerCallBack(mockAuthReloadListener),
        ).called(1);
      });

      test("should remove auth reload listener", () {
        // Act
        repository.removeAuthReloadListenerCallBack(mockAuthReloadListener);

        // Assert
        verify(
          mockApiAuth.removeAuthReloadListenerCallBack(mockAuthReloadListener),
        ).called(1);
      });

      test("should handle multiple listener additions and removals", () {
        // Arrange
        final TestUnauthorizedAccessListener listener1 =
            TestUnauthorizedAccessListener();
        final TestUnauthorizedAccessListener listener2 =
            TestUnauthorizedAccessListener();

        // Act
        repository..addUnauthorizedAccessListener(listener1)
        ..addUnauthorizedAccessListener(listener2)
        ..removeUnauthorizedAccessListener(listener1);

        // Assert
        verify(mockApiAuth.addUnauthorizedAccessListener(listener1)).called(1);
        verify(mockApiAuth.addUnauthorizedAccessListener(listener2)).called(1);
        verify(mockApiAuth.removeUnauthorizedAccessListener(listener1))
            .called(1);
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiAuthRepository interface", () {
        expect(repository, isA<ApiAuthRepository>());
      });

      test("should maintain consistent Resource<T> pattern across all methods",
          () async {
        // This test verifies that all methods return proper Resource types

        // Login
        when(
          mockApiAuth.login(
            email: anyNamed("email"),
            phoneNumber: anyNamed("phoneNumber"),
          ),
        ).thenAnswer(
          (_) async => ResponseMainDto<OtpResponseModelDto?>.createErrorWithData(
            data: OtpResponseModelDto(),
            statusCode: 200,
          ),
        );
        final dynamic loginResult = await repository.login(
          email: "test@test.com",
          phoneNumber: null,
        );
        expect(loginResult, isA<Resource<OtpResponseModel?>>());

        // Logout
        when(mockApiAuth.logout()).thenAnswer(
          (_) async => ResponseMainDto<EmptyResponseDto>.createErrorWithData(
            data: EmptyResponseDto(),
            statusCode: 200,
          ),
        );
        final dynamic logoutResult = await repository.logout();
        expect(logoutResult, isA<Resource<EmptyResponse>>());

        // VerifyOtp
        when(
          mockApiAuth.verifyOtp(
            email: anyNamed("email"),
            phoneNumber: anyNamed("phoneNumber"),
            pinCode: anyNamed("pinCode"),
            providerToken: anyNamed("providerToken"),
            providerType: anyNamed("providerType"),
          ),
        ).thenAnswer(
          (_) async => ResponseMainDto<AuthResponseModelDto>.createErrorWithData(
            data: AuthResponseModelDto(),
            statusCode: 200,
          ),
        );
        final dynamic verifyResult = await repository.verifyOtp(
          email: "test@test.com",
        );
        expect(verifyResult, isA<Resource<AuthResponseModel>>());
      });
    });

    group("Edge cases and error handling", () {
      test("should handle network timeout gracefully", () async {
        // Arrange
        when(
          mockApiAuth.login(
            email: anyNamed("email"),
            phoneNumber: anyNamed("phoneNumber"),
          ),
        ).thenThrow(TimeoutException("Request timeout"));

        // Act & Assert
        expect(
          () => repository.login(email: "test@test.com", phoneNumber: null),
          throwsA(isA<TimeoutException>()),
        );
      });

      test("should handle null response data", () async {
        // Arrange
        final ResponseMainDto<OtpResponseModelDto?> responseMain =
            ResponseMainDto<OtpResponseModelDto?>.createErrorWithData(
          message: "Success but no data",
          statusCode: 200,
        );

        when(
          mockApiAuth.login(
            email: anyNamed("email"),
            phoneNumber: anyNamed("phoneNumber"),
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<OtpResponseModel?> result = await repository.login(
          email: "test@test.com",
          phoneNumber: null,
        ) as Resource<OtpResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNull);
      });

      test("should handle empty string parameters", () async {
        // Arrange
        final ResponseMainDto<OtpResponseModelDto?> responseMain =
            ResponseMainDto<OtpResponseModelDto?>.createErrorWithData(
          data: OtpResponseModelDto(),
          statusCode: 200,
        );

        when(mockApiAuth.login(email: "", phoneNumber: null))
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<OtpResponseModel?> result = await repository.login(
          email: "",
          phoneNumber: null,
        ) as Resource<OtpResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        verify(mockApiAuth.login(email: "", phoneNumber: null)).called(1);
      });
    });
  });
}
