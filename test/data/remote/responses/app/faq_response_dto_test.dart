import "dart:convert";

import "package:esim_open_source/data/remote/responses/app/faq_response_dto.dart";
import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("FaqResponseDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "question": "How does eSIM work?",
        "answer": "An eSIM is a digital version of a physical SIM card.",
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, "How does eSIM work?");
      expect(model.answer, "An eSIM is a digital version of a physical SIM card.");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, isNull);
      expect(model.answer, isNull);
    });

    test("fromJson handles explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "question": null,
        "answer": null,
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, isNull);
      expect(model.answer, isNull);
    });

    test("fromJson handles null question", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "answer": "Some answer",
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, isNull);
      expect(model.answer, "Some answer");
    });

    test("fromJson handles null answer", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "question": "Some question",
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, "Some question");
      expect(model.answer, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final FaqResponseDto model = FaqResponseDto(
        question: "Test Question",
        answer: "Test Answer",
      );

      // Assert
      expect(model.question, "Test Question");
      expect(model.answer, "Test Answer");
    });

    test("constructor with minimal fields", () {
      // Act
      final FaqResponseDto model = FaqResponseDto(
        question: "Test Question",
      );

      // Assert
      expect(model.question, "Test Question");
      expect(model.answer, isNull);
    });

    test("constructor with all fields nullable", () {
      // Act
      final FaqResponseDto model = FaqResponseDto();

      // Assert
      expect(model.question, isNull);
      expect(model.answer, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final FaqResponseDto model = FaqResponseDto(
        question: "Test Question",
        answer: "Test Answer",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["question"], "Test Question");
      expect(json["answer"], "Test Answer");
    });

    test("toJson handles null fields", () {
      // Arrange
      final FaqResponseDto model = FaqResponseDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["question"], isNull);
      expect(json["answer"], isNull);
    });

    test("toJson with partial fields", () {
      // Arrange
      final FaqResponseDto model = FaqResponseDto(
        question: "Test Question",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["question"], "Test Question");
      expect(json["answer"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final FaqResponseDto original = FaqResponseDto(
        question: "Original Question",
        answer: "Original Answer",
      );

      // Act
      final FaqResponseDto updated = original.copyWith(
        question: "Updated Question",
      );

      // Assert
      expect(updated.question, "Updated Question");
      expect(updated.answer, "Original Answer");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final FaqResponseDto original = FaqResponseDto(
        question: "Test Question",
        answer: "Test Answer",
      );

      // Act
      final FaqResponseDto copied = original.copyWith();

      // Assert
      expect(copied.question, original.question);
      expect(copied.answer, original.answer);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final FaqResponseDto original = FaqResponseDto(
        question: "Test Question",
      );

      // Act
      final FaqResponseDto updated = original.copyWith(
        answer: "New Answer",
      );

      // Assert
      expect(updated.question, "Test Question");
      expect(updated.answer, "New Answer");
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final FaqResponseDto original = FaqResponseDto(
        question: "Original Question",
      );

      // Act
      final FaqResponseDto updated = original.copyWith(
        question: "Updated Question",
      );

      // Assert
      expect(original.question, "Original Question");
      expect(updated.question, "Updated Question");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final FaqResponseDto original = FaqResponseDto(
        question: "Original Question",
        answer: "Original Answer",
      );

      // Act
      final FaqResponseDto updated = original.copyWith(
        question: "Updated Question",
        answer: "Updated Answer",
      );

      // Assert
      expect(updated.question, "Updated Question");
      expect(updated.answer, "Updated Answer");
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{
          "question": "Question 1",
          "answer": "Answer 1",
        },
        <String, dynamic>{
          "question": "Question 2",
          "answer": "Answer 2",
        },
      ];

      // Act
      final List<FaqResponseDto> models =
          FaqResponseDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].question, "Question 1");
      expect(models[0].answer, "Answer 1");
      expect(models[1].question, "Question 2");
      expect(models[1].answer, "Answer 2");
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<FaqResponseDto> models =
          FaqResponseDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "question": "Test Question",
        "answer": "Test Answer",
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["question"], originalJson["question"]);
      expect(resultJson["answer"], originalJson["answer"]);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "question": "",
        "answer": "",
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, "");
      expect(model.answer, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "question": "José's Question?",
        "answer": "O'Brien's Answer with \"quotes\" and \$pecial chars",
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, "José's Question?");
      expect(model.answer, "O'Brien's Answer with \"quotes\" and \$pecial chars");
    });

    test("handles long content strings", () {
      // Arrange
      final String longQuestion = "Question? " * 100;
      final String longAnswer = "Answer. " * 100;
      final Map<String, dynamic> json = <String, dynamic>{
        "question": longQuestion,
        "answer": longAnswer,
      };

      // Act
      final FaqResponseDto model = FaqResponseDto.fromJson(json: json);

      // Assert
      expect(model.question, longQuestion);
      expect(model.answer, longAnswer);
    });

    test("multiple instances are independent", () {
      // Act
      final FaqResponseDto model1 = FaqResponseDto(
        question: "Question 1",
        answer: "Answer 1",
      );
      final FaqResponseDto model2 = FaqResponseDto(
        question: "Question 2",
        answer: "Answer 2",
      );

      // Assert
      expect(model1.question, "Question 1");
      expect(model2.question, "Question 2");
      expect(model1.answer, "Answer 1");
      expect(model2.answer, "Answer 2");
    });

    test("faqResponseFromJson helper parses JSON string", () {
      // Arrange
      final String jsonString = jsonEncode(<String, dynamic>{
        "question": "Test Question",
        "answer": "Test Answer",
      });

      // Act
      final FaqResponseDto model = faqResponseFromJson(jsonString);

      // Assert
      expect(model.question, "Test Question");
      expect(model.answer, "Test Answer");
    });

    test("faqResponseToJson helper converts to JSON string", () {
      // Arrange
      final FaqResponseDto model = FaqResponseDto(
        question: "Test Question",
        answer: "Test Answer",
      );

      // Act
      final String jsonString = faqResponseToJson(model);
      final Map<String, dynamic> decoded =
          jsonDecode(jsonString) as Map<String, dynamic>;

      // Assert
      expect(decoded["question"], "Test Question");
      expect(decoded["answer"], "Test Answer");
    });

    test("toDomain converts DTO to domain model with all fields", () {
      // Arrange
      final FaqResponseDto dto = FaqResponseDto(
        question: "Test Question",
        answer: "Test Answer",
      );

      // Act
      final FaqResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.question, "Test Question");
      expect(domainModel.answer, "Test Answer");
    });

    test("toDomain converts DTO to domain model with null fields", () {
      // Arrange
      final FaqResponseDto dto = FaqResponseDto();

      // Act
      final FaqResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.question, isNull);
      expect(domainModel.answer, isNull);
    });

    test("toDomain converts DTO to domain model with partial fields", () {
      // Arrange
      final FaqResponseDto dto = FaqResponseDto(
        question: "Only Question",
      );

      // Act
      final FaqResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.question, "Only Question");
      expect(domainModel.answer, isNull);
    });

    test("roundtrip toDomain preserves FAQ data", () {
      // Arrange
      final FaqResponseDto originalDto = FaqResponseDto(
        question: "Original Question",
        answer: "Original Answer",
      );

      // Act
      final FaqResponse domainModel = originalDto.toDomain();

      // Assert
      expect(domainModel.question, "Original Question");
      expect(domainModel.answer, "Original Answer");
    });

    test("toDomain handles special characters in FAQ content", () {
      // Arrange
      final FaqResponseDto dto = FaqResponseDto(
        question: "What is an eSIM?",
        answer: "An eSIM (embedded SIM) is a digital version of a physical SIM card.",
      );

      // Act
      final FaqResponse domainModel = dto.toDomain();

      // Assert
      expect(domainModel.question, "What is an eSIM?");
      expect(domainModel.answer,
          "An eSIM (embedded SIM) is a digital version of a physical SIM card.");
    });
  });
}
