import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/info_row_view.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_card.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("SupportedCountriesCard Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    testWidgets("renders with countries list", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T", "T-Mobile"],
        ),
        CountryResponseModel(
          country: "Canada",
          icon: "ca",
          operatorList: <String>["Rogers"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byType(SupportedCountriesCard), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets("displays correct country count", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
        CountryResponseModel(country: "CA", icon: "ca"),
        CountryResponseModel(country: "UK", icon: "uk"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      // Verify correct number of expansion tiles are rendered
      expect(find.byType(ExpansionTile), findsNWidgets(3));
    });

    testWidgets("renders country names", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us",
        ),
        CountryResponseModel(
          country: "Canada",
          icon: "ca",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      // Country names should be rendered in the expansion tiles
      expect(find.textContaining("United States"), findsOneWidget);
      expect(find.textContaining("Canada"), findsOneWidget);
    });

    testWidgets("renders country flags", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us_flag",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byType(CountryFlagImage), findsOneWidget);
    });

    testWidgets("shows expansion icon when operators exist", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T", "Verizon"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets("hides expansion icon when no operators", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>[],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets("expands to show operators on tap", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T", "Verizon", "T-Mobile"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      // Verify expansion icon is shown before tap
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      // Tap to expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.byType(InfoRow), findsOneWidget);
    });

    testWidgets("collapses on second tap", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us",
          operatorList: <String>["AT&T"],
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      // Initial state - should show down arrow
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      // Expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

      // Collapse
      await tester.tap(find.byType(ExpansionTile));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets("renders scrollbar", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
        CountryResponseModel(country: "CA", icon: "ca"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byType(Scrollbar), findsOneWidget);
    });

    testWidgets("renders ListView with correct item count", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
        CountryResponseModel(country: "CA", icon: "ca"),
        CountryResponseModel(country: "UK", icon: "uk"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byType(ExpansionTile), findsNWidgets(3));
    });

    testWidgets("handles null country name", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(icon: "us"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.text(""), findsWidgets);
    });

    testWidgets("handles null icon", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(country: "United States"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byType(CountryFlagImage), findsOneWidget);
    });

    testWidgets("handles null operator list", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          icon: "us",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
    });

    testWidgets("displays empty country list", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      // Verify no expansion tiles are rendered for empty list
      expect(find.byType(ExpansionTile), findsNothing);
      expect(find.byType(SupportedCountriesCard), findsOneWidget);
    });

    testWidgets("card has correct styling", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      final Card card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, EdgeInsets.zero);
      expect(card.elevation, 0);
      expect((card.shape! as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(6),);
    });

    testWidgets("column has correct layout", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      final Column column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Column),
        ).first,
      );

      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets("handles multiple countries with mixed operator lists", (WidgetTester tester) async {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(
          country: "US",
          icon: "us",
          operatorList: <String>["AT&T"],
        ),
        CountryResponseModel(
          country: "CA",
          icon: "ca",
          operatorList: <String>[],
        ),
        CountryResponseModel(
          country: "UK",
          icon: "uk",
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          SupportedCountriesCard(countries: countries),
        ),
      );

      await tester.pump();

      expect(find.byType(ExpansionTile), findsNWidgets(3));
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    test("debug properties coverage", () {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(country: "US", icon: "us"),
      ];

      final SupportedCountriesCard widget = SupportedCountriesCard(
        countries: countries,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);

      expect(
        props.any((DiagnosticsNode prop) => prop.name == "countries"),
        isTrue,
      );
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}
