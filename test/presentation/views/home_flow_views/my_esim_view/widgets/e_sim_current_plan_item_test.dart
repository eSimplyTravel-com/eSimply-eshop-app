import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/circular_icon_button.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/e_sim_current_plan_item.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/top_up_button.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();
  late PurchaseEsimBundleResponseModel item;
  late ESimCurrentPlanItem eSimCurrentPlanItem;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();
    item = PurchaseEsimBundleResponseModel.mockItems().first;
    eSimCurrentPlanItem = ESimCurrentPlanItem(
      status: item.orderStatus ?? "",
      showUnlimitedData: item.unlimited ?? false,
      statusTextColor: Colors.white,
      statusBgColor: Colors.white,
      countryCode: "",
      title: item.displayTitle ?? "",
      subTitle: item.displaySubtitle ?? "",
      dataValue: item.gprsLimitDisplay ?? "",
      showInstallButton: false,
      showTopUpButton: item.isTopupAllowed ?? true,
      iconPath: item.icon ?? "",
      price: "",
      validity: item.getValidityDisplay()  ?? "",
      expiryDate: DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(item.paymentDate ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      ),
      supportedCountries: item.countries ?? <CountryResponseModel>[],
      onEditName: () {},
      onTopUpClick: () {},
      onConsumptionClick: () async => <dynamic, dynamic>{},
      onQrCodeClick: () async => <dynamic, dynamic>{},
      onInstallClick: () async => <dynamic, dynamic>{},
      isLoading: false,
      onItemClick: () async => <dynamic, dynamic>{},
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  testWidgets("renders correctly with all components",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        eSimCurrentPlanItem,
      ),
    );
    await tester.pump();

    Finder gesture = find.byType(GestureDetector).at(0);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(TopUpButton);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(MainButton).at(0);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(MainButton).at(1);
    await tester.tap(gesture);
    await tester.pump();
  });

  testWidgets("renders correctly with all components",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        eSimCurrentPlanItem,
      ),
    );
    await tester.pump();

    Finder gesture = find.byType(MainButton).at(1);
    await tester.tap(gesture);
    await tester.pump();
  });

  testWidgets("renders correctly with show install button",
      (WidgetTester tester) async {
    eSimCurrentPlanItem = ESimCurrentPlanItem(
      status: item.orderStatus ?? "",
      showUnlimitedData: item.unlimited ?? false,
      statusTextColor: Colors.white,
      statusBgColor: Colors.white,
      countryCode: "",
      title: item.displayTitle ?? "",
      subTitle: item.displaySubtitle ?? "",
      dataValue: item.gprsLimitDisplay ?? "",
      showInstallButton: true,
      showTopUpButton: item.isTopupAllowed ?? true,
      iconPath: item.icon ?? "",
      price: "",
      validity: item.getValidityDisplay()  ?? "",
      expiryDate: DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(item.paymentDate ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      ),
      supportedCountries: item.countries ?? <CountryResponseModel>[],
      onEditName: () {},
      onTopUpClick: () {},
      onConsumptionClick: () async => <dynamic, dynamic>{},
      onQrCodeClick: () async => <dynamic, dynamic>{},
      onInstallClick: () async => <dynamic, dynamic>{},
      isLoading: false,
      onItemClick: () => <dynamic, dynamic>{},
    );
    await tester.pumpWidget(
      createTestableWidget(
        eSimCurrentPlanItem,
      ),
    );
    await tester.pump();

    Finder gesture = find.byType(CircularIconButton).at(0);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(TopUpButton);
    await tester.tap(gesture);
    await tester.pump();

    gesture = find.byType(MainButton).at(2);
    await tester.tap(gesture);
    await tester.pump();
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    eSimCurrentPlanItem.debugFillProperties(builder);
  });
}
