import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for EmptyResponseDto
/// Tests JSON deserialization and domain mapping
void main() {
  group("EmptyResponseDto Tests", () {
    test("constructor creates empty instance", () {
      // Act
      final EmptyResponseDto dto = EmptyResponseDto();

      // Assert
      expect(dto, isNotNull);
    });

    test("fromJson with string value", () {
      // Act
      final EmptyResponseDto dto = EmptyResponseDto.fromJson(json: "test_value");

      // Assert
      expect(dto, isNotNull);
    });

    test("fromJson with empty string", () {
      // Act
      final EmptyResponseDto dto = EmptyResponseDto.fromJson(json: "");

      // Assert
      expect(dto, isNotNull);
    });

    test("fromJson with number as string", () {
      // Act
      final EmptyResponseDto dto = EmptyResponseDto.fromJson(json: "123");

      // Assert
      expect(dto, isNotNull);
    });

    test("toDomain returns EmptyResponse", () {
      // Arrange
      final EmptyResponseDto dto = EmptyResponseDto();

      // Act
      final EmptyResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel, isA<EmptyResponse>());
      expect(domainModel, isNotNull);
    });

    test("toDomain from fromJson returns EmptyResponse", () {
      // Arrange
      final EmptyResponseDto dto = EmptyResponseDto.fromJson(
        json: "test_data",
      );

      // Act
      final EmptyResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel, isA<EmptyResponse>());
      expect(domainModel, isNotNull);
    });

    test("multiple instances are independent", () {
      // Act
      final EmptyResponseDto dto1 = EmptyResponseDto();
      final EmptyResponseDto dto2 = EmptyResponseDto();

      // Assert
      expect(dto1, isNotNull);
      expect(dto2, isNotNull);
      expect(dto1, isNot(dto2));
    });

    test("fromJson logs the provided value", () {
      // Act
      final EmptyResponseDto dto = EmptyResponseDto.fromJson(json: "logged_value");

      // Assert
      // fromJson just logs the value, so we verify the dto is created successfully
      expect(dto, isNotNull);
    });

    test("toDomain always returns new instance", () {
      // Arrange
      final EmptyResponseDto dto = EmptyResponseDto();

      // Act
      final EmptyResponse domain1 = dto.toDomain();
      final EmptyResponse domain2 = dto.toDomain();

      // Assert
      expect(domain1, isNot(domain2));
    });
  });
}
