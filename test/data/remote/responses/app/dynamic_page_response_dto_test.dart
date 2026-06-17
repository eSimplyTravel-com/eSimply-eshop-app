import "package:esim_open_source/data/remote/responses/app/dynamic_page_response_dto.dart";
import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("DynamicPageResponseDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "page_title": "About Us",
        "page_content":
            "Welcome to our eSIM platform! We provide seamless digital SIM solutions.",
        "page_intro": "Empowering Connectivity with eSIM Technology",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, "About Us");
      expect(
        model.pageContent,
        "Welcome to our eSIM platform! We provide seamless digital SIM solutions.",
      );
      expect(model.pageIntro, "Empowering Connectivity with eSIM Technology");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, isNull);
      expect(model.pageContent, isNull);
      expect(model.pageIntro, isNull);
    });

    test("fromJson handles explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "page_title": null,
        "page_content": null,
        "page_intro": null,
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, isNull);
      expect(model.pageContent, isNull);
      expect(model.pageIntro, isNull);
    });

    test("fromJson handles null page_title", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "page_content": "Content",
        "page_intro": "Intro",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, isNull);
      expect(model.pageContent, "Content");
      expect(model.pageIntro, "Intro");
    });

    test("fromJson handles null page_content", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "page_title": "Title",
        "page_intro": "Intro",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, "Title");
      expect(model.pageContent, isNull);
      expect(model.pageIntro, "Intro");
    });

    test("fromJson handles null page_intro", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "page_title": "Title",
        "page_content": "Content",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, "Title");
      expect(model.pageContent, "Content");
      expect(model.pageIntro, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final DynamicPageResponseDto model = DynamicPageResponseDto(
        pageTitle: "Test Title",
        pageContent: "Test Content",
        pageIntro: "Test Intro",
      );

      // Assert
      expect(model.pageTitle, "Test Title");
      expect(model.pageContent, "Test Content");
      expect(model.pageIntro, "Test Intro");
    });

    test("constructor with minimal fields", () {
      // Act
      final DynamicPageResponseDto model = DynamicPageResponseDto(
        pageTitle: "Test Title",
      );

      // Assert
      expect(model.pageTitle, "Test Title");
      expect(model.pageContent, isNull);
      expect(model.pageIntro, isNull);
    });

    test("constructor with all fields nullable", () {
      // Act
      final DynamicPageResponseDto model = DynamicPageResponseDto();

      // Assert
      expect(model.pageTitle, isNull);
      expect(model.pageContent, isNull);
      expect(model.pageIntro, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final DynamicPageResponseDto model = DynamicPageResponseDto(
        pageTitle: "Test Title",
        pageContent: "Test Content",
        pageIntro: "Test Intro",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["page_title"], "Test Title");
      expect(json["page_content"], "Test Content");
      expect(json["page_intro"], "Test Intro");
    });

    test("toJson handles null fields", () {
      // Arrange
      final DynamicPageResponseDto model = DynamicPageResponseDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["page_title"], isNull);
      expect(json["page_content"], isNull);
      expect(json["page_intro"], isNull);
    });

    test("toJson with partial fields", () {
      // Arrange
      final DynamicPageResponseDto model = DynamicPageResponseDto(
        pageTitle: "Test Title",
        pageContent: "Test Content",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["page_title"], "Test Title");
      expect(json["page_content"], "Test Content");
      expect(json["page_intro"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final DynamicPageResponseDto original = DynamicPageResponseDto(
        pageTitle: "Original Title",
        pageContent: "Original Content",
        pageIntro: "Original Intro",
      );

      // Act
      final DynamicPageResponseDto updated = original.copyWith(
        pageTitle: "Updated Title",
      );

      // Assert
      expect(updated.pageTitle, "Updated Title");
      expect(updated.pageContent, "Original Content");
      expect(updated.pageIntro, "Original Intro");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final DynamicPageResponseDto original = DynamicPageResponseDto(
        pageTitle: "Test Title",
        pageContent: "Test Content",
        pageIntro: "Test Intro",
      );

      // Act
      final DynamicPageResponseDto copied = original.copyWith();

      // Assert
      expect(copied.pageTitle, original.pageTitle);
      expect(copied.pageContent, original.pageContent);
      expect(copied.pageIntro, original.pageIntro);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final DynamicPageResponseDto original = DynamicPageResponseDto(
        pageTitle: "Test Title",
      );

      // Act
      final DynamicPageResponseDto updated = original.copyWith(
        pageContent: "New Content",
      );

      // Assert
      expect(updated.pageTitle, "Test Title");
      expect(updated.pageContent, "New Content");
      expect(updated.pageIntro, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final DynamicPageResponseDto original = DynamicPageResponseDto(
        pageTitle: "Original Title",
      );

      // Act
      final DynamicPageResponseDto updated = original.copyWith(
        pageTitle: "Updated Title",
      );

      // Assert
      expect(original.pageTitle, "Original Title");
      expect(updated.pageTitle, "Updated Title");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final DynamicPageResponseDto original = DynamicPageResponseDto(
        pageTitle: "Original Title",
        pageContent: "Original Content",
        pageIntro: "Original Intro",
      );

      // Act
      final DynamicPageResponseDto updated = original.copyWith(
        pageTitle: "Updated Title",
        pageContent: "Updated Content",
      );

      // Assert
      expect(updated.pageTitle, "Updated Title");
      expect(updated.pageContent, "Updated Content");
      expect(updated.pageIntro, "Original Intro");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "page_title": "Test Title",
        "page_content": "Test Content",
        "page_intro": "Test Intro",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["page_title"], originalJson["page_title"]);
      expect(resultJson["page_content"], originalJson["page_content"]);
      expect(resultJson["page_intro"], originalJson["page_intro"]);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "page_title": "",
        "page_content": "",
        "page_intro": "",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, "");
      expect(model.pageContent, "");
      expect(model.pageIntro, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "page_title": "José's Page",
        "page_content": "O'Brien's Content with \"quotes\"",
        "page_intro": "Intro with special chars !@#\$%",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageTitle, "José's Page");
      expect(model.pageContent, "O'Brien's Content with \"quotes\"");
      expect(model.pageIntro, "Intro with special chars !@#\$%");
    });

    test("handles long content strings", () {
      // Arrange
      final String longContent = "Welcome to our eSIM platform! " * 100;
      final Map<String, dynamic> json = <String, dynamic>{
        "page_title": "Long Title",
        "page_content": longContent,
        "page_intro": "Long Intro",
      };

      // Act
      final DynamicPageResponseDto model =
          DynamicPageResponseDto.fromJson(json: json);

      // Assert
      expect(model.pageContent, longContent);
    });

    test("multiple instances are independent", () {
      // Act
      final DynamicPageResponseDto model1 = DynamicPageResponseDto(
        pageTitle: "Title 1",
      );
      final DynamicPageResponseDto model2 = DynamicPageResponseDto(
        pageTitle: "Title 2",
      );

      // Assert
      expect(model1.pageTitle, "Title 1");
      expect(model2.pageTitle, "Title 2");
    });

    test("toDomain converts DTO to domain model with all fields", () {
      // Arrange
      final DynamicPageResponseDto dto = DynamicPageResponseDto(
        pageTitle: "Test Title",
        pageContent: "Test Content",
        pageIntro: "Test Intro",
      );

      // Act
      final DynamicPageResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.pageTitle, "Test Title");
      expect(domainModel.pageContent, "Test Content");
      expect(domainModel.pageIntro, "Test Intro");
    });

    test("toDomain converts DTO to domain model with null fields", () {
      // Arrange
      final DynamicPageResponseDto dto = DynamicPageResponseDto();

      // Act
      final DynamicPageResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.pageTitle, isNull);
      expect(domainModel.pageContent, isNull);
      expect(domainModel.pageIntro, isNull);
    });

    test("toDomain converts DTO to domain model with partial fields", () {
      // Arrange
      final DynamicPageResponseDto dto = DynamicPageResponseDto(
        pageTitle: "Only Title",
        pageIntro: "Only Intro",
      );

      // Act
      final DynamicPageResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.pageTitle, "Only Title");
      expect(domainModel.pageContent, isNull);
      expect(domainModel.pageIntro, "Only Intro");
    });

    test("roundtrip toDomain preserves all page data", () {
      // Arrange
      final DynamicPageResponseDto originalDto = DynamicPageResponseDto(
        pageTitle: "Original Title",
        pageContent: "Original Content",
        pageIntro: "Original Intro",
      );

      // Act
      final DynamicPageResponse domainModel = originalDto.toDomain();

      // Assert
      expect(domainModel.pageTitle, "Original Title");
      expect(domainModel.pageContent, "Original Content");
      expect(domainModel.pageIntro, "Original Intro");
    });
  });
}
