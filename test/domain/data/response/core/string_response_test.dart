import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for StringResponse
/// Tests constructor, getter, and null handling
void main() {
  group("StringResponse Tests", () {
    test("constructor creates instance with stringValue true", () {
      // Act
      final StringResponse response = StringResponse(stringValue: true);

      // Assert
      expect(response, isNotNull);
      expect(response, isA<StringResponse>());
      expect(response.stringValue, true);
    });

    test("constructor creates instance with stringValue false", () {
      // Act
      final StringResponse response = StringResponse(stringValue: false);

      // Assert
      expect(response, isNotNull);
      expect(response.stringValue, false);
    });

    test("constructor creates instance with null stringValue", () {
      // Act
      final StringResponse response = StringResponse();

      // Assert
      expect(response, isNotNull);
      expect(response.stringValue, isNull);
    });

    test("constructor creates instance without stringValue parameter", () {
      // Act
      final StringResponse response = StringResponse();

      // Assert
      expect(response, isNotNull);
      expect(response.stringValue, isNull);
    });

    test("getter returns correct stringValue when true", () {
      // Arrange
      final StringResponse response = StringResponse(stringValue: true);

      // Act
      final bool? result = response.stringValue;

      // Assert
      expect(result, true);
    });

    test("getter returns correct stringValue when false", () {
      // Arrange
      final StringResponse response = StringResponse(stringValue: false);

      // Act
      final bool? result = response.stringValue;

      // Assert
      expect(result, false);
    });

    test("getter returns null when stringValue is null", () {
      // Arrange
      final StringResponse response = StringResponse();

      // Act
      final bool? result = response.stringValue;

      // Assert
      expect(result, isNull);
    });

    test("multiple instances are independent", () {
      // Act
      final StringResponse response1 = StringResponse(stringValue: true);
      final StringResponse response2 = StringResponse(stringValue: false);
      final StringResponse response3 = StringResponse();

      // Assert
      expect(response1.stringValue, true);
      expect(response2.stringValue, false);
      expect(response3.stringValue, isNull);
    });

    test("stringValue can be accessed multiple times", () {
      // Arrange
      final StringResponse response = StringResponse(stringValue: true);

      // Act
      final bool? firstAccess = response.stringValue;
      final bool? secondAccess = response.stringValue;
      final bool? thirdAccess = response.stringValue;

      // Assert
      expect(firstAccess, true);
      expect(secondAccess, true);
      expect(thirdAccess, true);
      expect(firstAccess, equals(secondAccess));
      expect(secondAccess, equals(thirdAccess));
    });

    test("stringValue is nullable type", () {
      // Act
      final StringResponse response = StringResponse();

      // Assert
      expect(response.stringValue, isNull);
      expect(response.stringValue, isA<bool?>());
    });
  });
}
