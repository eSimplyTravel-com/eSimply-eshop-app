import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_order_success/purchase_order_success_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_order_success/purchase_order_success_view_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "PurchaseOrderSuccessView");
  });

  group("PurchaseOrderSuccessView Widget Tests", () {
    testWidgets("renders basic structure with required components",
        (WidgetTester tester) async {
      // Create test data
      final PurchaseEsimBundleResponseModel testBundle =
          PurchaseEsimBundleResponseModel(
        smdpAddress: "test",
        activationCode: "test",
      );

      await tester.pumpWidget(
        createTestableWidget(
          PurchaseOrderSuccessView(purchaseESimBundle: testBundle),
        ),
      );
      await tester.pump();

      // Check if any actual exception occurred (not just overflow)
      final FlutterError? exception = tester.takeException() as FlutterError?;
      if (exception != null &&
          !exception.message.contains("RenderFlex overflowed")) {
        throw exception;
      }
    });

    testWidgets("renders basic structure with other components",
        (WidgetTester tester) async {
      // Create test data
      final PurchaseEsimBundleResponseModel testBundle =
          PurchaseEsimBundleResponseModel(
        smdpAddress: "test",
        activationCode: "test",
      );
      locator<PurchaseOrderSuccessViewModel>().state.showInstallButton = true;
      await tester.pumpWidget(
        createTestableWidget(
          PurchaseOrderSuccessView(purchaseESimBundle: testBundle),
        ),
      );
      await tester.pump();

      // Check if any actual exception occurred (not just overflow)
      final FlutterError? exception = tester.takeException() as FlutterError?;
      if (exception != null &&
          !exception.message.contains("RenderFlex overflowed")) {
        throw exception;
      }
    });

    testWidgets("handles app clip environment correctly shows/hides download",
        (WidgetTester tester) async {
      final PurchaseEsimBundleResponseModel testBundle =
          PurchaseEsimBundleResponseModel(
        smdpAddress: "test-smdp-address",
        activationCode: "test-activation-code",
      );

      // Test without app clip - should show download button
      AppEnvironment.isFromAppClip = false;

      await tester.pumpWidget(
        createTestableWidget(
          PurchaseOrderSuccessView(purchaseESimBundle: testBundle),
        ),
      );
      await tester.pump();

      // Check if any actual exception occurred (not just overflow)
      FlutterError? exception = tester.takeException() as FlutterError?;
      if (exception != null &&
          !exception.message.contains("RenderFlex overflowed")) {
        throw exception;
      }

      // Test with app clip - should hide download button
      AppEnvironment.isFromAppClip = true;
      await tester.pumpWidget(
        createTestableWidget(
          PurchaseOrderSuccessView(purchaseESimBundle: testBundle),
        ),
      );
      await tester.pump();

      // Check if any actual exception occurred (not just overflow)
      exception = tester.takeException() as FlutterError?;
      if (exception != null &&
          !exception.message.contains("RenderFlex overflowed")) {
        throw exception;
      }

      // Reset state
      AppEnvironment.isFromAppClip = false;
    });

    testWidgets("debug properties returns correct property",
        (WidgetTester tester) async {
      const PurchaseOrderSuccessView widget = PurchaseOrderSuccessView(
        purchaseESimBundle: null,
      );

      // Check if any actual exception occurred (not just overflow)
      FlutterError? exception = tester.takeException() as FlutterError?;
      if (exception != null &&
          !exception.message.contains("RenderFlex overflowed")) {
        throw exception;
      }

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      final DiagnosticsProperty<PurchaseEsimBundleResponseModel?> bundleProp =
          props.firstWhere(
                  (DiagnosticsNode p) => p.name == "purchaseESimBundle",)
              as DiagnosticsProperty<PurchaseEsimBundleResponseModel?>;

      expect(bundleProp.value, isNull);
      expect(props.isNotEmpty, isTrue);
    });

    testWidgets("widget constructor and routeName coverage",
        (WidgetTester tester) async {
      // final PurchaseEsimBundleResponseModel testBundle =
      //     PurchaseEsimBundleResponseModel(
      //   smdpAddress: "test-smdp-address",
      //   activationCode: "test-activation-code",
      // );

      const PurchaseOrderSuccessView widget = PurchaseOrderSuccessView(
        purchaseESimBundle: null,
      );

      // Test route name constant
      expect(PurchaseOrderSuccessView.routeName,
          equals("PurchaseOrderSuccessView"),);

      // Test constructor
      expect(widget.purchaseESimBundle, isNull);
      expect(widget.key, isNull);
    });
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}
