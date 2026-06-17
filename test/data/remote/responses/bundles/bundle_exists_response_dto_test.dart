import "package:esim_open_source/data/remote/responses/bundles/bundle_exists_response_dto.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleExistsResponseDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("BundleExistsResponseDto Tests", () {
    test("fromJson creates instance with true value", () {
      // Act
      final BundleExistsResponseDto model =
          BundleExistsResponseDto.fromJson(json: true);

      // Assert
      expect(model.exists, true);
    });

    test("fromJson creates instance with false value", () {
      // Act
      final BundleExistsResponseDto model =
          BundleExistsResponseDto.fromJson(json: false);

      // Assert
      expect(model.exists, false);
    });

    test("fromJson handles null value", () {
      // Act
      final BundleExistsResponseDto model =
          BundleExistsResponseDto.fromJson(json: null);

      // Assert
      expect(model.exists, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final BundleExistsResponseDto model = BundleExistsResponseDto(
        exists: true,
      );

      // Assert
      expect(model.exists, true);
    });

    test("constructor with null exists", () {
      // Act
      final BundleExistsResponseDto model = BundleExistsResponseDto(
        exists: null,
      );

      // Assert
      expect(model.exists, isNull);
    });

    test("constructor with no arguments", () {
      // Act
      final BundleExistsResponseDto model = BundleExistsResponseDto();

      // Assert
      expect(model.exists, isNull);
    });

    test("toDomain converts to BundleExistsResponse correctly", () {
      // Arrange
      final BundleExistsResponseDto dto = BundleExistsResponseDto(
        exists: true,
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.exists, true);
    });

    test("toDomain preserves null exists value", () {
      // Arrange
      final BundleExistsResponseDto dto = BundleExistsResponseDto(
        exists: null,
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.exists, isNull);
    });

    test("toDomain with false value", () {
      // Arrange
      final BundleExistsResponseDto dto = BundleExistsResponseDto(
        exists: false,
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.exists, false);
    });

    test("multiple instances are independent", () {
      // Act
      final BundleExistsResponseDto model1 =
          BundleExistsResponseDto(exists: true);
      final BundleExistsResponseDto model2 =
          BundleExistsResponseDto(exists: false);

      // Assert
      expect(model1.exists, true);
      expect(model2.exists, false);
    });

    test("fromJson value is of correct type", () {
      // Act
      final BundleExistsResponseDto model =
          BundleExistsResponseDto.fromJson(json: true);

      // Assert
      expect(model.exists, isA<bool>());
    });
  });
}
