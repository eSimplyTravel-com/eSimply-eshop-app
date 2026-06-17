import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleResponseModel
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("BundleResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "display_title": "Europe 5GB",
        "display_subtitle": "5GB Data Plan",
        "bundle_code": "EUR-5GB-001",
        "bundle_category": <String, dynamic>{
          "type": "REGIONAL",
          "code": "reg-001",
          "title": "Regional",
        },
        "bundle_marketing_name": "Europe Premium",
        "bundle_name": "Europe 5GB Bundle",
        "count_countries": 25,
        "currency_code": "USD",
        "gprs_limit_display": "5 GB",
        "price": 49.99,
        "price_display": r"$49.99",
        "unlimited": false,
        "validity": 30,
        "icon": "https://example.com/icon.png",
        "countries": <Map<String, dynamic>>[
          <String, dynamic>{
            "country": "France",
            "country_code": "FR",
            "iso3_code": "FRA",
          },
        ],
      };

      // Act
      final BundleResponseModelDto model =
          BundleResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.displayTitle, "Europe 5GB");
      expect(model.displaySubtitle, "5GB Data Plan");
      expect(model.bundleCode, "EUR-5GB-001");
      expect(model.bundleCategory, isNotNull);
      expect(model.bundleCategory?.type, "REGIONAL");
      expect(model.bundleMarketingName, "Europe Premium");
      expect(model.bundleName, "Europe 5GB Bundle");
      expect(model.countCountries, 25);
      expect(model.currencyCode, "USD");
      expect(model.gprsLimitDisplay, "5 GB");
      expect(model.price, 49.99);
      expect(model.priceDisplay, r"$49.99");
      expect(model.unlimited, false);
      expect(model.validity, 30);
      expect(model.icon, "https://example.com/icon.png");
      expect(model.countries, isNotNull);
      expect(model.countries?.length, 1);
    });

    test("fromJson handles null bundle_category", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "display_title": "Test Bundle",
        "bundle_code": "TEST-001",
      };

      // Act
      final BundleResponseModelDto model =
          BundleResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.displayTitle, "Test Bundle");
      expect(model.bundleCategory, isNull);
    });

    test("fromJson handles null countries", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "display_title": "Global Bundle",
        "bundle_code": "GLOBAL-001",
      };

      // Act
      final BundleResponseModelDto model =
          BundleResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.displayTitle, "Global Bundle");
      expect(model.countries, isNull);
    });

    test("fromJson handles price as integer", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "bundle_code": "TEST",
        "price": 50,
      };

      // Act
      final BundleResponseModelDto model =
          BundleResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.price, 50.0);
    });

    test("fromJson handles price as double", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "bundle_code": "TEST",
        "price": 49.99,
      };

      // Act
      final BundleResponseModelDto model =
          BundleResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.price, 49.99);
    });

    test("constructor assigns values correctly", () {
      // Arrange
      final BundleCategoryResponseModelDto category =
          BundleCategoryResponseModelDto(
        type: "GLOBAL",
        code: "global-001",
        title: "Global",
      );
      final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
        CountryResponseModelDto(
          country: "USA",
          countryCode: "US",
        ),
      ];

      // Act
      final BundleResponseModelDto model = BundleResponseModelDto(
        displayTitle: "USA Bundle",
        bundleCode: "USA-001",
        bundleCategory: category,
        countries: countries,
        price: 29.99,
        unlimited: true,
      );

      // Assert
      expect(model.displayTitle, "USA Bundle");
      expect(model.bundleCode, "USA-001");
      expect(model.bundleCategory, category);
      expect(model.countries, countries);
      expect(model.price, 29.99);
      expect(model.unlimited, true);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final BundleCategoryResponseModelDto category =
          BundleCategoryResponseModelDto(
        type: "LOCAL",
        code: "local-001",
        title: "Local",
      );
      final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
        CountryResponseModelDto(
          country: "Germany",
          countryCode: "DE",
          iso3Code: "DEU",
        ),
      ];

      final BundleResponseModelDto model = BundleResponseModelDto(
        displayTitle: "Germany Bundle",
        displaySubtitle: "10GB Data",
        bundleCode: "DE-10GB",
        bundleCategory: category,
        bundleMarketingName: "Germany Special",
        bundleName: "Germany 10GB",
        countCountries: 1,
        currencyCode: "EUR",
        gprsLimitDisplay: "10 GB",
        price: 35,
        priceDisplay: "€35.00",
        unlimited: false,
        validity: 15,
        validityLabel: "Days",
        icon: "https://example.com/de.png",
        countries: countries,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["display_title"], "Germany Bundle");
      expect(json["display_subtitle"], "10GB Data");
      expect(json["bundle_code"], "DE-10GB");
      expect(json["bundle_category"], isNotNull);
      expect(json["bundle_marketing_name"], "Germany Special");
      expect(json["bundle_name"], "Germany 10GB");
      expect(json["count_countries"], 1);
      expect(json["currency_code"], "EUR");
      expect(json["gprs_limit_display"], "10 GB");
      expect(json["price"], 35.00);
      expect(json["price_display"], "€35.00");
      expect(json["unlimited"], false);
      expect(json["validity"], 15);
      expect(json["icon"], "https://example.com/de.png");
      expect(json["countries"], isNotNull);
    });

    test("toJson handles null fields", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["display_title"], isNull);
      expect(json["bundle_category"], isNull);
      expect(json["countries"], isNull);
      expect(json["price"], isNull);
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{
          "display_title": "Bundle 1",
          "bundle_code": "B1",
        },
        <String, dynamic>{
          "display_title": "Bundle 2",
          "bundle_code": "B2",
        },
      ];

      // Act
      final List<BundleResponseModelDto> models =
          BundleResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].displayTitle, "Bundle 1");
      expect(models[1].displayTitle, "Bundle 2");
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<BundleResponseModelDto> models =
          BundleResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("getMockGlobalBundles returns list of bundles", () {
      // Act
      final List<BundleResponseModelDto> mockBundles =
          BundleResponseModelDto.getMockGlobalBundles();

      // Assert
      expect(mockBundles, isNotEmpty);
      expect(mockBundles.length, 5);
    });

    test("getMockGlobalBundles all bundles have required fields", () {
      // Act
      final List<BundleResponseModelDto> mockBundles =
          BundleResponseModelDto.getMockGlobalBundles();

      // Assert
      for (final BundleResponseModelDto bundle in mockBundles) {
        expect(bundle.displayTitle, isNotNull);
        expect(bundle.bundleCode, isNotNull);
        expect(bundle.bundleCategory, isNotNull);
        expect(bundle.bundleCategory?.type, "GLOBAL");
        expect(bundle.price, isNotNull);
      }
    });

    test("getMockGlobalBundles first bundle has expected values", () {
      // Act
      final List<BundleResponseModelDto> mockBundles =
          BundleResponseModelDto.getMockGlobalBundles();
      final BundleResponseModelDto firstBundle = mockBundles[0];

      // Assert
      expect(firstBundle.displayTitle, "sd");
      expect(firstBundle.bundleCode, "None");
      expect(firstBundle.price, 15);
      expect(firstBundle.currencyCode, "BYR");
      expect(firstBundle.countries, isNotNull);
      expect(firstBundle.countries?.length, 1);
    });

    test("getMockGlobalBundles contains bundles with different prices", () {
      // Act
      final List<BundleResponseModelDto> mockBundles =
          BundleResponseModelDto.getMockGlobalBundles();

      // Assert
      expect(mockBundles[0].price, 15);
      expect(mockBundles[1].price, 1.5);
      expect(mockBundles[4].price, 3);
    });

    test("roundtrip fromJson and toJson preserves simple data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "display_title": "Test",
        "bundle_code": "TEST-123",
        "price": 25.50,
        "unlimited": false,
      };

      // Act
      final BundleResponseModelDto model =
          BundleResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["display_title"], originalJson["display_title"]);
      expect(resultJson["bundle_code"], originalJson["bundle_code"]);
      expect(resultJson["price"], originalJson["price"]);
      expect(resultJson["unlimited"], originalJson["unlimited"]);
    });

    test("toJson includes nested bundle_category", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto(
        bundleCode: "TEST",
        bundleCategory: BundleCategoryResponseModelDto(
          type: "TEST_TYPE",
          code: "TEST_CODE",
          title: "Test Title",
        ),
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["bundle_category"], isNotNull);
      expect(json["bundle_category"]["type"], "TEST_TYPE");
      expect(json["bundle_category"]["code"], "TEST_CODE");
      expect(json["bundle_category"]["title"], "Test Title");
    });

    test("toJson includes nested countries list", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto(
        bundleCode: "TEST",
        countries: <CountryResponseModelDto>[
          CountryResponseModelDto(country: "France", countryCode: "FR"),
          CountryResponseModelDto(country: "Spain", countryCode: "ES"),
        ],
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["countries"], isNotNull);
      expect(json["countries"], isList);
      expect((json["countries"] as List<dynamic>).length, 2);
    });

    test("toDomain converts to BundleResponseModel", () {
      // Arrange
      final BundleCategoryResponseModelDto category =
          BundleCategoryResponseModelDto(
        type: "GLOBAL",
        code: "global-001",
        title: "Global",
      );
      final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
        CountryResponseModelDto(country: "USA", countryCode: "US"),
      ];
      final BundleResponseModelDto dto = BundleResponseModelDto(
        displayTitle: "USA Bundle",
        bundleCode: "USA-001",
        bundleCategory: category,
        countries: countries,
        price: 29.99,
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.displayTitle, "USA Bundle");
      expect(domain.bundleCode, "USA-001");
      expect(domain.bundleCategory, isNotNull);
      expect(domain.countries, isNotNull);
      expect(domain.price, 29.99);
    });

    test("toDomain handles null fields", () {
      // Arrange
      final BundleResponseModelDto dto = BundleResponseModelDto();

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.displayTitle, isNull);
      expect(domain.bundleCode, isNull);
      expect(domain.bundleCategory, isNull);
    });

    test("fromDomain converts from BundleResponseModel", () {
      // Arrange
      final BundleResponseModelDto dto = BundleResponseModelDto();
      final domain = BundleResponseModel(
        displayTitle: "Test",
        bundleCode: "TEST-123",
        price: 25.0,
      );

      // Act
      final result = dto.fromDomain(domain);

      // Assert
      expect(result.displayTitle, "Test");
      expect(result.bundleCode, "TEST-123");
      expect(result.price, 25.0);
    });

    test("fromDomain handles null model", () {
      // Arrange
      final BundleResponseModelDto dto = BundleResponseModelDto();

      // Act
      final result = dto.fromDomain(null);

      // Assert
      expect(result.displayTitle, isNull);
      expect(result.bundleCode, isNull);
      expect(result.price, isNull);
    });

    test("isCruise getter returns true when category is CRUISE", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto(
        bundleCode: "CRUISE-001",
        bundleCategory: BundleCategoryResponseModelDto(
          type: "CRUISE",
          code: "cruise-001",
          title: "Cruise",
        ),
      );

      // Act
      final bool isCruise = model.isCruise;

      // Assert
      expect(isCruise, true);
    });

    test("isCruise getter returns false when category is not CRUISE", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto(
        bundleCode: "GLOBAL-001",
        bundleCategory: BundleCategoryResponseModelDto(
          type: "GLOBAL",
          code: "global-001",
          title: "Global",
        ),
      );

      // Act
      final bool isCruise = model.isCruise;

      // Assert
      expect(isCruise, false);
    });

    test("isCruise getter returns false when category is null", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto(
        bundleCode: "TEST",
      );

      // Act
      final bool isCruise = model.isCruise;

      // Assert
      expect(isCruise, false);
    });

    test("getValidityDisplay handles null validityLabel", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto(
        bundleCode: "TEST",
        validity: 7,
        validityLabel: null,
      );

      // Act
      final String? display = model.getValidityDisplay();

      // Assert
      expect(display, isNull);
    });

    test("getValidityDisplay handles empty validityLabel returns null", () {
      // Arrange
      final BundleResponseModelDto model = BundleResponseModelDto(
        bundleCode: "TEST",
        validity: 7,
        validityLabel: "",
      );

      // Act
      final String? display = model.getValidityDisplay();

      // Assert
      expect(display, isNull);
    });
  });
}
