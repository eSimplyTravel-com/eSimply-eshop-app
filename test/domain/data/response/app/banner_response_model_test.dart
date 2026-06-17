import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BannerResponseModel
/// Tests constructor, getters, and field assignment
void main() {
  group("BannerResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        title: "Special Offer",
        description: "Get 50% off on all bundles",
        image: "assets/images/banner.png",
        action: "open_promo",
      );

      // Assert
      expect(model.title, "Special Offer");
      expect(model.description, "Get 50% off on all bundles");
      expect(model.image, "assets/images/banner.png");
      expect(model.action, "open_promo");
    });

    test("constructor with minimal fields", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        title: "Banner Title",
      );

      // Assert
      expect(model.title, "Banner Title");
      expect(model.description, isNull);
      expect(model.image, isNull);
      expect(model.action, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final BannerResponseModel model = BannerResponseModel();

      // Assert
      expect(model.title, isNull);
      expect(model.description, isNull);
      expect(model.image, isNull);
      expect(model.action, isNull);
    });

    test("title getter returns correct value", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        title: "Welcome Banner",
      );

      // Assert
      expect(model.title, "Welcome Banner");
    });

    test("description getter returns correct value", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        description: "This is a detailed description",
      );

      // Assert
      expect(model.description, "This is a detailed description");
    });

    test("image getter returns correct value", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        image: "assets/images/banner.png",
      );

      // Assert
      expect(model.image, "assets/images/banner.png");
    });

    test("action getter returns correct value", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        action: "navigate_to_shop",
      );

      // Assert
      expect(model.action, "navigate_to_shop");
    });

    test("handles empty string values", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        title: "",
        description: "",
        image: "",
        action: "",
      );

      // Assert
      expect(model.title, "");
      expect(model.description, "");
      expect(model.image, "");
      expect(model.action, "");
    });

    test("handles special characters in string fields", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        title: "Summer's Special Offer",
        description: "Get 50% off - O'Brien's exclusive deal",
        image: "assets/images/summer_2024_promo_v2.5.png",
        action: "open/promo?id=123&type=banner",
      );

      // Assert
      expect(model.title, "Summer's Special Offer");
      expect(model.description, "Get 50% off - O'Brien's exclusive deal");
      expect(model.image, "assets/images/summer_2024_promo_v2.5.png");
      expect(model.action, "open/promo?id=123&type=banner");
    });

    test("handles long content strings", () {
      // Act
      final String longDescription =
          "This is a very long banner description that contains detailed information about the promotion. " *
              3;
      final BannerResponseModel model = BannerResponseModel(
        description: longDescription,
      );

      // Assert
      expect(model.description, longDescription);
      expect(model.description, isNotEmpty);
    });

    test("multiple instances are independent", () {
      // Act
      final BannerResponseModel model1 = BannerResponseModel(
        title: "Banner 1",
        action: "action_1",
      );
      final BannerResponseModel model2 = BannerResponseModel(
        title: "Banner 2",
        action: "action_2",
      );

      // Assert
      expect(model1.title, "Banner 1");
      expect(model1.action, "action_1");
      expect(model2.title, "Banner 2");
      expect(model2.action, "action_2");
    });

    test("action values are preserved", () {
      // Act
      final BannerResponseModel openPromoModel = BannerResponseModel(
        action: "open_promo",
      );
      final BannerResponseModel navigateModel = BannerResponseModel(
        action: "navigate_to_shop",
      );
      final BannerResponseModel externalLinkModel = BannerResponseModel(
        action: "external_link",
      );

      // Assert
      expect(openPromoModel.action, "open_promo");
      expect(navigateModel.action, "navigate_to_shop");
      expect(externalLinkModel.action, "external_link");
    });

    test("image path formats are preserved", () {
      // Act
      final BannerResponseModel localPathModel = BannerResponseModel(
        image: "assets/images/banner.png",
      );
      final BannerResponseModel remoteUrlModel = BannerResponseModel(
        image: "https://example.com/images/banner.png",
      );
      final BannerResponseModel svgModel = BannerResponseModel(
        image: "assets/vectors/banner.svg",
      );

      // Assert
      expect(localPathModel.image, "assets/images/banner.png");
      expect(remoteUrlModel.image, "https://example.com/images/banner.png");
      expect(svgModel.image, "assets/vectors/banner.svg");
    });

    test("unicode characters in string fields", () {
      // Act
      final BannerResponseModel model = BannerResponseModel(
        title: "Summer Sale 2026 ☀️",
        description: "Get ready for the 🌊 season",
        action: "shop_now_➜",
      );

      // Assert
      expect(model.title, "Summer Sale 2026 ☀️");
      expect(model.description, "Get ready for the 🌊 season");
      expect(model.action, "shop_now_➜");
    });
  });
}
