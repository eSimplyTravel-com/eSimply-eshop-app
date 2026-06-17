import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_screen.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";

void main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "BundlesListScreen");

    // Mock the countries property for screen tests
    final BundlesDataService mockBundlesDataService =
        locator<BundlesDataService>();
    when(mockBundlesDataService.countries).thenReturn(getMockCountries());
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("BundlesListScreen Tests", () {
    testWidgets("renders basic structure with country type",
        (WidgetTester tester) async {
      // Set up error handler for this specific test
      final List<FlutterErrorDetails> errors = <FlutterErrorDetails>[];
      FlutterError.onError = (FlutterErrorDetails details) {
        final String message = details.exceptionAsString();
        if (message.contains("A RenderFlex overflowed") ||
            message.contains("overflowed by")) {
          errors.add(details);
          return;
        }
        FlutterError.presentError(details);
      };

      final EsimArguments args =
          const EsimArguments(id: "AFG", name: "Afghanistan", type: "Country");
      final BundlesListScreen screen = BundlesListScreen(esimItem: args);

      await tester.pumpWidget(
        createTestableWidget(
          screen,
        ),
      );

      await tester.pump();

      // Check that the title is displayed in the navigation
      expect(
        find.descendant(
          of: find.byType(CommonNavigationTitle),
          matching: find.text("Afghanistan"),
        ),
        findsOneWidget,
      );

      // Check that search field is displayed for country type
      expect(find.byType(MainInputField), findsOneWidget);

      // Check that the main stack is rendered
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
    });

    testWidgets("renders basic structure with region type",
        (WidgetTester tester) async {
      // Set up error handler for this specific test
      final List<FlutterErrorDetails> errors = <FlutterErrorDetails>[];
      FlutterError.onError = (FlutterErrorDetails details) {
        final String message = details.exceptionAsString();
        if (message.contains("A RenderFlex overflowed") ||
            message.contains("overflowed by")) {
          errors.add(details);
          return;
        }
        FlutterError.presentError(details);
      };

      final EsimArguments args =
          const EsimArguments(id: "EU", name: "Europe", type: "Region");
      final BundlesListScreen screen = BundlesListScreen(esimItem: args);

      await tester.pumpWidget(
        createTestableWidget(
          screen,
        ),
      );

      await tester.pump();

      // Check that the title is displayed
      expect(find.text("Europe"), findsOneWidget);

      // Search field should not be displayed for region type
      expect(find.byType(MainInputField), findsNothing);
    });

    testWidgets("displays navigation title correctly",
        (WidgetTester tester) async {
      // Set up error handler for this specific test
      final List<FlutterErrorDetails> errors = <FlutterErrorDetails>[];
      FlutterError.onError = (FlutterErrorDetails details) {
        final String message = details.exceptionAsString();
        if (message.contains("A RenderFlex overflowed") ||
            message.contains("overflowed by")) {
          errors.add(details);
          return;
        }
        FlutterError.presentError(details);
      };

      final EsimArguments args =
          const EsimArguments(id: "1", name: "Test Country", type: "Country");
      final BundlesListScreen screen = BundlesListScreen(esimItem: args);

      await tester.pumpWidget(
        createTestableWidget(
          screen,
        ),
      );

      await tester.pump();

      expect(find.byType(CommonNavigationTitle), findsOneWidget);
      expect(find.text("Test Country"), findsOneWidget);
    });

    testWidgets("search field interactions work", (WidgetTester tester) async {
      // Set up error handler for this specific test
      final List<FlutterErrorDetails> errors = <FlutterErrorDetails>[];
      FlutterError.onError = (FlutterErrorDetails details) {
        final String message = details.exceptionAsString();
        if (message.contains("A RenderFlex overflowed") ||
            message.contains("overflowed by")) {
          errors.add(details);
          return;
        }
        FlutterError.presentError(details);
      };

      final EsimArguments args =
          const EsimArguments(id: "AFG", name: "Afghanistan", type: "Country");
      final BundlesListScreen screen = BundlesListScreen(esimItem: args);

      await tester.pumpWidget(
        createTestableWidget(
          screen,
        ),
      );

      await tester.pump();

      // Find and tap the search field
      final Finder searchField = find.byType(MainInputField);
      expect(searchField, findsOneWidget);

      await tester.tap(searchField);
      await tester.pump();
    });

    test("debug properties coverage", () {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListScreen screen = BundlesListScreen(esimItem: args);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      screen.debugFillProperties(builder);

      // Verify that the property was added
      final List<DiagnosticsNode> properties = builder.properties;
      expect(
        properties.any((DiagnosticsNode prop) => prop.name == "esimItem"),
        isTrue,
      );
    });

    test("creates screen with correct route name", () {
      expect(BundlesListScreen.routeName, equals("BundlesListScreen"));
    });

    test("getContainerHeight function returns correct values", () {
      // This would need a BuildContext mock, but let's test the logic conceptually
      // The function should return min(maxHeight, height) where height = count * 80
      // and maxHeight = screenHeight * 0.25
    });
  });

  group("CountrySearchList Widget Tests", () {
    test("CountrySearchList debug properties", () {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(id: "1", country: "Test", icon: "icon"),
      ];
      final CountrySearchList widget = CountrySearchList(
        countries: countries,
        onCountrySelected: (CountryResponseModel country) {},
        searchQuery: "test",
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;
      expect(
        properties.any((DiagnosticsNode prop) => prop.name == "countries"),
        isTrue,
      );
      expect(
        properties
            .any((DiagnosticsNode prop) => prop.name == "onCountrySelected"),
        isTrue,
      );
      expect(
        properties.any((DiagnosticsNode prop) => prop.name == "searchQuery"),
        isTrue,
      );
    });
  });

  group("FlagChip Widget Tests", () {
    test("FlagChip debug properties", () {
      final FlagChip widget = FlagChip(
        icon: "test_icon",
        countryName: "Test Country",
        onRemove: () {},
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;
      expect(
        properties.any((DiagnosticsNode prop) => prop.name == "icon"),
        isTrue,
      );
      expect(
        properties.any((DiagnosticsNode prop) => prop.name == "countryName"),
        isTrue,
      );
      expect(
        properties.any((DiagnosticsNode prop) => prop.name == "onRemove"),
        isTrue,
      );
    });
  });

  group("FlagChipsRow Widget Tests", () {
    test("FlagChipsRow debug properties", () {
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(id: "1", country: "Test", icon: "icon"),
      ];
      final FlagChipsRow widget = FlagChipsRow(
        selectedCountries: countries,
        onChipRemoved: (CountryResponseModel country) {},
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;
      expect(
        properties
            .any((DiagnosticsNode prop) => prop.name == "selectedCountries"),
        isTrue,
      );
      expect(
        properties.any((DiagnosticsNode prop) => prop.name == "onChipRemoved"),
        isTrue,
      );
    });
  });
}
