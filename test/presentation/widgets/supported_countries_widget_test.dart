import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/widgets/circular_flag_icon.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  List<CountryResponseModel> countries(int count) {
    return List<CountryResponseModel>.generate(
      count,
      (int i) => CountryResponseModel(country: "C$i", icon: "c$i"),
    );
  }

  group("SupportedCountriesWidget Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders label and flags", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedCountriesWidget(
              label: "Countries",
              countries: countries(3),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
      tester.takeException(); // consume flag asset-load failures

      // Assert
      expect(find.byType(SupportedCountriesWidget), findsOneWidget);
      expect(find.text("Countries"), findsOneWidget);
      expect(find.byType(CircularFlagIcon), findsNWidgets(3));
    });

    testWidgets("shows overflow indicator when over maxCountriesToShow",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedCountriesWidget(
              label: "Countries",
              countries: countries(8),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — only maxCountriesToShow (5) flags plus a "+3" indicator
      expect(find.byType(CircularFlagIcon), findsNWidgets(5));
      expect(find.text("+3"), findsOneWidget);
    });

    testWidgets("hides label when showLabel is false",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedCountriesWidget(
              label: "Hidden",
              countries: countries(2),
              backgroundColor: Colors.grey,
              showLabel: false,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.text("Hidden"), findsNothing);
    });

    testWidgets("renders showOnlyFlags layout", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedCountriesWidget(
              label: "Flags only",
              countries: countries(6),
              backgroundColor: Colors.grey,
              showOnlyFlags: true,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — label not shown in flags-only mode, overflow indicator present
      expect(find.text("Flags only"), findsNothing);
      expect(find.text("+1"), findsOneWidget);
    });

    testWidgets("renders in loading state", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedCountriesWidget(
              label: "Loading",
              countries: countries(3),
              backgroundColor: Colors.grey,
              isLoading: true,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.byType(SupportedCountriesWidget), findsOneWidget);
    });

    testWidgets("applies custom labelStyle", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SupportedCountriesWidget(
              label: "Styled",
              countries: countries(1),
              backgroundColor: Colors.grey,
              labelStyle: const TextStyle(fontSize: 26),
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      final Text labelWidget = tester.widget<Text>(find.text("Styled"));
      expect(labelWidget.style?.fontSize, equals(26));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final SupportedCountriesWidget widget = SupportedCountriesWidget(
        label: "t",
        countries: countries(1),
        backgroundColor: Colors.grey,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "isLoading",
        "countries",
        "maxCountriesToShow",
        "size",
        "offset",
        "padding",
        "borderRadius",
        "backgroundColor",
        "labelStyle",
        "label",
        "showLabel",
        "showOnlyFlags",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(supportedCountriesWidgetPreview()),
      );
      tester.takeException();

      // Assert
      expect(find.byType(SupportedCountriesWidget), findsOneWidget);
      expect(find.text("Supported Countries"), findsOneWidget);
    });
  });
}
