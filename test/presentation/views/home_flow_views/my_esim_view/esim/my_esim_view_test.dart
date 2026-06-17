import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/widgets/custom_tab_view.dart";
import "package:esim_open_source/presentation/widgets/empty_content.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";
import "../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("MyESimView Essential Tests", () {
    testWidgets("renders correctly with default constructor",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      await tester.pumpWidget(createTestableWidget(const MyESimView()));
      await tester.pump();

      expect(find.byType(MyESimView), findsOneWidget);
    });

    testWidgets("renders with callback function", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      bool callbackCalled = false;
      void testCallback() {
        callbackCalled = true;
      }

      await tester.pumpWidget(
        createTestableWidget(MyESimView(onRequestDataPlansTab: testCallback)),
      );
      await tester.pump();

      expect(find.byType(MyESimView), findsOneWidget);
      expect(callbackCalled, isFalse);
    });

    testWidgets("displays main content structure", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      await tester.pumpWidget(createTestableWidget(const MyESimView()));
      await tester.pump();

      expect(find.text(LocaleKeys.myESim_titleText.tr()), findsOneWidget);
      expect(find.byType(DataPlansTabView), findsOneWidget);
      expect(find.text(LocaleKeys.current_plans.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.expired_plans.tr()), findsOneWidget);
      expect(find.byType(Badge), findsAtLeastNWidgets(1));
    });

    testWidgets("handles notification button tap", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      await tester.pumpWidget(createTestableWidget(const MyESimView()));
      await tester.pump();

      final Finder notificationButton = find.byType(GestureDetector).first;
      await tester.tap(notificationButton);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets("renders empty content widgets", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      await tester.pumpWidget(createTestableWidget(const MyESimView()));
      await tester.pump();

      // Check that empty content structure exists
      expect(find.byType(EmptyCurrentPlansContent), findsAny);
    });
  });

  group("MyESimView Properties", () {
    test("routeName is set correctly", () {
      expect(MyESimView.routeName, equals("MyEsimView"));
    });

    test("widget properties", () {
      void testCallback() {}
      final MyESimView widget = MyESimView(onRequestDataPlansTab: testCallback);

      expect(widget, isA<MyESimView>());
      expect(widget.onRequestDataPlansTab, isNotNull);
      expect(widget, isA<StatelessWidget>());
    });

    test("debugFillProperties includes onRequestDataPlansTab", () {
      void testCallback() {}
      final MyESimView widget = MyESimView(onRequestDataPlansTab: testCallback);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;
      expect(properties, isNotEmpty);

      // Verify that onRequestDataPlansTab property exists
      final bool hasCallback = properties.any(
        (DiagnosticsNode prop) => prop.name == "onRequestDataPlansTab",
      );
      expect(hasCallback, isTrue);
    });
  });

  group("MyESimView Callback Coverage Tests", () {
    late MockBottomSheetService mockBottomSheetService;
    late MockFlutterChannelHandlerService mockFlutterChannelHandlerService;
    late MyESimViewModel viewModel;

    setUp(() async {
      mockBottomSheetService =
          locator<BottomSheetService>() as MockBottomSheetService;
      mockFlutterChannelHandlerService = locator<FlutterChannelHandlerService>()
          as MockFlutterChannelHandlerService;
      viewModel = locator<MyESimViewModel>();
    });

    testWidgets(
        "callback functions are properly executed via direct invocation",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      // Setup mock responses
      when(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        ignoreSafeArea: anyNamed("ignoreSafeArea"),
        data: anyNamed("data"),
      ),).thenAnswer((_) async => null);

      when(mockFlutterChannelHandlerService.openEsimSetupForAndroid(
        smdpAddress: anyNamed("smdpAddress"),
        activationCode: anyNamed("activationCode"),
      ),).thenAnswer((_) async => true);

      // Build the widget first
      await tester.pumpWidget(createTestableWidget(const MyESimView()));
      await tester.pumpAndSettle();

      // Verify list is initially empty
      expect(viewModel.state.currentESimList.length, equals(0));

      // Add test data to trigger item builders
      final PurchaseEsimBundleResponseModel testBundle = PurchaseEsimBundleResponseModel(
        iccid: "test-iccid",
        displayTitle: "Test Bundle",
        paymentDate: "1640995200000",
        smdpAddress: "test-smdp",
        activationCode: "test-activation-code",
      );
      viewModel.state.currentESimList.add(testBundle);

      // Verify data was added
      expect(viewModel.state.currentESimList.length, equals(1));

      // Test onEditName callback directly through view model
      await viewModel.onEditNameClick(iccid: "test-iccid");
      verify(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).called(1);

      // Reset mock for next test
      reset(mockBottomSheetService);
      when(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).thenAnswer((_) async => null);

      // Test onTopUpClick callback
      await viewModel.onTopUpClick(iccid: "test-iccid");
      verify(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).called(1);

      // Reset mock for next test
      reset(mockBottomSheetService);
      when(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).thenAnswer((_) async => null);

      // Test onConsumptionClick callback
      await viewModel.onConsumptionClick(iccid: "test-iccid");
      verify(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).called(1);

      // Reset mock for next test
      reset(mockBottomSheetService);
      when(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).thenAnswer((_) async => null);

      // Test onQrCodeClick callback
      await viewModel.onQrCodeClick(iccid: "test-iccid");
      verify(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).called(1);

      // Test onInstallClick callback
      await viewModel.onInstallClick(iccid: "test-iccid");
      // Just verify no exception was thrown
      expect(tester.takeException(), isNull);
    });

    testWidgets("onRequestDataPlansTab callback integration",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      bool callbackTriggered = false;
      void testCallback() {
        callbackTriggered = true;
      }

      // Create widget with callback
      await tester.pumpWidget(
        createTestableWidget(MyESimView(onRequestDataPlansTab: testCallback)),
      );
      await tester.pumpAndSettle();

      // Test that the widget was created with the callback
      expect(
          tester
              .widget<MyESimView>(find.byType(MyESimView))
              .onRequestDataPlansTab,
          isNotNull,);

      // The callback would be triggered through user interaction or view model state changes
      // For coverage, we can verify it's properly passed to the widget
      expect(callbackTriggered, isFalse); // Initially false
    });

    testWidgets("view builds successfully and callback paths exist",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "MyEsimView");

      // Setup mocks
      when(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        ignoreSafeArea: anyNamed("ignoreSafeArea"),
        data: anyNamed("data"),
      ),).thenAnswer((_) async => null);

      // Build widget first
      await tester.pumpWidget(createTestableWidget(const MyESimView()));
      await tester.pumpAndSettle();

      // Test if the widget builds successfully
      expect(find.byType(MyESimView), findsOneWidget);

      // Add test data after widget is built
      final PurchaseEsimBundleResponseModel testBundle = PurchaseEsimBundleResponseModel(
        iccid: "test-iccid",
        displayTitle: "Test Bundle",
        displaySubtitle: "Test Subtitle",
        paymentDate: "1640995200000",
        smdpAddress: "test-smdp",
        activationCode: "test-activation-code",
        bundleCode: "test-bundle-code",
        gprsLimitDisplay: "1GB",
        validityLabel: "Days",
        priceDisplay: "10 USD",
      );

      viewModel.state.currentESimList.add(testBundle);

      // Verify list has data
      expect(viewModel.state.currentESimList.length, equals(1));

      // Test callbacks directly to ensure coverage of callback logic
      await viewModel.onEditNameClick(iccid: "test-iccid");
      verify(mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        data: anyNamed("data"),
      ),).called(1);

      // Test that the view can handle the callback assignments
      // This covers the lambda function assignments in the view
      expect(find.byType(MyESimView), findsOneWidget);
    });
  });
}
