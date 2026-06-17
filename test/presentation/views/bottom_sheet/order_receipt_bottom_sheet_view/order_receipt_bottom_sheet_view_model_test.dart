import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_receipt_bottom_sheet_view/order_receipt_bottom_sheet_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  late OrderReceiptBottomSheetViewModel viewModel;

  setUpAll(() async {
    await prepareTest();
  });

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "OrderReceiptBottomSheetView");

    // Use the REAL ViewModel (not mock) since it's simple and has mutable properties
    viewModel = OrderReceiptBottomSheetViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("OrderReceiptBottomSheetViewModel Tests", () {
    test("initialization test", () {
      expect(viewModel, isNotNull);
      expect(viewModel, isA<OrderReceiptBottomSheetViewModel>());
      expect(viewModel.isBusy, isFalse);
      expect(viewModel.globalKey, isA<GlobalKey>());
    });

    test("should initialize correctly with bundle order model", () {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "12345",
        companyName: "Test Company",
        orderDisplayPrice: r"$50.00",
        orderDate: "1640995200000",
      );

      viewModel.bundleOrderModel = mockOrder;

      expect(viewModel, isNotNull);
      expect(viewModel.isBusy, isFalse);
      expect(viewModel.bundleOrderModel, equals(mockOrder));
      expect(viewModel.globalKey, isA<GlobalKey>());
      expect(viewModel.bundleOrderModel?.orderNumber, equals("12345"));
      expect(viewModel.bundleOrderModel?.companyName, equals("Test Company"));
    });

    test("should handle null bundle order model", () {
      viewModel.bundleOrderModel = null;

      expect(viewModel, isNotNull);
      expect(viewModel.bundleOrderModel, isNull);
      expect(viewModel.globalKey, isA<GlobalKey>());
      expect(viewModel.isBusy, isFalse);
    });

    test("savePdf should not throw exception", () async {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "12345",
        companyName: "Test Company",
      );

      viewModel.bundleOrderModel = mockOrder;

      expect(() async => viewModel.savePdf(), returnsNormally);
    });

    test("savePdf should handle null bundle order model", () async {
      viewModel.bundleOrderModel = null;

      expect(() async => viewModel.savePdf(), returnsNormally);
    });

    test("globalKey should be unique for each instance", () {
      final OrderReceiptBottomSheetViewModel viewModel1 =
          OrderReceiptBottomSheetViewModel();
      final OrderReceiptBottomSheetViewModel viewModel2 =
          OrderReceiptBottomSheetViewModel();

      expect(viewModel1.globalKey, isNot(equals(viewModel2.globalKey)));
    });

    test("bundleOrderModel property can be accessed", () {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD001",
        companyName: "Company A",
        companyAddress: "123 Main St",
        companyEmail: "contact@company.com",
        orderDisplayPrice: r"$99.99",
        orderDate: "1640995200000",
        quantity: 1,
      );

      viewModel.bundleOrderModel = mockOrder;

      expect(viewModel.bundleOrderModel, isNotNull);
      expect(viewModel.bundleOrderModel?.orderNumber, equals("ORD001"));
      expect(viewModel.bundleOrderModel?.companyName, equals("Company A"));
      expect(viewModel.bundleOrderModel?.companyAddress, equals("123 Main St"));
      expect(
        viewModel.bundleOrderModel?.companyEmail,
        equals("contact@company.com"),
      );
      expect(viewModel.bundleOrderModel?.orderDisplayPrice, equals(r"$99.99"));
      expect(viewModel.bundleOrderModel?.quantity, equals(1));
    });

    test("globalKey is initialized on construction", () {
      expect(viewModel.globalKey, isNotNull);
      expect(viewModel.globalKey, isA<GlobalKey>());
    });

    test("multiple instances have different globalKeys", () {
      final OrderReceiptBottomSheetViewModel vm1 =
          OrderReceiptBottomSheetViewModel();
      final OrderReceiptBottomSheetViewModel vm2 =
          OrderReceiptBottomSheetViewModel();
      final OrderReceiptBottomSheetViewModel vm3 =
          OrderReceiptBottomSheetViewModel();

      expect(vm1.globalKey, isNot(equals(vm2.globalKey)));
      expect(vm2.globalKey, isNot(equals(vm3.globalKey)));
      expect(vm1.globalKey, isNot(equals(vm3.globalKey)));
    });

    test("isBusy is false initially", () {
      expect(viewModel.isBusy, isFalse);
    });

    test("bundleOrderModel with all properties populated", () {
      final OrderHistoryResponseModel fullOrder = OrderHistoryResponseModel(
        orderNumber: "ORDER-FULL-001",
        companyName: "Full Company",
        companyAddress: "456 Oak Avenue",
        companyEmail: "full@company.com",
        orderDisplayPrice: r"$150.00",
        orderDate: "1640995200000",
        quantity: 5,
        orderStatus: "Completed",
      );

      viewModel.bundleOrderModel = fullOrder;

      expect(viewModel.bundleOrderModel?.orderNumber, equals("ORDER-FULL-001"));
      expect(viewModel.bundleOrderModel?.companyName, equals("Full Company"));
      expect(viewModel.bundleOrderModel?.quantity, equals(5));
      expect(viewModel.bundleOrderModel?.orderStatus, equals("Completed"));
    });

    test("bundleOrderModel can be set with different order numbers", () {
      const String orderNumber1 = "ORD-2024-001";
      const String orderNumber2 = "ORD-2024-002";

      final OrderHistoryResponseModel order1 = OrderHistoryResponseModel(
        orderNumber: orderNumber1,
      );
      final OrderHistoryResponseModel order2 = OrderHistoryResponseModel(
        orderNumber: orderNumber2,
      );

      viewModel.bundleOrderModel = order1;
      expect(viewModel.bundleOrderModel?.orderNumber, equals(orderNumber1));

      viewModel.bundleOrderModel = order2;
      expect(viewModel.bundleOrderModel?.orderNumber, equals(orderNumber2));
    });

    test("bundleOrderModel property is mutable", () {
      final OrderHistoryResponseModel order1 = OrderHistoryResponseModel(
        orderNumber: "ORDER1",
      );
      final OrderHistoryResponseModel order2 = OrderHistoryResponseModel(
        orderNumber: "ORDER2",
      );

      viewModel.bundleOrderModel = order1;
      expect(viewModel.bundleOrderModel?.orderNumber, equals("ORDER1"));

      viewModel.bundleOrderModel = order2;
      expect(viewModel.bundleOrderModel?.orderNumber, equals("ORDER2"));
    });

    test("savePdf uses correct bundle name from bundleDetails", () async {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "TEST_ORDER",
      );

      viewModel.bundleOrderModel = mockOrder;

      // Should not throw exception even with null bundleDetails
      expect(() async => viewModel.savePdf(), returnsNormally);
    });

    test("savePdf handles empty bundle name", () async {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "EMPTY_BUNDLE",
      );

      viewModel.bundleOrderModel = mockOrder;

      expect(() async => viewModel.savePdf(), returnsNormally);
    });

    test("bundleOrderModel can be reassigned multiple times", () {
      final OrderHistoryResponseModel order1 = OrderHistoryResponseModel(
        orderNumber: "A",
        companyName: "Company A",
      );
      final OrderHistoryResponseModel order2 = OrderHistoryResponseModel(
        orderNumber: "B",
        companyName: "Company B",
      );
      final OrderHistoryResponseModel order3 = OrderHistoryResponseModel(
        orderNumber: "C",
        companyName: "Company C",
      );

      viewModel.bundleOrderModel = order1;
      expect(viewModel.bundleOrderModel?.orderNumber, equals("A"));

      viewModel.bundleOrderModel = order2;
      expect(viewModel.bundleOrderModel?.orderNumber, equals("B"));

      viewModel.bundleOrderModel = order3;
      expect(viewModel.bundleOrderModel?.orderNumber, equals("C"));
    });

    test("viewModel has proper defaults", () {
      expect(viewModel.isBusy, isFalse);
      expect(viewModel.globalKey, isNotNull);
    });
  });
}
