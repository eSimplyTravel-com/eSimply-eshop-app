import "dart:convert";

import "package:esim_open_source/data/remote/responses/app/configuration_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("ConfigurationResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "key": "app_version",
        "value": "1.0.0",
      };

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.key, "app_version");
      expect(model.value, "1.0.0");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.key, isNull);
      expect(model.value, isNull);
    });

    test("fromJson handles explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "key": null,
        "value": null,
      };

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.key, isNull);
      expect(model.value, isNull);
    });

    test("fromJson handles null key", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "value": "some_value",
      };

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.key, isNull);
      expect(model.value, "some_value");
    });

    test("fromJson handles null value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "key": "some_key",
      };

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.key, "some_key");
      expect(model.value, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final ConfigurationResponseModelDto model = ConfigurationResponseModelDto(
        key: "test_key",
        value: "test_value",
      );

      // Assert
      expect(model.key, "test_key");
      expect(model.value, "test_value");
    });

    test("constructor with minimal fields", () {
      // Act
      final ConfigurationResponseModelDto model = ConfigurationResponseModelDto(
        key: "test_key",
      );

      // Assert
      expect(model.key, "test_key");
      expect(model.value, isNull);
    });

    test("constructor with all fields nullable", () {
      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto();

      // Assert
      expect(model.key, isNull);
      expect(model.value, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final ConfigurationResponseModelDto model = ConfigurationResponseModelDto(
        key: "test_key",
        value: "test_value",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["key"], "test_key");
      expect(json["value"], "test_value");
    });

    test("toJson handles null fields", () {
      // Arrange
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["key"], isNull);
      expect(json["value"], isNull);
    });

    test("toJson with partial fields", () {
      // Arrange
      final ConfigurationResponseModelDto model = ConfigurationResponseModelDto(
        key: "test_key",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["key"], "test_key");
      expect(json["value"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final ConfigurationResponseModelDto original =
          ConfigurationResponseModelDto(
        key: "original_key",
        value: "original_value",
      );

      // Act
      final ConfigurationResponseModelDto updated = original.copyWith(
        key: "updated_key",
      );

      // Assert
      expect(updated.key, "updated_key");
      expect(updated.value, "original_value");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final ConfigurationResponseModelDto original =
          ConfigurationResponseModelDto(
        key: "test_key",
        value: "test_value",
      );

      // Act
      final ConfigurationResponseModelDto copied = original.copyWith();

      // Assert
      expect(copied.key, original.key);
      expect(copied.value, original.value);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final ConfigurationResponseModelDto original =
          ConfigurationResponseModelDto(
        key: "test_key",
      );

      // Act
      final ConfigurationResponseModelDto updated = original.copyWith(
        value: "new_value",
      );

      // Assert
      expect(updated.key, "test_key");
      expect(updated.value, "new_value");
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final ConfigurationResponseModelDto original =
          ConfigurationResponseModelDto(
        key: "original_key",
      );

      // Act
      final ConfigurationResponseModelDto updated = original.copyWith(
        key: "updated_key",
      );

      // Assert
      expect(original.key, "original_key");
      expect(updated.key, "updated_key");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final ConfigurationResponseModelDto original =
          ConfigurationResponseModelDto(
        key: "original_key",
        value: "original_value",
      );

      // Act
      final ConfigurationResponseModelDto updated = original.copyWith(
        key: "updated_key",
        value: "updated_value",
      );

      // Assert
      expect(updated.key, "updated_key");
      expect(updated.value, "updated_value");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "key": "test_key",
        "value": "test_value",
      };

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["key"], originalJson["key"]);
      expect(resultJson["value"], originalJson["value"]);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "key": "",
        "value": "",
      };

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.key, "");
      expect(model.value, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "key": "key_with_special_!@#\$%",
        "value": "value_with_José's_name",
      };

      // Act
      final ConfigurationResponseModelDto model =
          ConfigurationResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.key, "key_with_special_!@#\$%");
      expect(model.value, "value_with_José's_name");
    });

    test("multiple instances are independent", () {
      // Act
      final ConfigurationResponseModelDto model1 =
          ConfigurationResponseModelDto(
        key: "key_1",
      );
      final ConfigurationResponseModelDto model2 =
          ConfigurationResponseModelDto(
        key: "key_2",
      );

      // Assert
      expect(model1.key, "key_1");
      expect(model2.key, "key_2");
    });

    test("fromDomain creates DTO from domain model with all fields", () {
      // Arrange
      final ConfigurationResponseModel domainModel =
          ConfigurationResponseModel(
        key: "test_key",
        value: "test_value",
      );

      // Act
      final ConfigurationResponseModelDto dto =
          ConfigurationResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(dto.key, "test_key");
      expect(dto.value, "test_value");
    });

    test("fromDomain creates DTO from domain model with null fields", () {
      // Arrange
      final ConfigurationResponseModel domainModel =
          ConfigurationResponseModel();

      // Act
      final ConfigurationResponseModelDto dto =
          ConfigurationResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(dto.key, isNull);
      expect(dto.value, isNull);
    });

    test("fromDomain creates DTO from domain model with partial fields", () {
      // Arrange
      final ConfigurationResponseModel domainModel =
          ConfigurationResponseModel(
        key: "only_key",
      );

      // Act
      final ConfigurationResponseModelDto dto =
          ConfigurationResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(dto.key, "only_key");
      expect(dto.value, isNull);
    });

    test("toDomain converts DTO to domain model with all fields", () {
      // Arrange
      final ConfigurationResponseModelDto dto = ConfigurationResponseModelDto(
        key: "test_key",
        value: "test_value",
      );

      // Act
      final ConfigurationResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.key, "test_key");
      expect(domainModel.value, "test_value");
    });

    test("toDomain converts DTO to domain model with null fields", () {
      // Arrange
      final ConfigurationResponseModelDto dto =
          ConfigurationResponseModelDto();

      // Act
      final ConfigurationResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.key, isNull);
      expect(domainModel.value, isNull);
    });

    test("toDomain converts DTO to domain model with partial fields", () {
      // Arrange
      final ConfigurationResponseModelDto dto = ConfigurationResponseModelDto(
        key: "only_key",
        value: "only_value",
      );

      // Act
      final ConfigurationResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.key, "only_key");
      expect(domainModel.value, "only_value");
    });

    test("roundtrip fromDomain and toDomain preserves data", () {
      // Arrange
      final ConfigurationResponseModel originalDomain =
          ConfigurationResponseModel(
        key: "test_key",
        value: "test_value",
      );

      // Act
      final ConfigurationResponseModelDto dto =
          ConfigurationResponseModelDto.fromDomain(originalDomain);
      final ConfigurationResponseModel resultDomain = dto.toDomain();

      // Assert
      expect(resultDomain.key, originalDomain.key);
      expect(resultDomain.value, originalDomain.value);
    });

    test("fromDomain and toDomain are inverses", () {
      // Arrange
      final ConfigurationResponseModelDto originalDto =
          ConfigurationResponseModelDto(
        key: "test_key",
        value: "test_value",
      );

      // Act
      final ConfigurationResponseModel domainModel = originalDto.toDomain();
      final ConfigurationResponseModelDto resultDto =
          ConfigurationResponseModelDto.fromDomain(domainModel);

      // Assert
      expect(resultDto.key, originalDto.key);
      expect(resultDto.value, originalDto.value);
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{"key": "key1", "value": "value1"},
        <String, dynamic>{"key": "key2", "value": "value2"},
        <String, dynamic>{"key": "key3", "value": "value3"},
      ];

      // Act
      final List<ConfigurationResponseModelDto> models =
          ConfigurationResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 3);
      expect(models[0].key, "key1");
      expect(models[0].value, "value1");
      expect(models[1].key, "key2");
      expect(models[1].value, "value2");
      expect(models[2].key, "key3");
      expect(models[2].value, "value3");
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<ConfigurationResponseModelDto> models =
          ConfigurationResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("toJsonListString converts list to JSON string", () {
      // Arrange
      final List<ConfigurationResponseModelDto> models =
          <ConfigurationResponseModelDto>[
        ConfigurationResponseModelDto(
          key: "key1",
          value: "value1",
        ),
        ConfigurationResponseModelDto(
          key: "key2",
          value: "value2",
        ),
      ];

      // Act
      final String jsonString =
          ConfigurationResponseModelDto.toJsonListString(models);
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;

      // Assert
      expect(decoded, isNotNull);
      expect(decoded.length, 2);
      expect((decoded[0] as Map<String, dynamic>)["key"], "key1");
      expect((decoded[0] as Map<String, dynamic>)["value"], "value1");
      expect((decoded[1] as Map<String, dynamic>)["key"], "key2");
      expect((decoded[1] as Map<String, dynamic>)["value"], "value2");
    });

    test("fromJsonListString parses JSON string to list", () {
      // Arrange
      final String jsonString = jsonEncode(<Map<String, dynamic>>[
        <String, dynamic>{"key": "key1", "value": "value1"},
        <String, dynamic>{"key": "key2", "value": "value2"},
      ]);

      // Act
      final List<ConfigurationResponseModelDto> models =
          ConfigurationResponseModelDto.fromJsonListString(jsonString);

      // Assert
      expect(models.length, 2);
      expect(models[0].key, "key1");
      expect(models[0].value, "value1");
      expect(models[1].key, "key2");
      expect(models[1].value, "value2");
    });

    test("roundtrip toJsonListString and fromJsonListString preserves data",
        () {
      // Arrange
      final List<ConfigurationResponseModelDto> originalList =
          <ConfigurationResponseModelDto>[
        ConfigurationResponseModelDto(
          key: "key1",
          value: "value1",
        ),
        ConfigurationResponseModelDto(
          key: "key2",
          value: "value2",
        ),
      ];

      // Act
      final String jsonString =
          ConfigurationResponseModelDto.toJsonListString(originalList);
      final List<ConfigurationResponseModelDto> resultList =
          ConfigurationResponseModelDto.fromJsonListString(jsonString);

      // Assert
      expect(resultList.length, originalList.length);
      for (int i = 0; i < originalList.length; i++) {
        expect(resultList[i].key, originalList[i].key);
        expect(resultList[i].value, originalList[i].value);
      }
    });
  });
}
