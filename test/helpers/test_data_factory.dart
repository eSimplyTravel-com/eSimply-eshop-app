import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/util/resource.dart";

/// Factory class for creating consistent test data across all test files.
/// This eliminates duplication and provides a single source of truth for test objects.
class TestDataFactory {
  // Private constructor to prevent instantiation
  TestDataFactory._();

  // MARK: - Device Response Data
  static DeviceInfoResponseModelDto createDeviceResponse({
    String? deviceId,
    String? status,
    String? name,
  }) {
    return DeviceInfoResponseModelDto();
  }

  static List<DeviceInfoResponseModelDto> createDeviceResponseList({
    int count = 2,
  }) {
    return List<DeviceInfoResponseModelDto>.generate(
      count,
      (int index) => createDeviceResponse(),
    );
  }

  // MARK: - Dynamic Page Response Data
  static DynamicPageResponse createDynamicPageResponse({
    String? pageTitle,
    String? pageIntro,
    String? pageContent,
  }) {
    return DynamicPageResponse(
      pageTitle: pageTitle ?? "Test Page Title",
      pageIntro: pageIntro ?? "Test Page Intro",
      pageContent: pageContent ?? "Test Page Content",
    );
  }

  // MARK: - FAQ Response Data
  static FaqResponse createFaqResponse({
    String? question,
    String? answer,
    int? id,
  }) {
    return FaqResponse(
      question: question ?? "Test Question?",
      answer: answer ?? "Test Answer",
    );
  }

  static List<FaqResponse> createFaqResponseList({
    int count = 3,
  }) {
    return List<FaqResponse>.generate(
      count,
      (int index) => createFaqResponse(
        id: index + 1,
        question: "Test Question ${index + 1}?",
        answer: "Test Answer ${index + 1}",
      ),
    );
  }

  // MARK: - Configuration Response Data
  static ConfigurationResponseModel createConfigurationResponse({
    String? key,
    String? value,
    String? type,
  }) {
    return ConfigurationResponseModel(
      key: key ?? "test_config_key",
      value: value ?? "test_config_value",
    );
  }

  static List<ConfigurationResponseModel> createConfigurationResponseList({
    int count = 2,
  }) {
    return List<ConfigurationResponseModel>.generate(
      count,
      (int index) => createConfigurationResponse(
        key: "config_key_${index + 1}",
        value: "config_value_${index + 1}",
      ),
    );
  }

  // MARK: - Currency Response Data
  static CurrenciesResponseModel createCurrencyResponse({
    String? code,
    String? name,
    String? symbol,
    double? rate,
  }) {
    return CurrenciesResponseModel(
      currency: code ?? "USD",
    );
  }

  static List<CurrenciesResponseModel> createCurrencyResponseList({
    int count = 3,
  }) {
    return List<CurrenciesResponseModel>.generate(count, (int index) {
      final List<Map<String, Object>> currencies = <Map<String, Object>>[
        <String, Object>{
          "code": "USD",
          "name": "US Dollar",
          "symbol": r"$",
          "rate": 1.0,
        },
        <String, Object>{
          "code": "EUR",
          "name": "Euro",
          "symbol": "€",
          "rate": 0.85,
        },
        <String, Object>{
          "code": "GBP",
          "name": "British Pound",
          "symbol": "£",
          "rate": 0.73,
        },
      ];
      final Map<String, Object> currency =
          currencies[index % currencies.length];
      return createCurrencyResponse(
        code: currency["code"]! as String,
        name: currency["name"]! as String,
        symbol: currency["symbol"]! as String,
        rate: currency["rate"]! as double,
      );
    });
  }

  // MARK: - API Endpoint Data
  static APIEndPoint createTestEndpoint({
    String? enumBaseURL,
    String? path,
    HttpMethod? method,
    bool? hasAuthorization,
    bool? isRefreshToken,
    Map<String, String>? headers,
    Map<String, dynamic>? parameters,
  }) {
    return APIEndPoint(
      enumBaseURL: enumBaseURL ?? "",
      path: path ?? "/test",
      method: method ?? HttpMethod.GET,
      hasAuthorization: hasAuthorization ?? false,
      isRefreshToken: isRefreshToken ?? false,
      headers: headers ?? <String, String>{},
      parameters: parameters ?? <String, dynamic>{},
    );
  }

  static APIEndPoint createAuthenticatedEndpoint({
    String? path,
    HttpMethod? method,
  }) {
    return createTestEndpoint(
      path: path ?? "/auth/test",
      method: method ?? HttpMethod.POST,
      hasAuthorization: true,
      isRefreshToken: false,
    );
  }

  static APIEndPoint createRefreshTokenEndpoint({
    String? path,
  }) {
    return createTestEndpoint(
      path: path ?? "/auth/refresh",
      method: HttpMethod.POST,
      hasAuthorization: false,
      isRefreshToken: true,
    );
  }

  // MARK: - ResponseMain Data
  static ResponseMainDto<T> createSuccessResponse<T>({
    T? data,
    int? responseCode,
    String? message,
  }) {
    return ResponseMainDto<T>.createErrorWithData(
      data: data,
      responseCode: responseCode ?? 200,
      message: message, // Don't set default message for success
      statusCode: 200,
    );
  }

  static ResponseMainDto<T> createErrorResponse<T>({
    int? responseCode,
    String? errorMessage,
    T? data,
  }) {
    return ResponseMainDto<T>.createError(
      responseCode: responseCode ?? 400,
      errorMessage: errorMessage ?? "Test Error",
    );
  }

  static ResponseMainDto<T> createErrorWithDataResponse<T>({
    required T data,
    int? responseCode,
    String? errorMessage,
  }) {
    return ResponseMainDto<T>.createErrorWithData(
      responseCode: responseCode ?? 400,
      message: errorMessage ?? "Test Error with Data",
      data: data,
    );
  }

  // MARK: - Resource Data
  static Resource<T> createSuccessResource<T>({
    required T data,
    String? message,
    int? code,
  }) {
    return Resource<T>.success(
      data,
      message: message ?? "Success",
    );
  }

  static Resource<T> createErrorResource<T>({
    String? message,
    int? code,
    T? data,
  }) {
    return Resource<T>.error(
      message ?? "Test Error",
      data: data,
      error: code != null
          ? GeneralError(message: message ?? "Test Error", errorCode: code)
          : null,
    );
  }

  static Resource<T> createLoadingResource<T>({
    String? message,
    T? data,
  }) {
    return Resource<T>.loading(
      data: data,
    );
  }

  // MARK: - Batch Test Data Creation
  static Map<String, dynamic> createCompleteTestDataSet() {
    return <String, dynamic>{
      "device": createDeviceResponse(),
      "devices": createDeviceResponseList(),
      "faq": createFaqResponse(),
      "faqs": createFaqResponseList(),
      "configuration": createConfigurationResponse(),
      "configurations": createConfigurationResponseList(),
      "currency": createCurrencyResponse(),
      "currencies": createCurrencyResponseList(),
      "endpoint": createTestEndpoint(),
      "authEndpoint": createAuthenticatedEndpoint(),
      "refreshEndpoint": createRefreshTokenEndpoint(),
    };
  }

  // MARK: - Parameter Test Data
  static Map<String, String> createTestParameters({
    String? userId,
    String? deviceId,
    String? name,
    String? email,
    String? message,
  }) {
    return <String, String>{
      "userId": userId ?? "test_user_123",
      "deviceId": deviceId ?? "test_device_123",
      "name": name ?? "Test User",
      "email": email ?? "test@example.com",
      "message": message ?? "Test message content",
    };
  }

  // MARK: - Error Test Data
  static Map<String, dynamic> createErrorTestCases() {
    return <String, dynamic>{
      "badRequest": createErrorResponse<String>(
        responseCode: 400,
        errorMessage: "Bad Request",
      ),
      "unauthorized": createErrorResponse<String>(
        responseCode: 401,
        errorMessage: "Unauthorized",
      ),
      "forbidden": createErrorResponse<String>(
        responseCode: 403,
        errorMessage: "Forbidden",
      ),
      "notFound": createErrorResponse<String>(
        responseCode: 404,
        errorMessage: "Not Found",
      ),
      "serverError": createErrorResponse<String>(
        responseCode: 500,
        errorMessage: "Internal Server Error",
      ),
    };
  }

  // MARK: - User Notification Data
  static UserNotificationModel createUserNotification({
    int? notificationId,
    String? title,
    String? content,
    String? datetime,
    String? transactionStatus,
    String? transaction,
    String? transactionMessage,
    bool? status,
    String? iccid,
    String? category,
    String? translatedMessage,
  }) {
    return UserNotificationModel(
      notificationId: notificationId ?? 1,
      title: title ?? "Test Notification",
      content: content ?? "Test notification content",
      datetime: datetime ?? "1640995200", // 2022-01-01 00:00:00
      transactionStatus: transactionStatus,
      transaction: transaction,
      transactionMessage: transactionMessage,
      status: status ?? true,
      iccid: iccid ?? "test-iccid-123",
      category: category ?? "1",
      translatedMessage: translatedMessage,
    );
  }

  static List<UserNotificationModel> createUserNotificationList({
    int count = 3,
  }) {
    return List<UserNotificationModel>.generate(
      count,
      (int index) => createUserNotification(
        notificationId: index + 1,
        title: "Test Notification ${index + 1}",
        content: "Test notification content ${index + 1}",
        datetime: "${1640995200 + (index * 3600)}", // Each hour apart
        status: index.isEven, // Alternate read/unread status
        iccid: "test-iccid-${index + 1}",
        category: "${index + 1}",
      ),
    );
  }

  static UserNotificationModel createUnreadNotification({
    int? notificationId,
    String? title,
    String? iccid,
    String? category,
  }) {
    return createUserNotification(
      notificationId: notificationId ?? 999,
      title: title ?? "Unread Notification",
      status: false,
      iccid: iccid ?? "unread-iccid",
      category: category ?? "2",
    );
  }

  static UserNotificationModel createReadNotification({
    int? notificationId,
    String? title,
    String? iccid,
    String? category,
  }) {
    return createUserNotification(
      notificationId: notificationId ?? 888,
      title: title ?? "Read Notification",
      status: true,
      iccid: iccid ?? "read-iccid",
      category: category ?? "1",
    );
  }

  // MARK: - Purchase ESim Bundle Data
  static PurchaseEsimBundleResponseModel createPurchaseEsimBundle({
    String? orderNumber,
    String? orderStatus,
    String? displayTitle,
    String? displaySubtitle,
    String? bundleCode,
    String? iccid,
    String? paymentDate,
    String? validityDate,
    String? gprsLimitDisplay,
    String? validityDisplay,
    String? icon,
    String? smdpAddress,
    String? activationCode,
    bool? unlimited,
    bool? isTopupAllowed,
    List<CountryResponseModel>? countries,
  }) {
    return PurchaseEsimBundleResponseModel(
      orderNumber: orderNumber ?? "test-order-123",
      orderStatus: orderStatus ?? "active",
      displayTitle: displayTitle ?? "Test Bundle",
      displaySubtitle: displaySubtitle ?? "Test Subtitle",
      bundleCode: bundleCode ?? "test-bundle-code",
      iccid: iccid ?? "test-iccid-123",
      paymentDate: paymentDate ?? "1640995200", // 2022-01-01
      validityDate: validityDate,
      gprsLimitDisplay: gprsLimitDisplay ?? "1GB",
      validityLabel: validityDisplay ?? "Days",
      icon: icon ?? "test-icon-path",
      smdpAddress: smdpAddress ?? "test.smdp.address",
      activationCode: activationCode ?? "LPA:test-activation-code",
      unlimited: unlimited ?? false,
      isTopupAllowed: isTopupAllowed ?? true,
      countries: countries ?? <CountryResponseModel>[],
    );
  }

  static List<PurchaseEsimBundleResponseModel> createPurchaseEsimBundleList({
    int count = 3,
  }) {
    return List<PurchaseEsimBundleResponseModel>.generate(
      count,
      (int index) => createPurchaseEsimBundle(
        orderNumber: "test-order-${index + 1}",
        displayTitle: "Test Bundle ${index + 1}",
        displaySubtitle: "Test Subtitle ${index + 1}",
        bundleCode: "bundle-code-${index + 1}",
        iccid: "iccid-${index + 1}",
        orderStatus: index.isEven ? "active" : "expired",
      ),
    );
  }

  static PurchaseEsimBundleResponseModel createActivePurchaseEsimBundle({
    String? orderNumber,
    String? displayTitle,
  }) {
    return createPurchaseEsimBundle(
      orderNumber: orderNumber ?? "active-order-123",
      displayTitle: displayTitle ?? "Active Bundle",
      orderStatus: "active",
      unlimited: false,
      isTopupAllowed: true,
    );
  }

  static PurchaseEsimBundleResponseModel createExpiredPurchaseEsimBundle({
    String? orderNumber,
    String? displayTitle,
  }) {
    return createPurchaseEsimBundle(
      orderNumber: orderNumber ?? "expired-order-123",
      displayTitle: displayTitle ?? "Expired Bundle",
      orderStatus: "expired",
      unlimited: false,
      isTopupAllowed: false,
    );
  }
}
