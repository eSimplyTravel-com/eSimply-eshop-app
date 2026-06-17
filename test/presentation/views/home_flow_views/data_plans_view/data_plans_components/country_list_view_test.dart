import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/country_list_view.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("CountriesList Widget Tests", () {
    late List<CountryResponseModel> testCountries;
    late void Function(CountryResponseModel) mockCallback;

    setUp(() async {
      await tearDownTest();
      await setupTest();
      
      // Create test data
      testCountries = <CountryResponseModel>[
        CountryResponseModel(
          id: "1",
          country: "United States",
          iso3Code: "USA",
          icon: "us_icon",
        ),
      ];

      mockCallback = (CountryResponseModel country) {
        // Mock callback implementation
      };
    });

    testWidgets("renders basic structure with countries", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          CountriesList(
            countries: testCountries,
            showShimmer: false,
            onCountryTap: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(CountriesList), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("renders empty state when no countries", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          CountriesList(
            countries: <CountryResponseModel>[],
            showShimmer: false,
            onCountryTap: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(CountriesList), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets("renders with shimmer", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          CountriesList(
            countries: testCountries,
            showShimmer: true,
            onCountryTap: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(CountriesList), findsOneWidget);
    });

    test("handles padding parameter", () {
      final CountriesList widget = CountriesList(
        countries: testCountries,
        showShimmer: false,
        onCountryTap: mockCallback,
        lastItemBottomPadding: 90,
      );

      expect(widget.lastItemBottomPadding, equals(90));
      expect(widget.countries, equals(testCountries));
    });

    test("debug properties coverage", () {
      final CountriesList widget = CountriesList(
        countries: testCountries,
        showShimmer: true,
        onCountryTap: mockCallback,
        lastItemBottomPadding: 90,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);

      // Test that all properties are included
      expect(props.any((DiagnosticsNode prop) => prop.name == "onCountryTap"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "countries"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "showShimmer"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "lastItemBottomPadding"), isTrue);
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}
