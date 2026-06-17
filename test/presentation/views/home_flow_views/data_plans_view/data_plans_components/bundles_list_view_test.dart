import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/bundles_list_view.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("BundlesListView Widget Tests", () {
    late List<BundleResponseModel> testBundles;
    late void Function(BundleResponseModel) mockCallback;

    setUp(() async {
      await tearDownTest();
      await setupTest();
      
      // Create simple test data
      testBundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleName: "Test Bundle",
          gprsLimitDisplay: "5GB",
          unlimited: false,
          validityLabel: "days",
          priceDisplay: "10.99",
          icon: "test_icon",
          countries: <CountryResponseModel>[],
        ),
      ];

      mockCallback = (BundleResponseModel bundle) {
        // Mock callback implementation
      };
    });

    testWidgets("renders basic structure", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BundlesListView(
            bundles: testBundles,
            showShimmer: false,
            onBundleSelected: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(BundlesListView), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("renders empty bundles list", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BundlesListView(
            bundles: <BundleResponseModel>[],
            showShimmer: false,
            onBundleSelected: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(BundlesListView), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("renders with shimmer", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BundlesListView(
            bundles: testBundles,
            showShimmer: true,
            onBundleSelected: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(BundlesListView), findsOneWidget);
    });

    test("handles padding parameter", () {
      final BundlesListView widget = BundlesListView(
        bundles: testBundles,
        showShimmer: false,
        onBundleSelected: mockCallback,
        lastItemBottomPadding: 90,
      );

      expect(widget.lastItemBottomPadding, equals(90));
      expect(widget.bundles, equals(testBundles));
    });

    test("debug properties coverage", () {
      final BundlesListView widget = BundlesListView(
        bundles: testBundles,
        showShimmer: true,
        onBundleSelected: mockCallback,
        lastItemBottomPadding: 90,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      
      // Test that all properties are included
      expect(props.any((DiagnosticsNode prop) => prop.name == "onBundleSelected"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "bundles"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "showShimmer"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "lastItemBottomPadding"), isTrue);
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}
