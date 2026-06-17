import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for FaqResponse
/// Tests constructor, getters, copyWith method, and field assignment
void main() {
  group("FaqResponse Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final FaqResponse model = FaqResponse(
        question: "What is eSIM?",
        answer:
            "eSIM is a digital SIM card that can be downloaded onto a compatible device.",
      );

      // Assert
      expect(model.question, "What is eSIM?");
      expect(model.answer,
          "eSIM is a digital SIM card that can be downloaded onto a compatible device.");
    });

    test("constructor with minimal fields", () {
      // Act
      final FaqResponse model = FaqResponse(
        question: "How to activate?",
      );

      // Assert
      expect(model.question, "How to activate?");
      expect(model.answer, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final FaqResponse model = FaqResponse();

      // Assert
      expect(model.question, isNull);
      expect(model.answer, isNull);
    });

    test("question getter returns correct value", () {
      // Act
      final FaqResponse model = FaqResponse(
        question: "Is eSIM available worldwide?",
      );

      // Assert
      expect(model.question, "Is eSIM available worldwide?");
    });

    test("answer getter returns correct value", () {
      // Act
      final FaqResponse model = FaqResponse(
        answer: "Yes, eSIM is available in over 180 countries and regions.",
      );

      // Assert
      expect(model.answer,
          "Yes, eSIM is available in over 180 countries and regions.");
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final FaqResponse original = FaqResponse(
        question: "Old question?",
        answer: "Old answer.",
      );

      // Act
      final FaqResponse updated = original.copyWith(
        question: "New question?",
      );

      // Assert
      expect(updated.question, "New question?");
      expect(updated.answer, "Old answer.");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final FaqResponse original = FaqResponse(
        question: "Test question?",
        answer: "Test answer.",
      );

      // Act
      final FaqResponse copied = original.copyWith();

      // Assert
      expect(copied.question, original.question);
      expect(copied.answer, original.answer);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final FaqResponse original = FaqResponse(
        question: "Question?",
      );

      // Act
      final FaqResponse updated = original.copyWith(
        answer: "New answer.",
      );

      // Assert
      expect(updated.question, "Question?");
      expect(updated.answer, "New answer.");
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final FaqResponse original = FaqResponse(
        question: "Original question?",
      );

      // Act
      final FaqResponse updated = original.copyWith(
        question: "Updated question?",
      );

      // Assert
      expect(original.question, "Original question?");
      expect(updated.question, "Updated question?");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final FaqResponse original = FaqResponse(
        question: "Old question?",
        answer: "Old answer.",
      );

      // Act
      final FaqResponse updated = original.copyWith(
        question: "New question?",
        answer: "New answer.",
      );

      // Assert
      expect(updated.question, "New question?");
      expect(updated.answer, "New answer.");
    });

    test("handles empty string values", () {
      // Act
      final FaqResponse model = FaqResponse(
        question: "",
        answer: "",
      );

      // Assert
      expect(model.question, "");
      expect(model.answer, "");
    });

    test("handles special characters in string fields", () {
      // Act
      final FaqResponse model = FaqResponse(
        question: "What's the difference between eSIM & SIM?",
        answer:
            "O'Brien's guide: eSIM is digital, SIM is physical - it's that simple!",
      );

      // Assert
      expect(model.question, "What's the difference between eSIM & SIM?");
      expect(model.answer,
          "O'Brien's guide: eSIM is digital, SIM is physical - it's that simple!");
    });

    test("handles long content strings", () {
      // Act
      final String longAnswer =
          "This is a very long FAQ answer that contains detailed information about eSIM technology, " *
              3;
      final FaqResponse model = FaqResponse(
        answer: longAnswer,
      );

      // Assert
      expect(model.answer, longAnswer);
      expect(model.answer, isNotEmpty);
    });

    test("multiple instances are independent", () {
      // Act
      final FaqResponse model1 = FaqResponse(
        question: "Question 1?",
        answer: "Answer 1.",
      );
      final FaqResponse model2 = FaqResponse(
        question: "Question 2?",
        answer: "Answer 2.",
      );

      // Assert
      expect(model1.question, "Question 1?");
      expect(model1.answer, "Answer 1.");
      expect(model2.question, "Question 2?");
      expect(model2.answer, "Answer 2.");
    });

    test("common FAQ questions are preserved", () {
      // Act
      final FaqResponse whatIsModel = FaqResponse(
        question: "What is eSIM?",
      );
      final FaqResponse howModel = FaqResponse(
        question: "How do I activate eSIM?",
      );
      final FaqResponse costModel = FaqResponse(
        question: "Does it cost extra?",
      );

      // Assert
      expect(whatIsModel.question, "What is eSIM?");
      expect(howModel.question, "How do I activate eSIM?");
      expect(costModel.question, "Does it cost extra?");
    });

    test("question with punctuation marks", () {
      // Act
      final FaqResponse questionMarkModel = FaqResponse(
        question: "What is eSIM?",
      );
      final FaqResponse exclamationModel = FaqResponse(
        question: "eSIM is available!",
      );
      final FaqResponse multiPunctModel = FaqResponse(
        question: "Is it available? Yes!!!",
      );

      // Assert
      expect(questionMarkModel.question, "What is eSIM?");
      expect(exclamationModel.question, "eSIM is available!");
      expect(multiPunctModel.question, "Is it available? Yes!!!");
    });

    test("copyWith with field preservation", () {
      // Arrange
      final FaqResponse original = FaqResponse(
        question: "Original question?",
        answer: "Original answer.",
      );

      // Act
      final FaqResponse updated = original.copyWith(
        answer: "Updated answer.",
      );

      // Assert
      expect(updated.question, "Original question?");
      expect(updated.answer, "Updated answer.");
      expect(updated.question, original.question);
    });

    test("unicode characters in string fields", () {
      // Act
      final FaqResponse model = FaqResponse(
        question: "What is eSIM? 🤔",
        answer: "It's a digital SIM card 📱 that works worldwide 🌍",
      );

      // Assert
      expect(model.question, "What is eSIM? 🤔");
      expect(
          model.answer, "It's a digital SIM card 📱 that works worldwide 🌍");
    });

    test("answer with line breaks and formatting", () {
      // Act
      final String formattedAnswer = """
eSIM stands for Embedded SIM. Here are the key benefits:
1. No physical card needed
2. Works worldwide
3. Easy to switch plans
      """;
      final FaqResponse model = FaqResponse(
        answer: formattedAnswer,
      );

      // Assert
      expect(model.answer, formattedAnswer);
      expect(model.answer?.contains("1. No physical card needed"), true);
    });

    test("copyWith preserves all unchanged fields", () {
      // Arrange
      final FaqResponse original = FaqResponse(
        question: "Question?",
        answer: "Answer.",
      );

      // Act
      final FaqResponse updated = original.copyWith(
        question: "New question?",
      );

      // Assert
      expect(updated.question, "New question?");
      expect(updated.answer, "Answer.");
      expect(updated.answer, original.answer);
    });
  });
}
