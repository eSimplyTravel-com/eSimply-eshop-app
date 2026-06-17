import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model_dto.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/e_sim_expired_plan_item.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();
  late PurchaseEsimBundleResponseModelDto item;
  late ESimExpiredPlanItem eSimExpiredPlanItem;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();
    item = PurchaseEsimBundleResponseModelDto.mockItems().first;
    eSimExpiredPlanItem = ESimExpiredPlanItem(
      countryCode: "",
      showUnlimitedData: item.unlimited ?? false,
      title: item.displayTitle ?? "",
      subTitle: item.displaySubtitle ?? "",
      dataValue: item.gprsLimitDisplay ?? "",
      price: "",
      validity: item.getValidityDisplay() ?? "",
      expiryDate: DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(item.paymentDate ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      ),
      isLoading: false,
      iconPath: item.icon,
      onItemClick: () => <dynamic, dynamic>{},
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  testWidgets("renders correctly with all components",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        eSimExpiredPlanItem,
      ),
    );
    await tester.pump();

    Finder gesture = find.byType(GestureDetector).at(0);
    await tester.tap(gesture);
    await tester.pump();
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    eSimExpiredPlanItem.debugFillProperties(builder);
  });
}
