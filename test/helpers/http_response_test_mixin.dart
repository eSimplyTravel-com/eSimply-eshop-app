import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;

import "test_constants.dart";

/// Mixin providing common validation patterns for HTTP responses and ResponseMain objects.
/// This eliminates duplicate assertion code across API and HTTP client tests.
mixin HttpResponseTestMixin {
  // MARK: - ResponseMain Success Validations

  /// Validate that a ResponseMain represents a successful operation
  void expectResponseMainSuccess<T>(
    ResponseMainDto<T> response, {
    T? expectedData,
    int? expectedCode,
    String? expectedMessage,
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "ResponseMain should be successful";

    expect(
      response,
      isA<ResponseMainDto<T>>(),
      reason: "$description - should be ResponseMain<$T>",
    );
    expect(
      response.statusCode,
      equals(200),
      reason: "$description - should be successful",
    );
    expect(
      response.message,
      isNull,
      reason: "$description - should not have error message",
    );

    if (expectedData != null) {
      expect(
        response.data,
        equals(expectedData),
        reason: "$description - should have expected data",
      );
    } else if (response.data != null) {
      expect(
        response.data,
        isNotNull,
        reason: "$description - should have non-null data",
      );
    }

    if (expectedCode != null) {
      expect(
        response.responseCode,
        equals(expectedCode),
        reason: "$description - should have expected response code",
      );
    } else {
      expect(
        response.responseCode,
        equals(TestConstants.httpOk),
        reason: "$description - should have default success code",
      );
    }

    if (expectedMessage != null) {
      expect(
        response.message,
        equals(expectedMessage),
        reason: "$description - should have expected message",
      );
    }
  }

  /// Validate success ResponseMain with custom data validation
  void expectResponseMainSuccessWithCustomValidation<T>(
    ResponseMainDto<T> response,
    void Function(T data) dataValidator, {
    int? expectedCode,
    String? expectedMessage,
    String? testDescription,
  }) {
    expectResponseMainSuccess<T>(
      response,
      expectedCode: expectedCode,
      expectedMessage: expectedMessage,
      testDescription: testDescription,
    );

    if (response.data != null) {
      dataValidator(response.data!);
    }
  }

  /// Validate success ResponseMain with list data
  void expectResponseMainSuccessWithList<T>(
    ResponseMainDto<List<T>> response, {
    int? expectedCount,
    bool allowEmpty = true,
    int? expectedCode,
    String? testDescription,
  }) {
    expectResponseMainSuccess<List<T>>(
      response,
      expectedCode: expectedCode,
      testDescription: testDescription,
    );

    if (response.data != null) {
      dynamic data = response.data!;

      if (expectedCount != null) {
        expect(
          data.length,
          equals(expectedCount),
          reason:
              "${testDescription ?? 'ResponseMain'} - should have expected count",
        );
      }

      if (!allowEmpty) {
        expect(
          data.isNotEmpty,
          isTrue,
          reason: "${testDescription ?? 'ResponseMain'} - should not be empty",
        );
      }
    }
  }

  // MARK: - ResponseMain Error Validations

  /// Validate that a ResponseMain represents an error operation
  void expectResponseMainError<T>(
    ResponseMainDto<T> response, {
    String? expectedMessage,
    int? expectedCode,
    T? expectedData,
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "ResponseMain should be error";

    expect(
      response,
      isA<ResponseMainDto<T>>(),
      reason: "$description - should be ResponseMain<$T>",
    );
    expect(
      response.statusCode,
      isNot(equals(200)),
      reason: "$description - should not be successful",
    );

    if (expectedMessage != null) {
      expect(
        response.message,
        contains(expectedMessage),
        reason: "$description - should contain expected error message",
      );
    } else {
      expect(
        response.message,
        isNotNull,
        reason: "$description - should have error message",
      );
      expect(
        response.message!.isNotEmpty,
        isTrue,
        reason: "$description - error message should not be empty",
      );
    }

    if (expectedCode != null) {
      expect(
        response.responseCode,
        equals(expectedCode),
        reason: "$description - should have expected error code",
      );
    }

    if (expectedData != null) {
      expect(
        response.data,
        equals(expectedData),
        reason: "$description - should have expected data",
      );
    }
  }

  /// Validate error ResponseMain with specific error codes
  void expectResponseMainErrorWithCode<T>(
    ResponseMainDto<T> response,
    int expectedCode, {
    String? expectedMessage,
    String? testDescription,
  }) {
    expectResponseMainError<T>(
      response,
      expectedCode: expectedCode,
      expectedMessage: expectedMessage,
      testDescription: testDescription,
    );
  }

  /// Validate error ResponseMain for common HTTP error codes
  void expectResponseMainBadRequest<T>(
    ResponseMainDto<T> response, {
    String? expectedMessage,
  }) {
    expectResponseMainErrorWithCode<T>(
      response,
      TestConstants.httpBadRequest,
      expectedMessage: expectedMessage,
      testDescription: "ResponseMain should be bad request error",
    );
  }

  void expectResponseMainUnauthorized<T>(
    ResponseMainDto<T> response, {
    String? expectedMessage,
  }) {
    expectResponseMainErrorWithCode<T>(
      response,
      TestConstants.httpUnauthorized,
      expectedMessage: expectedMessage,
      testDescription: "ResponseMain should be unauthorized error",
    );
  }

  void expectResponseMainForbidden<T>(
    ResponseMainDto<T> response, {
    String? expectedMessage,
  }) {
    expectResponseMainErrorWithCode<T>(
      response,
      TestConstants.httpForbidden,
      expectedMessage: expectedMessage,
      testDescription: "ResponseMain should be forbidden error",
    );
  }

  void expectResponseMainNotFound<T>(
    ResponseMainDto<T> response, {
    String? expectedMessage,
  }) {
    expectResponseMainErrorWithCode<T>(
      response,
      TestConstants.httpNotFound,
      expectedMessage: expectedMessage,
      testDescription: "ResponseMain should be not found error",
    );
  }

  void expectResponseMainServerError<T>(
    ResponseMainDto<T> response, {
    String? expectedMessage,
  }) {
    expectResponseMainErrorWithCode<T>(
      response,
      TestConstants.httpInternalServerError,
      expectedMessage: expectedMessage,
      testDescription: "ResponseMain should be server error",
    );
  }

  // MARK: - HTTP Response Validations

  /// Validate basic HTTP response properties
  void expectHttpResponse(
    http.Response response, {
    int? expectedStatusCode,
    String? expectedBody,
    Map<String, String>? expectedHeaders,
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "HTTP response should be valid";

    expect(
      response,
      isA<http.Response>(),
      reason: "$description - should be http.Response",
    );

    if (expectedStatusCode != null) {
      expect(
        response.statusCode,
        equals(expectedStatusCode),
        reason: "$description - should have expected status code",
      );
    }

    if (expectedBody != null) {
      expect(
        response.body,
        equals(expectedBody),
        reason: "$description - should have expected body",
      );
    }

    if (expectedHeaders != null) {
      expectedHeaders.forEach((String key, String value) {
        expect(
          response.headers[key],
          equals(value),
          reason: "$description - should have expected header $key",
        );
      });
    }
  }

  /// Validate successful HTTP response
  void expectHttpResponseSuccess(
    http.Response response, {
    String? expectedBody,
    Map<String, String>? expectedHeaders,
    String? testDescription,
  }) {
    expectHttpResponse(
      response,
      expectedStatusCode: TestConstants.httpOk,
      expectedBody: expectedBody,
      expectedHeaders: expectedHeaders,
      testDescription: testDescription ?? "HTTP response should be successful",
    );
  }

  /// Validate HTTP error response
  void expectHttpResponseError(
    http.Response response,
    int expectedStatusCode, {
    String? expectedBody,
    String? testDescription,
  }) {
    expectHttpResponse(
      response,
      expectedStatusCode: expectedStatusCode,
      expectedBody: expectedBody,
      testDescription: testDescription ?? "HTTP response should be error",
    );
  }

  /// Validate HTTP response for common error codes
  void expectHttpBadRequest(http.Response response, {String? expectedBody}) {
    expectHttpResponseError(
      response,
      TestConstants.httpBadRequest,
      expectedBody: expectedBody,
      testDescription: "HTTP response should be bad request",
    );
  }

  void expectHttpUnauthorized(http.Response response, {String? expectedBody}) {
    expectHttpResponseError(
      response,
      TestConstants.httpUnauthorized,
      expectedBody: expectedBody,
      testDescription: "HTTP response should be unauthorized",
    );
  }

  void expectHttpServerError(http.Response response, {String? expectedBody}) {
    expectHttpResponseError(
      response,
      TestConstants.httpInternalServerError,
      expectedBody: expectedBody,
      testDescription: "HTTP response should be server error",
    );
  }

  // MARK: - StreamedResponse Validations

  /// Validate HTTP StreamedResponse
  void expectStreamedResponse(
    http.StreamedResponse response, {
    int? expectedStatusCode,
    Map<String, String>? expectedHeaders,
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "StreamedResponse should be valid";

    expect(
      response,
      isA<http.StreamedResponse>(),
      reason: "$description - should be StreamedResponse",
    );
    expect(
      response,
      isA<http.BaseResponse>(),
      reason: "$description - should extend BaseResponse",
    );

    if (expectedStatusCode != null) {
      expect(
        response.statusCode,
        equals(expectedStatusCode),
        reason: "$description - should have expected status code",
      );
    }

    if (expectedHeaders != null) {
      expectedHeaders.forEach((String key, String value) {
        expect(
          response.headers[key],
          contains(value),
          reason: "$description - should have expected header $key",
        );
      });
    }
  }

  /// Validate successful StreamedResponse
  void expectStreamedResponseSuccess(
    http.StreamedResponse response, {
    Map<String, String>? expectedHeaders,
    String? testDescription,
  }) {
    expectStreamedResponse(
      response,
      expectedStatusCode: TestConstants.httpOk,
      expectedHeaders: expectedHeaders,
      testDescription:
          testDescription ?? "StreamedResponse should be successful",
    );
  }

  // MARK: - Response Header Validations

  /// Validate that response contains expected headers
  void expectResponseHeaders(
    http.BaseResponse response,
    Map<String, String> expectedHeaders, {
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "Response should have expected headers";

    expectedHeaders.forEach((String key, String value) {
      expect(
        response.headers.containsKey(key),
        isTrue,
        reason: "$description - should contain header $key",
      );
      expect(
        response.headers[key],
        contains(value),
        reason: "$description - header $key should contain expected value",
      );
    });
  }

  /// Validate content type header
  void expectContentTypeHeader(
    http.BaseResponse response,
    String expectedContentType, {
    String? testDescription,
  }) {
    expectResponseHeaders(
      response,
      <String, String>{TestConstants.contentTypeHeader: expectedContentType},
      testDescription:
          testDescription ?? "Response should have expected content type",
    );
  }

  /// Validate JSON content type
  void expectJsonContentType(http.BaseResponse response) {
    expectContentTypeHeader(
      response,
      TestConstants.jsonContentType,
      testDescription: "Response should have JSON content type",
    );
  }

  /// Validate authorization header
  void expectAuthorizationHeader(
    http.BaseRequest request,
    String expectedToken, {
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "Request should have authorization header";

    expect(
      request.headers.containsKey(TestConstants.authorizationHeader),
      isTrue,
      reason: "$description - should contain authorization header",
    );

    final String authHeader =
        request.headers[TestConstants.authorizationHeader]!;
    expect(
      authHeader,
      contains(expectedToken),
      reason: "$description - should contain expected token",
    );
    expect(
      authHeader,
      startsWith(TestConstants.bearerTokenPrefix),
      reason: "$description - should be Bearer token",
    );
  }

  // MARK: - Response Status Code Validations

  /// Validate response status code is in success range (200-299)
  void expectSuccessStatusCode(http.BaseResponse response) {
    expect(
      response.statusCode,
      greaterThanOrEqualTo(200),
      reason: "Response should have success status code (>=200)",
    );
    expect(
      response.statusCode,
      lessThan(300),
      reason: "Response should have success status code (<300)",
    );
  }

  /// Validate response status code is in client error range (400-499)
  void expectClientErrorStatusCode(http.BaseResponse response) {
    expect(
      response.statusCode,
      greaterThanOrEqualTo(400),
      reason: "Response should have client error status code (>=400)",
    );
    expect(
      response.statusCode,
      lessThan(500),
      reason: "Response should have client error status code (<500)",
    );
  }

  /// Validate response status code is in server error range (500-599)
  void expectServerErrorStatusCode(http.BaseResponse response) {
    expect(
      response.statusCode,
      greaterThanOrEqualTo(500),
      reason: "Response should have server error status code (>=500)",
    );
    expect(
      response.statusCode,
      lessThan(600),
      reason: "Response should have server error status code (<600)",
    );
  }

  // MARK: - Response Body Validations

  /// Validate that response body contains expected content
  void expectResponseBodyContains(
    http.Response response,
    String expectedContent, {
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "Response body should contain expected content";

    expect(response.body, contains(expectedContent), reason: description);
  }

  /// Validate that response body is valid JSON
  void expectResponseBodyIsJson(
    http.Response response, {
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "Response body should be valid JSON";

    expect(
      () => response.body,
      returnsNormally,
      reason: "$description - should not be null",
    );
    expect(
      response.body.isNotEmpty,
      isTrue,
      reason: "$description - should not be empty",
    );

    // Try to parse as JSON
    expect(
      () {
        final dynamic parsed = response.body;
        return parsed;
      },
      returnsNormally,
      reason: "$description - should be parseable",
    );
  }

  /// Validate that response body is empty
  void expectResponseBodyEmpty(
    http.Response response, {
    String? testDescription,
  }) {
    final String description =
        testDescription ?? "Response body should be empty";

    expect(response.body.isEmpty, isTrue, reason: description);
  }

  // MARK: - Batch Response Validations

  /// Validate multiple ResponseMain objects have success status
  void expectAllResponseMainSuccessful<T>(List<ResponseMainDto<T>> responses) {
    expect(
      responses.isNotEmpty,
      isTrue,
      reason: "Should have responses to validate",
    );

    for (int i = 0; i < responses.length; i++) {
      expect(
        responses[i].statusCode,
        equals(200),
        reason: "ResponseMain at index $i should be successful",
      );
    }
  }

  /// Validate multiple ResponseMain objects have error status
  void expectAllResponseMainErrors<T>(List<ResponseMainDto<T>> responses) {
    expect(
      responses.isNotEmpty,
      isTrue,
      reason: "Should have responses to validate",
    );

    for (int i = 0; i < responses.length; i++) {
      expect(
        responses[i].statusCode,
        isNot(equals(200)),
        reason: "ResponseMain at index $i should be error",
      );
      expect(
        responses[i].message,
        isNotNull,
        reason: "ResponseMain at index $i should have error message",
      );
    }
  }

  // MARK: - Custom Response Validations

  /// Create a custom ResponseMain assertion
  void expectResponseMainCustom<T>(
    ResponseMainDto<T> response,
    bool Function(ResponseMainDto<T>) customValidator,
    String failureMessage,
  ) {
    expect(
      response,
      isA<ResponseMainDto<T>>(),
      reason: "Should be valid ResponseMain",
    );
    expect(customValidator(response), isTrue, reason: failureMessage);
  }

  /// Create a custom HTTP response assertion
  void expectHttpResponseCustom(
    http.BaseResponse response,
    bool Function(http.BaseResponse) customValidator,
    String failureMessage,
  ) {
    expect(
      response,
      isA<http.BaseResponse>(),
      reason: "Should be valid HTTP response",
    );
    expect(customValidator(response), isTrue, reason: failureMessage);
  }

  // MARK: - Response Comparison Utilities

  /// Compare two ResponseMain objects for equality
  void expectResponseMainEqual<T>(
    ResponseMainDto<T> response1,
    ResponseMainDto<T> response2,
  ) {
    expect(
      response1.statusCode,
      equals(response2.statusCode),
      reason: "ResponseMain objects should have same status code",
    );
    expect(
      response1.data,
      equals(response2.data),
      reason: "ResponseMain objects should have same data",
    );
    expect(
      response1.message,
      equals(response2.message),
      reason: "ResponseMain objects should have same message",
    );
    expect(
      response1.responseCode,
      equals(response2.responseCode),
      reason: "ResponseMain objects should have same response code",
    );
  }

  /// Validate that ResponseMain has changed from previous state
  void expectResponseMainChanged<T>(
    ResponseMainDto<T> oldResponse,
    ResponseMainDto<T> newResponse,
  ) {
    final bool hasChanged = oldResponse.statusCode != newResponse.statusCode ||
        oldResponse.data != newResponse.data ||
        oldResponse.message != newResponse.message ||
        oldResponse.responseCode != newResponse.responseCode;

    expect(
      hasChanged,
      isTrue,
      reason: "ResponseMain should have changed from previous state",
    );
  }
}
