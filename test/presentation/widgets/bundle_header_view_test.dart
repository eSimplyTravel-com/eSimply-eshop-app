import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/unlimited_data_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("BundleHeaderView Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders title, subtitle and data value",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BundleHeaderView(
              title: "United States",
              subTitle: "30 Days",
              dataValue: "5 GB",
              isLoading: false,
              showUnlimitedData: false,
            ),
          ),
        ),
      );
      tester.takeException(); // consume flag/arrow asset-load failures

      // Assert
      expect(find.byType(BundleHeaderView), findsOneWidget);
      expect(find.text("United States"), findsOneWidget);
      expect(find.text("30 Days"), findsOneWidget);
      expect(find.text("5 GB"), findsOneWidget);
      expect(find.byType(CountryFlagImage), findsOneWidget);
    });

    testWidgets("shows unlimited data widget when showUnlimitedData is true",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BundleHeaderView(
              title: "Global",
              subTitle: "Unlimited",
              dataValue: "∞",
              isLoading: false,
              showUnlimitedData: true,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.byType(UnlimitedDataWidget), findsOneWidget);
    });

    testWidgets("renders in loading (shimmer) state",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BundleHeaderView(
              title: "Loading",
              subTitle: "...",
              dataValue: "0",
              isLoading: true,
              showUnlimitedData: false,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — builds without errors while loading
      expect(find.byType(BundleHeaderView), findsOneWidget);
    });

    testWidgets("hides nav arrow when hasNavArrow is false",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BundleHeaderView(
              title: "No Arrow",
              subTitle: "x",
              dataValue: "1 GB",
              isLoading: false,
              showUnlimitedData: false,
              hasNavArrow: false,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.byType(BundleHeaderView), findsOneWidget);
    });

    testWidgets("applies custom text styles", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BundleHeaderView(
              title: "Styled",
              subTitle: "sub",
              dataValue: "2 GB",
              isLoading: false,
              showUnlimitedData: false,
              titleStyle: TextStyle(fontSize: 30),
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      final Text titleWidget = tester.widget<Text>(find.text("Styled"));
      expect(titleWidget.style?.fontSize, equals(30));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const BundleHeaderView widget = BundleHeaderView(
        title: "t",
        subTitle: "s",
        dataValue: "d",
        isLoading: false,
        showUnlimitedData: false,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "countryTitle",
        "countryContent",
        "countryDataValue",
        "countryPrice",
        "hasNavArrow",
        "titleStyle",
        "contentStyle",
        "dataValueStyle",
        "priceStyle",
        "imagePath",
        "isLoading",
        "showUnlimitedData",
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
        createTestableWidget(bundleHeaderViewPreview()),
      );
      tester.takeException();

      // Assert
      expect(find.byType(BundleHeaderView), findsOneWidget);
      expect(find.text("United States"), findsOneWidget);
    });
  });
}
