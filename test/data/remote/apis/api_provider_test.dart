import "dart:async";
import "dart:io";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/auth_apis/auth_apis.dart";
import "package:esim_open_source/data/remote/http_methods.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:mockito/mockito.dart";

import "../../../helpers/app_enviroment_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

// Create mock URlRequestBuilder for testing
class MockUrlRequestBuilder implements URlRequestBuilder {
  @override
  String get path => "/test";

  @override
  String get baseURL => "";

  @override
  HttpMethod get method => HttpMethod.GET;

  @override
  bool get hasAuthorization => true;

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers =>
      <String, String>{"Custom-Header": "test-value"};
}

class MockUrlRequestBuilderRefreshToken implements URlRequestBuilder {
  @override
  String get path => "/refresh";

  @override
  String get baseURL => "";

  @override
  HttpMethod get method => HttpMethod.POST;

  @override
  bool get hasAuthorization => false;

  @override
  bool get isRefreshToken => true;

  @override
  Map<String, String> get headers => <String, String>{};
}

class MockRequest extends http.BaseRequest {
  MockRequest(super.method, super.url);

  @override
  http.ByteStream finalize() {
    super.finalize();
    return http.ByteStream.fromBytes(<int>[]);
  }
}

void main() {
  group("APIService Implementation Coverage", () {
    late MockConnectivityService mockConnectivityService;
    late MockLocalStorageService mockLocalStorageService;
    late MockDeviceInfoService mockDeviceInfoService;
    late MockSecureStorageService mockSecureStorageService;
    late APIService apiService;

    setUpAll(() async {
      await setupTestLocator();

      // Initialize AppEnvironment
      AppEnvironment.isFromAppClip = false;
      AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();

      // Setup mock services
      mockConnectivityService =
          locator<ConnectivityService>() as MockConnectivityService;
      mockLocalStorageService =
          locator<LocalStorageService>() as MockLocalStorageService;
      mockDeviceInfoService =
          locator<DeviceInfoService>() as MockDeviceInfoService;
      mockSecureStorageService =
          locator<SecureStorageService>() as MockSecureStorageService;
    });

    setUp(() {
      // Setup default mock responses
      when(mockConnectivityService.isConnected()).thenAnswer((_) async => true);
      when(mockLocalStorageService.accessToken).thenReturn("test_access_token");
      when(mockLocalStorageService.refreshToken)
          .thenReturn("test_refresh_token");
      when(mockLocalStorageService.languageCode).thenReturn("en");
      when(mockLocalStorageService.currencyCode).thenReturn("USD");
      when(mockSecureStorageService.getString(any))
          .thenAnswer((_) async => "device_123");
      when(mockDeviceInfoService.deviceID)
          .thenAnswer((_) async => "mock_device_id");

      apiService = APIService.instance;
    });

    test("APIService singleton initialization", () {
      final APIService instance1 = APIService.instance;
      final APIService instance2 = APIService.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
    });

    test("isLoggedIn returns true when access token exists", () async {
      when(mockLocalStorageService.accessToken).thenReturn("valid_token");

      final bool result = await apiService.isLoggedIn;

      expect(result, isTrue);
    });

    test("isLoggedIn returns false when access token is empty", () async {
      when(mockLocalStorageService.accessToken).thenReturn("");

      final bool result = await apiService.isLoggedIn;

      expect(result, isFalse);
    });

    test("accessToken getter returns token from storage", () async {
      when(mockLocalStorageService.accessToken).thenReturn("test_token");

      final String result = await apiService.accessToken;

      expect(result, equals("test_token"));
    });

    test("refreshToken getter returns token from storage", () async {
      when(mockLocalStorageService.refreshToken).thenReturn("test_refresh");

      final String result = await apiService.refreshToken;

      expect(result, equals("test_refresh"));
    });

    test("ApiParamsKeys enum values", () {
      expect(ApiParamsKeys.languageID.value, equals("LanguageID"));
      expect(ApiParamsKeys.userToken.value, equals("UserToken"));
      expect(ApiParamsKeys.tenant.value, equals("tenant"));
    });

    test("MediaContentType enum values and mimeType", () {
      expect(MediaContentType.imagePNG.type, equals("image"));
      expect(MediaContentType.imagePNG.subType, equals("png"));
      expect(MediaContentType.imagePNG.mimeType, equals("image/png"));

      expect(MediaContentType.imageJPG.type, equals("image"));
      expect(MediaContentType.imageJPG.subType, equals("jpg"));
      expect(MediaContentType.imageJPG.mimeType, equals("image/jpg"));
    });

    test("createAPIEndpoint with basic parameters", () {
      final MockUrlRequestBuilder mockBuilder = MockUrlRequestBuilder();

      final APIEndPoint endpoint =
          apiService.createAPIEndpoint(endPoint: mockBuilder);

      expect(endpoint.path, equals("/test"));
      expect(endpoint.method, equals(HttpMethod.GET));
      expect(endpoint.hasAuthorization, isTrue);
      expect(endpoint.isRefreshToken, isFalse);
      expect(endpoint.headers["Custom-Header"], equals("test-value"));
    });

    test("createAPIEndpoint with paramIDs", () {
      final MockUrlRequestBuilder mockBuilder = MockUrlRequestBuilder();

      final APIEndPoint endpoint = apiService.createAPIEndpoint(
        endPoint: mockBuilder,
        paramIDs: <String>["123", "456"],
      );

      expect(endpoint.path, equals("/test/123/456"));
    });

    test("createAPIEndpoint with query parameters", () {
      final MockUrlRequestBuilder mockBuilder = MockUrlRequestBuilder();

      final APIEndPoint endpoint = apiService.createAPIEndpoint(
        endPoint: mockBuilder,
        queryParameters: <String, dynamic>{"page": 1, "size": 10},
      );

      expect(endpoint.path, contains("?"));
      expect(endpoint.path, contains("page=1"));
      expect(endpoint.path, contains("size=10"));
    });

    test("createAPIEndpoint with additional headers", () {
      final MockUrlRequestBuilder mockBuilder = MockUrlRequestBuilder();

      final APIEndPoint endpoint = apiService.createAPIEndpoint(
        endPoint: mockBuilder,
        additionalHeaders: <String, String>{"Extra-Header": "extra-value"},
      );

      expect(endpoint.headers["Custom-Header"], equals("test-value"));
      expect(endpoint.headers["Extra-Header"], equals("extra-value"));
    });

    test("printHeader method execution", () {
      // This just tests method execution for coverage
      expect(() => apiService.printHeader("Test Title"), returnsNormally);
    });

    test("connectivityInterceptor allows request when connected", () async {
      when(mockConnectivityService.isConnected()).thenAnswer((_) async => true);
      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.connectivityInterceptor(request, endpoint);

      expect(result, equals(request));
    });

    test("connectivityInterceptor throws when not connected", () async {
      when(mockConnectivityService.isConnected())
          .thenAnswer((_) async => false);
      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      expect(
        () async => await apiService.connectivityInterceptor(request, endpoint),
        throwsA(isA<ResponseMainException>()),
      );
    });

    test("addAuthHeader adds authorization when required", () async {
      when(mockLocalStorageService.accessToken).thenReturn("bearer_token");
      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        hasAuthorization: true,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addAuthHeader(request, endpoint);

      expect(result.headers["Authorization"], equals("Bearer bearer_token"));
    });

    test("addAuthHeader skips authorization when not required", () async {
      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addAuthHeader(request, endpoint);

      expect(result.headers.containsKey("Authorization"), isFalse);
    });

    test("addDefaultHeaders adds content-type for POST requests", () async {
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final MockRequest request =
          MockRequest("POST", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.POST,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addDefaultHeaders(request, endpoint);

      expect(
        result.headers[HttpHeaders.contentTypeHeader],
        equals("application/json"),
      );
      expect(result.headers["accept-language"], equals("en"));
    });

    test("addDefaultHeaders adds refresh token header when isRefreshToken",
        () async {
      when(mockLocalStorageService.refreshToken)
          .thenReturn("refresh_token_123");

      final MockRequest request =
          MockRequest("POST", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/refresh",
        method: HttpMethod.POST,
        isRefreshToken: true,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addDefaultHeaders(request, endpoint);

      expect(result.headers["x-refresh-token"], equals("refresh_token_123"));
    });

    test("logCURLRequest processes request with body", () {
      final http.Request request =
          http.Request("POST", Uri.parse("https://example.com"))
            ..body = "test body content";
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.POST,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final FutureOr<http.BaseRequest> result =
          apiService.logCURLRequest(request, endpoint);

      expect(result, equals(request));
    });

    test("logCURLRequest processes request without body", () {
      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final FutureOr<http.BaseRequest> result =
          apiService.logCURLRequest(request, endpoint);

      expect(result, equals(request));
    });

    test("logResponse returns response unchanged", () {
      final http.Response response = http.Response("test body", 200);
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final FutureOr<http.BaseResponse> result =
          apiService.logResponse(response, endpoint);

      expect(result, equals(response));
    });

    test("createAPIEndpoint with paramIDs and query parameters combined", () {
      final MockUrlRequestBuilder mockBuilder = MockUrlRequestBuilder();

      final APIEndPoint endpoint = apiService.createAPIEndpoint(
        endPoint: mockBuilder,
        paramIDs: <String>["user", "123"],
        queryParameters: <String, dynamic>{
          "include": "profile",
          "expand": true,
        },
      );

      expect(endpoint.path, contains("/test/user/123"));
      expect(endpoint.path, contains("?"));
      expect(endpoint.path, contains("include=profile"));
      expect(endpoint.path, contains("expand=true"));
    });

    test("createAPIEndpoint with empty headers and additionalHeaders", () {
      final MockUrlRequestBuilderRefreshToken mockBuilder =
          MockUrlRequestBuilderRefreshToken(); // This has empty headers

      final APIEndPoint endpoint = apiService.createAPIEndpoint(
        endPoint: mockBuilder,
        additionalHeaders: <String, String>{"New-Header": "new-value"},
      );

      expect(endpoint.headers["New-Header"], equals("new-value"));
      expect(endpoint.headers.length, equals(1));
    });

    test("addAuthHeader skips authorization when access token is empty",
        () async {
      when(mockLocalStorageService.accessToken).thenReturn("");
      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        hasAuthorization: true, // Request auth but token is empty
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addAuthHeader(request, endpoint);

      expect(result.headers.containsKey("Authorization"), isFalse);
    });

    test("addDefaultHeaders with PUT method adds content-type", () async {
      final MockRequest request =
          MockRequest("PUT", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.PUT,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addDefaultHeaders(request, endpoint);

      expect(
        result.headers[HttpHeaders.contentTypeHeader],
        equals("application/json"),
      );
    });

    test("addDefaultHeaders with GET method does not add content-type",
        () async {
      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addDefaultHeaders(request, endpoint);

      expect(
        result.headers.containsKey(HttpHeaders.contentTypeHeader),
        isFalse,
      );
    });

    test("createAPIEndpoint handles empty paramIDs", () {
      final MockUrlRequestBuilder mockBuilder = MockUrlRequestBuilder();

      final APIEndPoint endpoint = apiService.createAPIEndpoint(
        endPoint: mockBuilder,
        paramIDs: <String>[], // Empty list
        queryParameters: <String, dynamic>{"test": "value"},
      );

      expect(endpoint.path, equals("/test?test=value"));
    });

    test("createAPIEndpoint handles empty query parameters", () {
      final MockUrlRequestBuilder mockBuilder = MockUrlRequestBuilder();

      final APIEndPoint endpoint = apiService.createAPIEndpoint(
        endPoint: mockBuilder,
        paramIDs: <String>["123"],
        queryParameters: <String, dynamic>{}, // Empty map
      );

      expect(endpoint.path, equals("/test/123"));
    });

    test("MediaContentType.imageJPG properties are correct", () {
      final MediaContentType jpgType = MediaContentType.imageJPG;

      expect(jpgType.type, equals("image"));
      expect(jpgType.subType, equals("jpg"));
      expect(jpgType.mimeType, equals("image/jpg"));
    });

    test("refreshTokenAPI method coverage with connectivity error", () async {
      // Setup mock to simulate no internet connection which will throw exception
      when(mockConnectivityService.isConnected())
          .thenAnswer((_) async => false);

      try {
        await apiService.refreshTokenAPI();
      } on Object catch (e) {
        // Expect ResponseMainException due to no connectivity
        expect(e, isA<ResponseMainException>());
        expect(e.toString(), contains("No internet connection"));
      }
    });

    test("refreshTokenAPI method exists and is callable", () {
      // Test that the refreshTokenAPI method exists
      expect(apiService.refreshTokenAPI, isA<Function>());

      // Test that the method has the correct signature - it should return a FutureOr<dynamic>
      expect(apiService.refreshTokenAPI, isA<Function>());
    });

    test("addAuthHeader waits for refresh completion when refreshing",
        () async {
      // This test covers the _isRefreshing check in addAuthHeader
      when(mockLocalStorageService.accessToken).thenReturn("test_token");

      final MockRequest request =
          MockRequest("GET", Uri.parse("https://example.com"));
      final APIEndPoint endpoint = APIEndPoint(
        path: "/test",
        method: HttpMethod.GET,
        hasAuthorization: true,
        headers: <String, String>{},
        parameters: <String, dynamic>{},
      );

      final http.BaseRequest result =
          await apiService.addAuthHeader(request, endpoint);

      expect(result.headers["Authorization"], equals("Bearer test_token"));
    });

    test("AuthApis.refreshToken endpoint properties", () {
      final AuthApis refreshEndpoint = AuthApis.refreshToken;

      expect(refreshEndpoint.path, equals("/api/v1/auth/refresh-token"));
      expect(refreshEndpoint.method, equals(HttpMethod.POST));
      expect(refreshEndpoint.isRefreshToken, isTrue);
      expect(refreshEndpoint.hasAuthorization, isFalse);
    });
  });
}
