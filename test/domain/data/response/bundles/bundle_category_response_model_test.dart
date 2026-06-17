import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleCategoryResponseModel
void main() {
  group("BundleCategoryResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: "CRUISE",
        code: "CRUISE001",
        title: "Cruise Bundle",
      );

      // Assert
      expect(model.type, "CRUISE");
      expect(model.code, "CRUISE001");
      expect(model.title, "Cruise Bundle");
    });

    test("constructor with all null values", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel();

      // Assert
      expect(model.type, isNull);
      expect(model.code, isNull);
      expect(model.title, isNull);
    });

    test("isCruise returns true when type is CRUISE", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: "CRUISE",
      );

      // Assert
      expect(model.isCruise, true);
    });

    test("isCruise returns false when type is not CRUISE", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: "GLOBAL",
      );

      // Assert
      expect(model.isCruise, false);
    });

    test("isCruise returns false when type is null", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: null,
      );

      // Assert
      expect(model.isCruise, false);
    });

    test("isCruise is case-sensitive", () {
      // Act
      final BundleCategoryResponseModel model1 = BundleCategoryResponseModel(
        type: "cruise",
      );
      final BundleCategoryResponseModel model2 = BundleCategoryResponseModel(
        type: "Cruise",
      );

      // Assert
      expect(model1.isCruise, false);
      expect(model2.isCruise, false);
    });

    test("type GLOBAL does not make isCruise true", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: "GLOBAL",
      );

      // Assert
      expect(model.isCruise, false);
    });

    test("type REGIONAL does not make isCruise true", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: "REGIONAL",
      );

      // Assert
      expect(model.isCruise, false);
    });

    test("empty string type does not make isCruise true", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: "",
      );

      // Assert
      expect(model.isCruise, false);
    });

    test("constructor with partial null values", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        type: "CRUISE",
        code: null,
        title: "Cruise",
      );

      // Assert
      expect(model.type, "CRUISE");
      expect(model.code, isNull);
      expect(model.title, "Cruise");
    });

    test("empty string for code", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        code: "",
      );

      // Assert
      expect(model.code, "");
    });

    test("empty string for title", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        title: "",
      );

      // Assert
      expect(model.title, "");
    });

    test("special characters in code", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        code: "CRUISE-2024-001",
      );

      // Assert
      expect(model.code, "CRUISE-2024-001");
    });

    test("long title string", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel(
        title: "Premium Cruise Bundle with All Inclusive Benefits",
      );

      // Assert
      expect(model.title, "Premium Cruise Bundle with All Inclusive Benefits");
    });

    test("multiple instances are independent", () {
      // Act
      final BundleCategoryResponseModel model1 = BundleCategoryResponseModel(
        type: "CRUISE",
        code: "C1",
      );
      final BundleCategoryResponseModel model2 = BundleCategoryResponseModel(
        type: "GLOBAL",
        code: "G1",
      );

      // Assert
      expect(model1.type, "CRUISE");
      expect(model2.type, "GLOBAL");
      expect(model1.isCruise, true);
      expect(model2.isCruise, false);
    });

    test("response type is correct", () {
      // Act
      final BundleCategoryResponseModel model = BundleCategoryResponseModel();

      // Assert
      expect(model, isA<BundleCategoryResponseModel>());
    });

    test("isCruise getter is computed correctly for various types", () {
      // Arrange
      final List<String> types = <String>[
        "CRUISE",
        "GLOBAL",
        "REGIONAL",
        "LOCAL",
        "EUROPE",
      ];
      final List<bool> expectedIsCruise = <bool>[true, false, false, false, false];

      // Act & Assert
      for (int i = 0; i < types.length; i++) {
        final BundleCategoryResponseModel model = BundleCategoryResponseModel(
          type: types[i],
        );
        expect(model.isCruise, expectedIsCruise[i],
            reason: "Type ${types[i]} should have isCruise=${expectedIsCruise[i]}");
      }
    });
  });
}
