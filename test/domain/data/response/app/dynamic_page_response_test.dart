import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for DynamicPageResponse
/// Tests constructor, getters, copyWith method, and field assignment
void main() {
  group("DynamicPageResponse Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageTitle: "About Us",
        pageContent: "Welcome to our eSIM platform!",
        pageIntro: "Empowering Connectivity with eSIM Technology",
      );

      // Assert
      expect(model.pageTitle, "About Us");
      expect(model.pageContent, "Welcome to our eSIM platform!");
      expect(model.pageIntro, "Empowering Connectivity with eSIM Technology");
    });

    test("constructor with minimal fields", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageTitle: "Home",
      );

      // Assert
      expect(model.pageTitle, "Home");
      expect(model.pageContent, isNull);
      expect(model.pageIntro, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse();

      // Assert
      expect(model.pageTitle, isNull);
      expect(model.pageContent, isNull);
      expect(model.pageIntro, isNull);
    });

    test("pageTitle getter returns correct value", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageTitle: "Privacy Policy",
      );

      // Assert
      expect(model.pageTitle, "Privacy Policy");
    });

    test("pageContent getter returns correct value", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageContent: "We value your privacy and data security.",
      );

      // Assert
      expect(model.pageContent, "We value your privacy and data security.");
    });

    test("pageIntro getter returns correct value", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageIntro: "Introduction to our services",
      );

      // Assert
      expect(model.pageIntro, "Introduction to our services");
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final DynamicPageResponse original = DynamicPageResponse(
        pageTitle: "Old Title",
        pageContent: "Old content",
        pageIntro: "Old intro",
      );

      // Act
      final DynamicPageResponse updated = original.copyWith(
        pageTitle: "New Title",
      );

      // Assert
      expect(updated.pageTitle, "New Title");
      expect(updated.pageContent, "Old content");
      expect(updated.pageIntro, "Old intro");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final DynamicPageResponse original = DynamicPageResponse(
        pageTitle: "Test Title",
        pageContent: "Test content",
        pageIntro: "Test intro",
      );

      // Act
      final DynamicPageResponse copied = original.copyWith();

      // Assert
      expect(copied.pageTitle, original.pageTitle);
      expect(copied.pageContent, original.pageContent);
      expect(copied.pageIntro, original.pageIntro);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final DynamicPageResponse original = DynamicPageResponse(
        pageTitle: "Title",
      );

      // Act
      final DynamicPageResponse updated = original.copyWith(
        pageContent: "New content",
      );

      // Assert
      expect(updated.pageTitle, "Title");
      expect(updated.pageContent, "New content");
      expect(updated.pageIntro, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final DynamicPageResponse original = DynamicPageResponse(
        pageTitle: "Original Title",
      );

      // Act
      final DynamicPageResponse updated = original.copyWith(
        pageTitle: "Updated Title",
      );

      // Assert
      expect(original.pageTitle, "Original Title");
      expect(updated.pageTitle, "Updated Title");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final DynamicPageResponse original = DynamicPageResponse(
        pageTitle: "Old Title",
        pageContent: "Old content",
        pageIntro: "Old intro",
      );

      // Act
      final DynamicPageResponse updated = original.copyWith(
        pageTitle: "New Title",
        pageContent: "New content",
        pageIntro: "New intro",
      );

      // Assert
      expect(updated.pageTitle, "New Title");
      expect(updated.pageContent, "New content");
      expect(updated.pageIntro, "New intro");
    });

    test("handles empty string values", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageTitle: "",
        pageContent: "",
        pageIntro: "",
      );

      // Assert
      expect(model.pageTitle, "");
      expect(model.pageContent, "");
      expect(model.pageIntro, "");
    });

    test("handles special characters in string fields", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageTitle: "José García's Profile",
        pageContent: "It's working! O'Brien's guide to eSIM",
        pageIntro: 'Error: "Network connection" - retrying...',
      );

      // Assert
      expect(model.pageTitle, "José García's Profile");
      expect(model.pageContent, "It's working! O'Brien's guide to eSIM");
      expect(model.pageIntro, 'Error: "Network connection" - retrying...');
    });

    test("handles long content strings", () {
      // Act
      final String longContent =
          "This is a very long page content that contains detailed information spanning multiple paragraphs. " *
              3;
      final DynamicPageResponse model = DynamicPageResponse(
        pageContent: longContent,
      );

      // Assert
      expect(model.pageContent, longContent);
      expect(model.pageContent, isNotEmpty);
    });

    test("multiple instances are independent", () {
      // Act
      final DynamicPageResponse model1 = DynamicPageResponse(
        pageTitle: "Page 1",
        pageContent: "Content 1",
      );
      final DynamicPageResponse model2 = DynamicPageResponse(
        pageTitle: "Page 2",
        pageContent: "Content 2",
      );

      // Assert
      expect(model1.pageTitle, "Page 1");
      expect(model1.pageContent, "Content 1");
      expect(model2.pageTitle, "Page 2");
      expect(model2.pageContent, "Content 2");
    });

    test("common page titles are preserved", () {
      // Act
      final DynamicPageResponse aboutModel = DynamicPageResponse(
        pageTitle: "About Us",
      );
      final DynamicPageResponse privacyModel = DynamicPageResponse(
        pageTitle: "Privacy Policy",
      );
      final DynamicPageResponse termsModel = DynamicPageResponse(
        pageTitle: "Terms of Service",
      );

      // Assert
      expect(aboutModel.pageTitle, "About Us");
      expect(privacyModel.pageTitle, "Privacy Policy");
      expect(termsModel.pageTitle, "Terms of Service");
    });

    test("copyWith with nested field updates", () {
      // Arrange
      final DynamicPageResponse original = DynamicPageResponse(
        pageTitle: "Original",
        pageContent: "Original content",
        pageIntro: "Original intro",
      );

      // Act
      final DynamicPageResponse updated = original.copyWith(
        pageContent: "Updated content",
        pageIntro: "Updated intro",
      );

      // Assert
      expect(updated.pageTitle, "Original");
      expect(updated.pageContent, "Updated content");
      expect(updated.pageIntro, "Updated intro");
    });

    test("unicode characters in string fields", () {
      // Act
      final DynamicPageResponse model = DynamicPageResponse(
        pageTitle: "Welcome 👋 to eSIM",
        pageContent: "Get connected worldwide 🌍",
        pageIntro: "Empowering 💪 connectivity",
      );

      // Assert
      expect(model.pageTitle, "Welcome 👋 to eSIM");
      expect(model.pageContent, "Get connected worldwide 🌍");
      expect(model.pageIntro, "Empowering 💪 connectivity");
    });

    test("copyWith preserves all unchanged fields", () {
      // Arrange
      final DynamicPageResponse original = DynamicPageResponse(
        pageTitle: "Title",
        pageContent: "Content",
        pageIntro: "Intro",
      );

      // Act
      final DynamicPageResponse updated = original.copyWith(
        pageTitle: "New Title",
      );

      // Assert
      expect(updated.pageTitle, "New Title");
      expect(updated.pageContent, "Content");
      expect(updated.pageIntro, "Intro");
      expect(updated.pageContent, original.pageContent);
      expect(updated.pageIntro, original.pageIntro);
    });
  });
}
