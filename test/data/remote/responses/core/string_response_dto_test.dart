import "package:esim_open_source/data/remote/responses/core/string_response_dto.dart";
import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for StringResponseDto
/// Tests JSON deserialization, field access, and domain mapping
void main() {
  group("StringResponseDto Tests", () {
    test("fromJson with boolean true value", () {
      // Arrange
      const bool testValue = true;

      // Act
      final StringResponseDto dto = StringResponseDto.fromJson(json: testValue);

      // Assert
      expect(dto.stringValue, true);
    });

    test("fromJson with boolean false value", () {
      // Arrange
      const bool testValue = false;

      // Act
      final StringResponseDto dto = StringResponseDto.fromJson(json: testValue);

      // Assert
      expect(dto.stringValue, false);
    });

    test("fromJson with null value", () {
      // Act
      final StringResponseDto dto = StringResponseDto.fromJson(json: null);

      // Assert
      expect(dto.stringValue, isNull);
    });

    test("stringValue getter returns assigned value", () {
      // Arrange
      final StringResponseDto dto = StringResponseDto.fromJson(json: true);

      // Act
      final bool? value = dto.stringValue;

      // Assert
      expect(value, true);
    });

    test("stringValue is nullable", () {
      // Act
      final StringResponseDto dto = StringResponseDto.fromJson(json: null);

      // Assert
      expect(dto.stringValue, isNull);
    });


    test("toDomain returns StringResponse with stringValue", () {
      // Arrange
      final StringResponseDto dto = StringResponseDto.fromJson(json: true);

      // Act
      final StringResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel, isA<StringResponse>());
      expect(domainModel.stringValue, true);
    });

    test("toDomain with null stringValue", () {
      // Arrange
      final StringResponseDto dto = StringResponseDto.fromJson(json: null);

      // Act
      final StringResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel, isA<StringResponse>());
      expect(domainModel.stringValue, isNull);
    });

    test("toDomain with false value", () {
      // Arrange
      final StringResponseDto dto = StringResponseDto.fromJson(json: false);

      // Act
      final StringResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.stringValue, false);
    });

    test("multiple instances with different values are independent", () {
      // Act
      final StringResponseDto dto1 = StringResponseDto.fromJson(json: true);
      final StringResponseDto dto2 = StringResponseDto.fromJson(json: false);

      // Assert
      expect(dto1.stringValue, true);
      expect(dto2.stringValue, false);
    });

    test("stringValue getter encapsulates private field", () {
      // Arrange
      final StringResponseDto dto = StringResponseDto.fromJson(json: true);

      // Act
      final bool? value = dto.stringValue;

      // Assert
      expect(value, true);
      // Verify the field is stored correctly through the getter
      expect(dto.stringValue, value);
    });

    test("fromJson and toDomain preserve value", () {
      // Arrange
      const bool originalValue = true;

      // Act
      final StringResponseDto dto =
          StringResponseDto.fromJson(json: originalValue);
      final StringResponse domain = dto.toDomain();

      // Assert
      expect(domain.stringValue, originalValue);
    });
  });
}
