import "dart:convert";

import "package:esim_open_source/data/remote/responses/app/banner_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("BannerResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "title": "Refer Your Friends",
        "description": "Invite your friends to experience",
        "image":
            "https://oqonyfelpyoexoqlesic.supabase.co/storage/v1/object/public/media/banners-web/refer-your-friends.png",
        "action": "REFER_NOW",
      };

      // Act
      final BannerResponseModelDto model =
          BannerResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.title, "Refer Your Friends");
      expect(model.description, "Invite your friends to experience");
      expect(
        model.image,
        "https://oqonyfelpyoexoqlesic.supabase.co/storage/v1/object/public/media/banners-web/refer-your-friends.png",
      );
      expect(model.action, "REFER_NOW");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final BannerResponseModelDto model =
          BannerResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.title, isNull);
      expect(model.description, isNull);
      expect(model.image, isNull);
      expect(model.action, isNull);
    });

    test("fromJson handles explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "title": null,
        "description": null,
        "image": null,
        "action": null,
      };

      // Act
      final BannerResponseModelDto model =
          BannerResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.title, isNull);
      expect(model.description, isNull);
      expect(model.image, isNull);
      expect(model.action, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final BannerResponseModelDto model = BannerResponseModelDto(
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.png",
        action: "TEST_ACTION",
      );

      // Assert
      expect(model.title, "Test Title");
      expect(model.description, "Test Description");
      expect(model.image, "https://example.com/image.png");
      expect(model.action, "TEST_ACTION");
    });

    test("constructor with minimal fields", () {
      // Act
      final BannerResponseModelDto model = BannerResponseModelDto(
        title: "Test Title",
      );

      // Assert
      expect(model.title, "Test Title");
      expect(model.description, isNull);
      expect(model.image, isNull);
      expect(model.action, isNull);
    });

    test("constructor with all fields nullable", () {
      // Act
      final BannerResponseModelDto model = BannerResponseModelDto();

      // Assert
      expect(model.title, isNull);
      expect(model.description, isNull);
      expect(model.image, isNull);
      expect(model.action, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final BannerResponseModelDto model = BannerResponseModelDto(
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.png",
        action: "TEST_ACTION",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["title"], "Test Title");
      expect(json["description"], "Test Description");
      expect(json["image"], "https://example.com/image.png");
      expect(json["action"], "TEST_ACTION");
    });

    test("toJson handles null fields", () {
      // Arrange
      final BannerResponseModelDto model = BannerResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["title"], isNull);
      expect(json["description"], isNull);
      expect(json["image"], isNull);
      expect(json["action"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final BannerResponseModelDto original = BannerResponseModelDto(
        title: "Original Title",
        description: "Original Description",
        image: "https://example.com/original.png",
        action: "ORIGINAL_ACTION",
      );

      // Act
      final BannerResponseModelDto updated = original.copyWith(
        title: "Updated Title",
      );

      // Assert
      expect(updated.title, "Updated Title");
      expect(updated.description, "Original Description");
      expect(updated.image, "https://example.com/original.png");
      expect(updated.action, "ORIGINAL_ACTION");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final BannerResponseModelDto original = BannerResponseModelDto(
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.png",
        action: "TEST_ACTION",
      );

      // Act
      final BannerResponseModelDto copied = original.copyWith();

      // Assert
      expect(copied.title, original.title);
      expect(copied.description, original.description);
      expect(copied.image, original.image);
      expect(copied.action, original.action);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final BannerResponseModelDto original = BannerResponseModelDto(
        title: "Test Title",
      );

      // Act
      final BannerResponseModelDto updated = original.copyWith(
        description: "New Description",
      );

      // Assert
      expect(updated.title, "Test Title");
      expect(updated.description, "New Description");
      expect(updated.image, isNull);
      expect(updated.action, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final BannerResponseModelDto original = BannerResponseModelDto(
        title: "Original Title",
      );

      // Act
      final BannerResponseModelDto updated = original.copyWith(
        title: "Updated Title",
      );

      // Assert
      expect(original.title, "Original Title");
      expect(updated.title, "Updated Title");
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{
          "title": "Banner 1",
          "description": "Description 1",
          "image": "https://example.com/1.png",
          "action": "ACTION_1",
        },
        <String, dynamic>{
          "title": "Banner 2",
          "description": "Description 2",
          "image": "https://example.com/2.png",
          "action": "ACTION_2",
        },
      ];

      // Act
      final List<BannerResponseModelDto> models =
          BannerResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].title, "Banner 1");
      expect(models[0].description, "Description 1");
      expect(models[1].title, "Banner 2");
      expect(models[1].description, "Description 2");
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<BannerResponseModelDto> models =
          BannerResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("toJsonListString converts list to JSON string", () {
      // Arrange
      final List<BannerResponseModelDto> models = <BannerResponseModelDto>[
        BannerResponseModelDto(
          title: "Banner 1",
          description: "Description 1",
          image: "https://example.com/1.png",
          action: "ACTION_1",
        ),
        BannerResponseModelDto(
          title: "Banner 2",
          description: "Description 2",
          image: "https://example.com/2.png",
          action: "ACTION_2",
        ),
      ];

      // Act
      final String jsonString = BannerResponseModelDto.toJsonListString(models);
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;

      // Assert
      expect(decoded, isNotNull);
      expect(decoded.length, 2);
      expect((decoded[0] as Map<String, dynamic>)["title"], "Banner 1");
      expect((decoded[1] as Map<String, dynamic>)["title"], "Banner 2");
    });

    test("fromJsonListString parses JSON string to list", () {
      // Arrange
      final String jsonString = jsonEncode(<Map<String, dynamic>>[
        <String, dynamic>{
          "title": "Banner 1",
          "description": "Description 1",
          "image": "https://example.com/1.png",
          "action": "ACTION_1",
        },
        <String, dynamic>{
          "title": "Banner 2",
          "description": "Description 2",
          "image": "https://example.com/2.png",
          "action": "ACTION_2",
        },
      ]);

      // Act
      final List<BannerResponseModelDto> models =
          BannerResponseModelDto.fromJsonListString(jsonString);

      // Assert
      expect(models.length, 2);
      expect(models[0].title, "Banner 1");
      expect(models[1].title, "Banner 2");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "title": "Test Title",
        "description": "Test Description",
        "image": "https://example.com/image.png",
        "action": "TEST_ACTION",
      };

      // Act
      final BannerResponseModelDto model =
          BannerResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["title"], originalJson["title"]);
      expect(resultJson["description"], originalJson["description"]);
      expect(resultJson["image"], originalJson["image"]);
      expect(resultJson["action"], originalJson["action"]);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "title": "",
        "description": "",
        "image": "",
        "action": "",
      };

      // Act
      final BannerResponseModelDto model =
          BannerResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.title, "");
      expect(model.description, "");
      expect(model.image, "");
      expect(model.action, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "title": "José's Banner",
        "description": "O'Brien's Description",
        "image": "https://example.com/image%20with%20spaces.png",
        "action": "SPECIAL_ACTION_!@#\$%",
      };

      // Act
      final BannerResponseModelDto model =
          BannerResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.title, "José's Banner");
      expect(model.description, "O'Brien's Description");
      expect(model.image, "https://example.com/image%20with%20spaces.png");
      expect(model.action, "SPECIAL_ACTION_!@#\$%");
    });

    test("multiple instances are independent", () {
      // Act
      final BannerResponseModelDto model1 = BannerResponseModelDto(
        title: "Title 1",
      );
      final BannerResponseModelDto model2 = BannerResponseModelDto(
        title: "Title 2",
      );

      // Assert
      expect(model1.title, "Title 1");
      expect(model2.title, "Title 2");
    });

    test("fromDomain creates DTO from domain model with all fields", () {
      // Arrange
      final BannerResponseModel domainModel = BannerResponseModel(
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.png",
        action: "TEST_ACTION",
      );

      // Act
      final BannerResponseModelDto dto =
          BannerResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(dto.title, "Test Title");
      expect(dto.description, "Test Description");
      expect(dto.image, "https://example.com/image.png");
      expect(dto.action, "TEST_ACTION");
    });

    test("fromDomain creates DTO from domain model with null fields", () {
      // Arrange
      final BannerResponseModel domainModel = BannerResponseModel();

      // Act
      final BannerResponseModelDto dto =
          BannerResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(dto.title, isNull);
      expect(dto.description, isNull);
      expect(dto.image, isNull);
      expect(dto.action, isNull);
    });

    test("fromDomain creates DTO from domain model with partial fields", () {
      // Arrange
      final BannerResponseModel domainModel = BannerResponseModel(
        title: "Only Title",
        action: "ONLY_ACTION",
      );

      // Act
      final BannerResponseModelDto dto =
          BannerResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(dto.title, "Only Title");
      expect(dto.description, isNull);
      expect(dto.image, isNull);
      expect(dto.action, "ONLY_ACTION");
    });

    test("toDomain converts DTO to domain model with all fields", () {
      // Arrange
      final BannerResponseModelDto dto = BannerResponseModelDto(
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.png",
        action: "TEST_ACTION",
      );

      // Act
      final BannerResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.title, "Test Title");
      expect(domainModel.description, "Test Description");
      expect(domainModel.image, "https://example.com/image.png");
      expect(domainModel.action, "TEST_ACTION");
    });

    test("toDomain converts DTO to domain model with null fields", () {
      // Arrange
      final BannerResponseModelDto dto = BannerResponseModelDto();

      // Act
      final BannerResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.title, isNull);
      expect(domainModel.description, isNull);
      expect(domainModel.image, isNull);
      expect(domainModel.action, isNull);
    });

    test("toDomain converts DTO to domain model with partial fields", () {
      // Arrange
      final BannerResponseModelDto dto = BannerResponseModelDto(
        title: "Only Title",
        image: "https://example.com/image.png",
      );

      // Act
      final BannerResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.title, "Only Title");
      expect(domainModel.description, isNull);
      expect(domainModel.image, "https://example.com/image.png");
      expect(domainModel.action, isNull);
    });

    test("roundtrip fromDomain and toDomain preserves data", () {
      // Arrange
      final BannerResponseModel originalDomain = BannerResponseModel(
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.png",
        action: "TEST_ACTION",
      );

      // Act
      final BannerResponseModelDto dto =
          BannerResponseModelDto.fromDomain(originalDomain);
      final BannerResponseModel resultDomain = dto.toDomain();

      // Assert
      expect(resultDomain.title, originalDomain.title);
      expect(resultDomain.description, originalDomain.description);
      expect(resultDomain.image, originalDomain.image);
      expect(resultDomain.action, originalDomain.action);
    });

    test("fromDomain and toDomain are inverses", () {
      // Arrange
      final BannerResponseModelDto originalDto = BannerResponseModelDto(
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.png",
        action: "TEST_ACTION",
      );

      // Act
      final BannerResponseModel domainModel = originalDto.toDomain();
      final BannerResponseModelDto resultDto =
          BannerResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(resultDto.title, originalDto.title);
      expect(resultDto.description, originalDto.description);
      expect(resultDto.image, originalDto.image);
      expect(resultDto.action, originalDto.action);
    });
  });
}
