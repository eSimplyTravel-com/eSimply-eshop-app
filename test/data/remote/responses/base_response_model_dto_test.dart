import "dart:convert";

import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/domain/util/network_constants.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for ResponseMainDto and related exceptions
/// Tests JSON deserialization, constructor variants, and exception handling
void main() {
  group("ResponseMainDto Tests", () {
    test("createError constructor assigns values correctly", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createError(
        responseCode: 400,
        errorMessage: "Bad Request",
      );

      // Assert
      expect(model.responseCode, 400);
      expect(model.message, "Bad Request");
      expect(model.data, isNull);
      expect(model.title, isNull);
      expect(model.status, isNull);
    });

    test("createError with different error codes", () {
      // Act
      final ResponseMainDto<dynamic> model401 =
          ResponseMainDto<dynamic>.createError(
        responseCode: 401,
        errorMessage: "Unauthorized",
      );
      final ResponseMainDto<dynamic> model500 =
          ResponseMainDto<dynamic>.createError(
        responseCode: 500,
        errorMessage: "Server Error",
      );

      // Assert
      expect(model401.responseCode, 401);
      expect(model401.message, "Unauthorized");
      expect(model500.responseCode, 500);
      expect(model500.message, "Server Error");
    });

    test("createErrorWithData with all fields populated", () {
      // Arrange
      const String testData = "test data";

      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        data: testData,
        title: "Error Title",
        status: "error",
        message: "Error message",
        totalCount: 5,
        statusCode: 400,
        responseCode: 400,
        developerMessage: "Developer message",
      );

      // Assert
      expect(model.data, testData);
      expect(model.title, "Error Title");
      expect(model.status, "error");
      expect(model.message, "Error message");
      expect(model.totalCount, 5);
      expect(model.statusCode, 400);
      expect(model.responseCode, 400);
      expect(model.developerMessage, "Developer message");
    });

    test("createErrorWithData with null fields", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData();

      // Assert
      expect(model.data, isNull);
      expect(model.title, isNull);
      expect(model.status, isNull);
      expect(model.message, isNull);
      expect(model.totalCount, isNull);
      expect(model.statusCode, isNull);
      expect(model.responseCode, isNull);
      expect(model.developerMessage, isNull);
    });

    test("createErrorWithData with partial fields", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        title: "Partial Error",
        responseCode: 403,
      );

      // Assert
      expect(model.title, "Partial Error");
      expect(model.responseCode, 403);
      expect(model.message, isNull);
      expect(model.statusCode, isNull);
      expect(model.data, isNull);
    });

    test("fromJson with valid complete JSON string", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "title": "Success",
        "status": "success",
        "message": "Operation completed",
        "totalCount": 10,
        "responseCode": 200,
        "developerMessage": "All good",
        "data": <String, dynamic>{"userId": 123},
      });

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 200,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.title, "Success");
      expect(model.status, "success");
      expect(model.message, "Operation completed");
      expect(model.totalCount, 10);
      expect(model.responseCode, 200);
      expect(model.developerMessage, "All good");
      expect(model.statusCode, 200);
      expect(model.data, isNotNull);
    });

    test("fromJson with minimal JSON string", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{});

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 200,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.title, isNull);
      expect(model.status, isNull);
      expect(model.message, isNull);
      expect(model.totalCount, isNull);
      expect(model.responseCode, isNull);
      expect(model.developerMessage, isNull);
      expect(model.statusCode, 200);
      expect(model.data, isNull);
    });

    test("fromJson with null data field", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "title": "Test",
        "message": "Test message",
        "data": null,
      });

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 200,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.title, "Test");
      expect(model.message, "Test message");
      expect(model.data, isNull);
    });

    test("fromJson with data uses custom parser when provided", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "title": "User Response",
        "message": "User loaded",
        "data": <String, dynamic>{"userId": 123, "name": "John"},
      });

      // Act - with null parser, data is stored as-is
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 200,
        response: jsonString,
        fromJson: null,
      );

      // Assert - data should be stored
      expect(model.data, isNotNull);
      expect(model.title, "User Response");
      expect(model.message, "User loaded");
      expect(
        model.data,
        isA<Map<dynamic, dynamic>>(),
      );
    });

    test("fromJson with different status codes", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "responseCode": 201,
      });

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 201,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.statusCode, 201);
      expect(model.responseCode, 201);
    });

    test("data getter returns null when not set", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createError(
        responseCode: 400,
        errorMessage: "Error",
      );

      // Assert
      expect(model.data, isNull);
    });

    test("data getter returns value when set", () {
      // Arrange
      const String testData = "test value";

      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        data: testData,
      );

      // Assert
      expect(model.data, testData);
      expect(model.data, isA<String>());
    });

    test("dataOfType casts data to expected type", () {
      // Arrange
      const int testData = 42;
      final ResponseMainDto<int> model =
          ResponseMainDto<int>.createErrorWithData(
        data: testData,
      );

      // Act
      final int result = model.dataOfType;

      // Assert
      expect(result, 42);
      expect(result, isA<int>());
    });

    test("title getter returns value", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        title: "Test Title",
      );

      // Assert
      expect(model.title, "Test Title");
    });

    test("status getter returns value", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        status: "pending",
      );

      // Assert
      expect(model.status, "pending");
    });

    test("message getter returns value", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        message: "Test message",
      );

      // Assert
      expect(model.message, "Test message");
    });

    test("totalCount getter returns value", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        totalCount: 100,
      );

      // Assert
      expect(model.totalCount, 100);
    });

    test("responseCode getter returns value", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createError(
        responseCode: 404,
        errorMessage: "Not Found",
      );

      // Assert
      expect(model.responseCode, 404);
    });

    test("developerMessage getter returns value", () {
      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        developerMessage: "Internal server error occurred",
      );

      // Assert
      expect(model.developerMessage, "Internal server error occurred");
    });

    test("fromJson with empty string values", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "title": "",
        "status": "",
        "message": "",
        "developerMessage": "",
      });

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 200,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.title, "");
      expect(model.status, "");
      expect(model.message, "");
      expect(model.developerMessage, "");
    });

    test("fromJson with special characters in strings", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "title": "José García",
        "message": "It's working!",
        "developerMessage": 'Error: "Unexpected token"',
      });

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 200,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.title, "José García");
      expect(model.message, "It's working!");
      expect(model.developerMessage, 'Error: "Unexpected token"');
    });

    test("fromJson with numeric edge cases", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "totalCount": 0,
        "responseCode": -1,
        "statusCode": 9999,
      });

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 9999,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.totalCount, 0);
      expect(model.responseCode, -1);
      expect(model.statusCode, 9999);
    });

    test("multiple instances are independent", () {
      // Act
      final ResponseMainDto<dynamic> model1 =
          ResponseMainDto<dynamic>.createError(
        responseCode: 400,
        errorMessage: "Error 1",
      );
      final ResponseMainDto<dynamic> model2 =
          ResponseMainDto<dynamic>.createError(
        responseCode: 500,
        errorMessage: "Error 2",
      );

      // Assert
      expect(model1.responseCode, 400);
      expect(model1.message, "Error 1");
      expect(model2.responseCode, 500);
      expect(model2.message, "Error 2");
    });

    test("fromJson preserves all fields through creation", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "title": "All Fields Test",
        "status": "complete",
        "message": "All fields populated",
        "totalCount": 15,
        "responseCode": 200,
        "developerMessage": "No errors",
        "data": <String, dynamic>{"key": "value"},
      });

      // Act
      final ResponseMainDto<dynamic> model = ResponseMainDto<dynamic>.fromJson(
        statusCode: 200,
        response: jsonString,
        fromJson: null,
      );

      // Assert
      expect(model.statusCode, 200);
      expect(model.title, "All Fields Test");
      expect(model.status, "complete");
      expect(model.message, "All fields populated");
      expect(model.totalCount, 15);
      expect(model.responseCode, 200);
      expect(model.developerMessage, "No errors");
      expect(model.data, isNotNull);
    });

    test("createErrorWithData with complex data object", () {
      // Arrange
      final Map<String, dynamic> complexData = <String, dynamic>{
        "id": 1,
        "name": "Test",
        "nested": <String, dynamic>{"key": "value"},
        "list": <int>[1, 2, 3],
      };

      // Act
      final ResponseMainDto<dynamic> model =
          ResponseMainDto<dynamic>.createErrorWithData(
        data: complexData,
        message: "Complex data error",
      );

      // Assert
      expect(model.data, complexData);
      expect(model.message, "Complex data error");
    });
  });

  group("ResponseMainException Tests", () {
    test("exception created from error response", () {
      // Arrange
      final ResponseMainDto<dynamic> errorResponse =
          ResponseMainDto<dynamic>.createError(
        responseCode: 400,
        errorMessage: "Bad Request",
      );

      // Act
      final ResponseMainException exception =
          ResponseMainException(errorResponse);

      // Assert
      expect(exception, isA<ResponseMainException>());
      expect(exception, isA<Exception>());
    });

    test("exception data getter returns response data", () {
      // Arrange
      const String testData = "error data";
      final ResponseMainDto<dynamic> errorResponse =
          ResponseMainDto<dynamic>.createErrorWithData(
        data: testData,
        responseCode: 400,
      );
      final ResponseMainException exception =
          ResponseMainException(errorResponse);

      // Act & Assert
      expect(exception.data, testData);
    });

    test("exception message getter returns response message", () {
      // Arrange
      final ResponseMainDto<dynamic> errorResponse =
          ResponseMainDto<dynamic>.createError(
        responseCode: 404,
        errorMessage: "Resource not found",
      );
      final ResponseMainException exception =
          ResponseMainException(errorResponse);

      // Act & Assert
      expect(exception.message, "Resource not found");
    });

    test("exception errorCode getter returns response code", () {
      // Arrange
      final ResponseMainDto<dynamic> errorResponse =
          ResponseMainDto<dynamic>.createError(
        responseCode: 500,
        errorMessage: "Server error",
      );
      final ResponseMainException exception =
          ResponseMainException(errorResponse);

      // Act & Assert
      expect(exception.errorCode, 500);
    });

    test("exception toString returns message", () {
      // Arrange
      final ResponseMainDto<dynamic> errorResponse =
          ResponseMainDto<dynamic>.createError(
        responseCode: 403,
        errorMessage: "Forbidden access",
      );
      final ResponseMainException exception =
          ResponseMainException(errorResponse);

      // Act & Assert
      expect(exception.toString(), "Forbidden access");
    });

    test("exception toString returns default when message is null", () {
      // Arrange
      final ResponseMainDto<dynamic> errorResponse =
          ResponseMainDto<dynamic>.createErrorWithData(
        responseCode: 400,
      );
      final ResponseMainException exception =
          ResponseMainException(errorResponse);

      // Act & Assert
      expect(exception.toString(), "General Error");
    });

    test("exception with all fields populated", () {
      // Arrange
      final ResponseMainDto<dynamic> errorResponse =
          ResponseMainDto<dynamic>.createErrorWithData(
        data: "error_data",
        message: "Complete error",
        responseCode: 422,
        title: "Validation Error",
        status: "error",
      );
      final ResponseMainException exception =
          ResponseMainException(errorResponse);

      // Act & Assert
      expect(exception.data, "error_data");
      expect(exception.message, "Complete error");
      expect(exception.errorCode, 422);
    });

    test("multiple exceptions are independent", () {
      // Arrange
      final ResponseMainDto<dynamic> response1 =
          ResponseMainDto<dynamic>.createError(
        responseCode: 400,
        errorMessage: "Error 1",
      );
      final ResponseMainDto<dynamic> response2 =
          ResponseMainDto<dynamic>.createError(
        responseCode: 500,
        errorMessage: "Error 2",
      );

      // Act
      final ResponseMainException exception1 = ResponseMainException(response1);
      final ResponseMainException exception2 = ResponseMainException(response2);

      // Assert
      expect(exception1.message, "Error 1");
      expect(exception1.errorCode, 400);
      expect(exception2.message, "Error 2");
      expect(exception2.errorCode, 500);
    });
  });

  group("MainTimeoutException Tests", () {
    test("MainTimeoutException creates with default values", () {
      // Act
      final MainTimeoutException exception = MainTimeoutException();

      // Assert
      expect(exception, isA<MainTimeoutException>());
      expect(exception, isA<ResponseMainException>());
      expect(exception.message, "Request timeout");
      expect(exception.errorCode, timeoutErrorCode);
    });

    test("MainTimeoutException with custom message", () {
      // Act
      final MainTimeoutException exception = MainTimeoutException(
        message: "Custom timeout message",
      );

      // Assert
      expect(exception.message, "Custom timeout message");
      expect(exception.errorCode, timeoutErrorCode);
    });

    test("MainTimeoutException with custom data", () {
      // Arrange
      const String customData = "timeout context";

      // Act
      final MainTimeoutException exception = MainTimeoutException(
        data: customData,
      );

      // Assert
      expect(exception.data, customData);
      expect(exception.message, "Request timeout");
    });

    test("MainTimeoutException with both custom message and data", () {
      // Arrange
      const String customData = "error context";
      const String customMessage = "Connection timed out after 30 seconds";

      // Act
      final MainTimeoutException exception = MainTimeoutException(
        message: customMessage,
        data: customData,
      );

      // Assert
      expect(exception.message, customMessage);
      expect(exception.data, customData);
      expect(exception.errorCode, timeoutErrorCode);
    });

    test("MainTimeoutException inherits ResponseMainException behavior", () {
      // Act
      final MainTimeoutException exception = MainTimeoutException(
        message: "Timeout occurred",
        data: "timeout_context",
      );

      // Assert
      expect(exception.toString(), "Timeout occurred");
      expect(exception.data, "timeout_context");
      expect(exception.errorCode, timeoutErrorCode);
    });

    test("MainTimeoutException status is timeout", () {
      // Act
      final MainTimeoutException exception = MainTimeoutException();

      // Assert
      expect(exception, isA<MainTimeoutException>());
    });

    test("multiple timeout exceptions are independent", () {
      // Act
      final MainTimeoutException exception1 = MainTimeoutException(
        message: "First timeout",
        data: "context1",
      );
      final MainTimeoutException exception2 = MainTimeoutException(
        message: "Second timeout",
        data: "context2",
      );

      // Assert
      expect(exception1.message, "First timeout");
      expect(exception1.data, "context1");
      expect(exception2.message, "Second timeout");
      expect(exception2.data, "context2");
    });
  });
}
