import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/regions_list_view.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("RegionsList Widget Tests", () {
    late List<RegionsResponseModel> testRegions;
    late void Function(RegionsResponseModel) mockCallback;

    setUp(() async {
      await tearDownTest();
      await setupTest();
      
      // Create test data
      testRegions = <RegionsResponseModel>[
        RegionsResponseModel(
          regionName: "Europe",
          regionCode: "EUR",
          icon: "europe_icon",
        ),
      ];

      mockCallback = (RegionsResponseModel region) {
        // Mock callback implementation
      };
    });

    testWidgets("renders basic structure with regions", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          RegionsList(
            regions: testRegions,
            showShimmer: false,
            onRegionTap: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(RegionsList), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("renders empty state when no regions", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          RegionsList(
            regions: <RegionsResponseModel>[],
            showShimmer: false,
            onRegionTap: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(RegionsList), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets("renders with shimmer", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          RegionsList(
            regions: testRegions,
            showShimmer: true,
            onRegionTap: mockCallback,
          ),
        ),
      );
      
      await tester.pump();

      expect(find.byType(RegionsList), findsOneWidget);
    });

    test("handles padding parameter", () {
      final RegionsList widget = RegionsList(
        regions: testRegions,
        showShimmer: false,
        onRegionTap: mockCallback,
        lastItemBottomPadding: 90,
      );

      expect(widget.lastItemBottomPadding, equals(90));
      expect(widget.regions, equals(testRegions));
    });

    test("debug properties coverage", () {
      final RegionsList widget = RegionsList(
        regions: testRegions,
        showShimmer: true,
        onRegionTap: mockCallback,
        lastItemBottomPadding: 90,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);

      // Test that all properties are included
      expect(props.any((DiagnosticsNode prop) => prop.name == "showShimmer"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "regions"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "onRegionTap"), isTrue);
      expect(props.any((DiagnosticsNode prop) => prop.name == "lastItemBottomPadding"), isTrue);
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}
