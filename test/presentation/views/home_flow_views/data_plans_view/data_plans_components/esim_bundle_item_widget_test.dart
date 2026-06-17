import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/esim_bundle_item_widget.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("EsimBundleWidget Widget Tests", () {
    late VoidCallback mockOnTap;

    setUp(() async {
      await tearDownTest();
      await setupTest();

      mockOnTap = () {
        // Mock callback implementation
      };
    });

    testWidgets("renders basic structure", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          EsimBundleWidget(
            priceButtonText: r"$10.99",
            title: "USA Bundle",
            data: "5GB",
            validFor: "30 days",
            supportedCountries: <CountryResponseModel>[],
            onPriceButtonClick: mockOnTap,
            icon: "usa_icon",
            showUnlimitedData: false,
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(EsimBundleWidget), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(Card), findsOneWidget);
      expect(find.text("USA Bundle"), findsOneWidget);
      expect(find.text("5GB"), findsOneWidget);
    });

    testWidgets("renders with empty countries", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          EsimBundleWidget(
            priceButtonText: r"$5.99",
            title: "Simple Bundle",
            data: "2GB",
            validFor: "7 days",
            supportedCountries: <CountryResponseModel>[],
            availableCountries: <CountryResponseModel>[],
            onPriceButtonClick: mockOnTap,
            icon: "simple_icon",
            showUnlimitedData: false,
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(EsimBundleWidget), findsOneWidget);
      expect(find.text("Simple Bundle"), findsOneWidget);
      expect(find.text("2GB"), findsOneWidget);
    });

    test("handles unlimited data property", () {
      final EsimBundleWidget widget = EsimBundleWidget(
        priceButtonText: r"$25.99",
        title: "Europe Unlimited",
        data: "Unlimited",
        validFor: "15 days",
        supportedCountries: <CountryResponseModel>[],
        onPriceButtonClick: mockOnTap,
        icon: "europe_icon",
        showUnlimitedData: true,
      );

      expect(widget.showUnlimitedData, isTrue);
      expect(widget.title, equals("Europe Unlimited"));
      expect(widget.data, equals("Unlimited"));
    });

    test("handles tap callback", () {
      bool wasTapped = false;

      final EsimBundleWidget widget = EsimBundleWidget(
        priceButtonText: r"$10.99",
        title: "Test Bundle",
        data: "5GB",
        validFor: "30 days",
        supportedCountries: <CountryResponseModel>[],
        onPriceButtonClick: () {
          wasTapped = true;
        },
        icon: "test_icon",
        showUnlimitedData: false,
      );

      // Simulate tap by calling the callback directly
      widget.onPriceButtonClick();
      expect(wasTapped, isTrue);
    });

    test("debug properties coverage", () {
      final EsimBundleWidget widget = EsimBundleWidget(
        priceButtonText: r"$15.99",
        title: "Test Bundle Title",
        data: "10GB",
        validFor: "30 days",
        supportedCountries: <CountryResponseModel>[],
        availableCountries: <CountryResponseModel>[],
        onPriceButtonClick: mockOnTap,
        icon: "test_icon",
        showUnlimitedData: true,
        showArrow: false,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);

      // Test that all properties are included
      expect(
          props.any((DiagnosticsNode prop) => prop.name == "priceButtonText"),
          isTrue,);
      expect(props.any((DiagnosticsNode prop) => prop.name == "title"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "data"), isTrue);
      expect(
          props.any((DiagnosticsNode prop) => prop.name == "validFor"), isTrue,);
      expect(
          props
              .any((DiagnosticsNode prop) => prop.name == "supportedCountries"),
          isTrue,);
      expect(
          props
              .any((DiagnosticsNode prop) => prop.name == "availableCountries"),
          isTrue,);
      expect(props.any((DiagnosticsNode prop) => prop.name == "showArrow"),
          isTrue,);
      expect(
          props
              .any((DiagnosticsNode prop) => prop.name == "onPriceButtonClick"),
          isTrue,);
      expect(props.any((DiagnosticsNode prop) => prop.name == "icon"), isTrue);
      expect(
          props.any((DiagnosticsNode prop) => prop.name == "showUnlimitedData"),
          isTrue,);
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}
