import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for RegionsResponseModel
void main() {
  group("RegionsResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        icon: "https://example.com/icon.png",
        zoneName: "Europe",
        regionCode: "EU-001",
        regionName: "EUROPE",
      );

      // Assert
      expect(model.icon, "https://example.com/icon.png");
      expect(model.zoneName, "Europe");
      expect(model.regionCode, "EU-001");
      expect(model.regionName, "EUROPE");
    });

    test("constructor with all null values", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel();

      // Assert
      expect(model.icon, isNull);
      expect(model.zoneName, isNull);
      expect(model.regionCode, isNull);
      expect(model.regionName, isNull);
    });

    test("constructor with partial null values", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        icon: "https://example.com/icon.png",
        zoneName: null,
        regionCode: "EU-001",
      );

      // Assert
      expect(model.icon, "https://example.com/icon.png");
      expect(model.zoneName, isNull);
      expect(model.regionCode, "EU-001");
      expect(model.regionName, isNull);
    });

    test("getMockRegions returns list of regions", () {
      // Act
      final List<RegionsResponseModel> mockRegions = RegionsResponseModel.getMockRegions();

      // Assert
      expect(mockRegions, isNotEmpty);
      expect(mockRegions.length, greaterThan(0));
    });

    test("getMockRegions contains GLOBAL region", () {
      // Act
      final List<RegionsResponseModel> mockRegions = RegionsResponseModel.getMockRegions();
      final RegionsResponseModel? globalRegion = mockRegions.firstWhereOrNull(
        (RegionsResponseModel region) => region.regionName == "GLOBAL",
      );

      // Assert
      expect(globalRegion, isNotNull);
      expect(globalRegion?.regionName, "GLOBAL");
      expect(globalRegion?.zoneName, "GLOBAL");
    });

    test("getMockRegions contains EUROPE region", () {
      // Act
      final List<RegionsResponseModel> mockRegions = RegionsResponseModel.getMockRegions();
      final RegionsResponseModel? europeRegion = mockRegions.firstWhereOrNull(
        (RegionsResponseModel region) => region.regionName == "EUROPE",
      );

      // Assert
      expect(europeRegion, isNotNull);
      expect(europeRegion?.regionName, "EUROPE");
      expect(europeRegion?.zoneName, "Europe");
    });

    test("getMockRegions all items have icon", () {
      // Act
      final List<RegionsResponseModel> mockRegions = RegionsResponseModel.getMockRegions();

      // Assert
      for (final RegionsResponseModel region in mockRegions) {
        expect(region.icon, isNotNull);
        expect(region.icon, isNotEmpty);
      }
    });

    test("getMockRegions all items have regionCode", () {
      // Act
      final List<RegionsResponseModel> mockRegions = RegionsResponseModel.getMockRegions();

      // Assert
      for (final RegionsResponseModel region in mockRegions) {
        expect(region.regionCode, isNotNull);
        expect(region.regionCode, isNotEmpty);
      }
    });

    test("getMockRegions all items have regionName", () {
      // Act
      final List<RegionsResponseModel> mockRegions = RegionsResponseModel.getMockRegions();

      // Assert
      for (final RegionsResponseModel region in mockRegions) {
        expect(region.regionName, isNotNull);
        expect(region.regionName, isNotEmpty);
      }
    });

    test("getMockRegions all items have zoneName", () {
      // Act
      final List<RegionsResponseModel> mockRegions = RegionsResponseModel.getMockRegions();

      // Assert
      for (final RegionsResponseModel region in mockRegions) {
        expect(region.zoneName, isNotNull);
        expect(region.zoneName, isNotEmpty);
      }
    });

    test("empty string for icon", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        icon: "",
      );

      // Assert
      expect(model.icon, "");
    });

    test("empty string for zoneName", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        zoneName: "",
      );

      // Assert
      expect(model.zoneName, "");
    });

    test("empty string for regionCode", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        regionCode: "",
      );

      // Assert
      expect(model.regionCode, "");
    });

    test("empty string for regionName", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        regionName: "",
      );

      // Assert
      expect(model.regionName, "");
    });

    test("UUID format for regionCode", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        regionCode: "742bb566-517f-e311-93f4-80ee7353f479",
      );

      // Assert
      expect(model.regionCode, "742bb566-517f-e311-93f4-80ee7353f479");
    });

    test("URL format for icon", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel(
        icon: "https://placehold.co/400x400",
      );

      // Assert
      expect(model.icon, "https://placehold.co/400x400");
    });

    test("multiple instances are independent", () {
      // Act
      final RegionsResponseModel model1 = RegionsResponseModel(
        regionCode: "EU-001",
        regionName: "EUROPE",
      );
      final RegionsResponseModel model2 = RegionsResponseModel(
        regionCode: "AS-001",
        regionName: "ASIA",
      );

      // Assert
      expect(model1.regionCode, "EU-001");
      expect(model2.regionCode, "AS-001");
      expect(model1.regionName, "EUROPE");
      expect(model2.regionName, "ASIA");
    });

    test("response type is correct", () {
      // Act
      final RegionsResponseModel model = RegionsResponseModel();

      // Assert
      expect(model, isA<RegionsResponseModel>());
    });

    test("getMockRegions is consistent across calls", () {
      // Act
      final List<RegionsResponseModel> regions1 = RegionsResponseModel.getMockRegions();
      final List<RegionsResponseModel> regions2 = RegionsResponseModel.getMockRegions();

      // Assert
      expect(regions1.length, regions2.length);
      for (int i = 0; i < regions1.length; i++) {
        expect(regions1[i].regionName, regions2[i].regionName);
        expect(regions1[i].regionCode, regions2[i].regionCode);
      }
    });
  });
}

extension on List<RegionsResponseModel> {
  RegionsResponseModel? firstWhereOrNull(
    bool Function(RegionsResponseModel) test,
  ) {
    for (final RegionsResponseModel element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
