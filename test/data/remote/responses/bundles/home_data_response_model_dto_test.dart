import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model_dto.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("HomeDataResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "regions": <Map<String, dynamic>>[
          <String, dynamic>{
            "region_code": "EU",
            "region_name": "Europe",
          },
        ],
        "countries": <Map<String, dynamic>>[
          <String, dynamic>{
            "country": "France",
            "country_code": "FR",
          },
        ],
        "global_bundles": <Map<String, dynamic>>[
          <String, dynamic>{
            "bundle_code": "GLOBAL-001",
            "display_title": "Global Bundle",
          },
        ],
        "cruise_bundles": <Map<String, dynamic>>[
          <String, dynamic>{
            "bundle_code": "CRUISE-001",
            "display_title": "Cruise Bundle",
          },
        ],
        "version": "1.0.0",
      };

      // Act
      final HomeDataResponseModelDto model = HomeDataResponseModelDto.fromJson(json);

      // Assert
      expect(model.regions, isNotNull);
      expect(model.countries, isNotNull);
      expect(model.globalBundles, isNotNull);
      expect(model.cruiseBundles, isNotNull);
    });

    test("fromJson handles null regions", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "countries": <Map<String, dynamic>>[],
      };

      // Act
      final HomeDataResponseModelDto model = HomeDataResponseModelDto.fromJson(json);

      // Assert
      expect(model.regions, isNull);
      expect(model.countries, isNotNull);
    });

    test("fromAPIJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "regions": <Map<String, dynamic>>[
          <String, dynamic>{
            "region_code": "EU",
            "region_name": "Europe",
          },
        ],
        "countries": <Map<String, dynamic>>[
          <String, dynamic>{
            "country": "France",
            "country_code": "FR",
          },
        ],
        "global_bundles": <Map<String, dynamic>>[
          <String, dynamic>{
            "bundle_code": "GLOBAL-001",
            "display_title": "Global Bundle",
          },
        ],
        "cruise_bundles": <Map<String, dynamic>>[
          <String, dynamic>{
            "bundle_code": "CRUISE-001",
            "display_title": "Cruise Bundle",
          },
        ],
      };

      // Act
      final HomeDataResponseModelDto model =
          HomeDataResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.regions, isNotNull);
      expect(model.countries, isNotNull);
      expect(model.globalBundles, isNotNull);
      expect(model.cruiseBundles, isNotNull);
    });

    test("fromAPIJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final HomeDataResponseModelDto model =
          HomeDataResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.regions, isNull);
      expect(model.countries, isNull);
      expect(model.globalBundles, isNull);
      expect(model.cruiseBundles, isNull);
    });

    test("constructor assigns values correctly", () {
      // Arrange
      final List<RegionsResponseModelDto> regions = <RegionsResponseModelDto>[
        RegionsResponseModelDto(regionCode: "EU", regionName: "Europe"),
      ];
      final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
        CountryResponseModelDto(country: "France", countryCode: "FR"),
      ];
      final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
        BundleResponseModelDto(bundleCode: "GLOBAL-001"),
      ];
      final List<BundleResponseModelDto> cruiseBundles = <BundleResponseModelDto>[
        BundleResponseModelDto(bundleCode: "CRUISE-001"),
      ];

      // Act
      final HomeDataResponseModelDto model = HomeDataResponseModelDto(
        regions: regions,
        countries: countries,
        globalBundles: globalBundles,
        cruiseBundles: cruiseBundles,
        version: "1.0.0",
      );

      // Assert
      expect(model.regions, regions);
      expect(model.countries, countries);
      expect(model.globalBundles, globalBundles);
      expect(model.cruiseBundles, cruiseBundles);
      expect(model.version, "1.0.0");
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final List<RegionsResponseModelDto> regions = <RegionsResponseModelDto>[
        RegionsResponseModelDto(regionCode: "EU", regionName: "Europe"),
      ];
      final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
        CountryResponseModelDto(country: "France", countryCode: "FR"),
      ];
      final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
        BundleResponseModelDto(bundleCode: "GLOBAL-001"),
      ];
      final List<BundleResponseModelDto> cruiseBundles = <BundleResponseModelDto>[
        BundleResponseModelDto(bundleCode: "CRUISE-001"),
      ];

      final HomeDataResponseModelDto model = HomeDataResponseModelDto(
        regions: regions,
        countries: countries,
        globalBundles: globalBundles,
        cruiseBundles: cruiseBundles,
        version: "1.0.0",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["version"], "1.0.0");
      expect(json["regions"], isNotNull);
      expect(json["countries"], isNotNull);
      expect(json["global_bundles"], isNotNull);
      expect(json["cruise_bundles"], isNotNull);
    });

    test("toJson handles null fields", () {
      // Arrange
      final HomeDataResponseModelDto model = HomeDataResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["version"], isNull);
      expect(json["regions"], isNull);
      expect(json["countries"], isNull);
      expect(json["global_bundles"], isNull);
      expect(json["cruise_bundles"], isNull);
    });
  });
}
