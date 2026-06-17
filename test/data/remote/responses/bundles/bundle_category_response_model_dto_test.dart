import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("BundleCategoryResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "type": "REGIONAL",
        "code": "reg-001",
        "title": "Regional",
      };

      // Act
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto.fromJson(json);

      // Assert
      expect(model.type, "REGIONAL");
      expect(model.code, "reg-001");
      expect(model.title, "Regional");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto.fromJson(json);

      // Assert
      expect(model.type, isNull);
      expect(model.code, isNull);
      expect(model.title, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto(
        type: "GLOBAL",
        code: "global-001",
        title: "Global",
      );

      // Assert
      expect(model.type, "GLOBAL");
      expect(model.code, "global-001");
      expect(model.title, "Global");
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto(
        type: "LOCAL",
        code: "local-001",
        title: "Local",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["type"], "LOCAL");
      expect(json["code"], "local-001");
      expect(json["title"], "Local");
    });

    test("toJson handles null fields", () {
      // Arrange
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["type"], isNull);
      expect(json["code"], isNull);
      expect(json["title"], isNull);
    });

    test("isCruise getter returns true when type is CRUISE", () {
      // Arrange
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto(type: "CRUISE");

      // Act
      final bool isCruise = model.isCruise;

      // Assert
      expect(isCruise, true);
    });

    test("isCruise getter returns false when type is not CRUISE", () {
      // Arrange
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto(type: "REGIONAL");

      // Act
      final bool isCruise = model.isCruise;

      // Assert
      expect(isCruise, false);
    });

    test("isCruise getter returns false when type is null", () {
      // Arrange
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto();

      // Act
      final bool isCruise = model.isCruise;

      // Assert
      expect(isCruise, false);
    });

    test("toDomain converts to BundleCategoryResponseModel correctly", () {
      // Arrange
      final BundleCategoryResponseModelDto dto =
          BundleCategoryResponseModelDto(
        type: "REGIONAL",
        code: "reg-001",
        title: "Regional",
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.type, "REGIONAL");
      expect(domain.code, "reg-001");
      expect(domain.title, "Regional");
    });

    test("toDomain handles null fields", () {
      // Arrange
      final BundleCategoryResponseModelDto dto =
          BundleCategoryResponseModelDto();

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.type, isNull);
      expect(domain.code, isNull);
      expect(domain.title, isNull);
    });

    test("fromDomain converts from BundleCategoryResponseModel", () {
      // Arrange
      final BundleCategoryResponseModelDto dto =
          BundleCategoryResponseModelDto();
      final domain = BundleCategoryResponseModel(
        type: "GLOBAL",
        code: "global-001",
        title: "Global",
      );

      // Act
      final result = dto.fromDomain(domain);

      // Assert
      expect(result.type, "GLOBAL");
      expect(result.code, "global-001");
      expect(result.title, "Global");
    });

    test("fromDomain handles null model", () {
      // Arrange
      final BundleCategoryResponseModelDto dto =
          BundleCategoryResponseModelDto();

      // Act
      final result = dto.fromDomain(null);

      // Assert
      expect(result.type, isNull);
      expect(result.code, isNull);
      expect(result.title, isNull);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "type": "LOCAL",
        "code": "local-001",
        "title": "Local",
      };

      // Act
      final BundleCategoryResponseModelDto model =
          BundleCategoryResponseModelDto.fromJson(originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["type"], originalJson["type"]);
      expect(resultJson["code"], originalJson["code"]);
      expect(resultJson["title"], originalJson["title"]);
    });
  });
}
