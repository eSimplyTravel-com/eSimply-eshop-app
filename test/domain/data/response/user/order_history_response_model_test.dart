import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/data/response/user/payment_details_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for OrderHistoryResponseModel
/// Tests constructor, mockData factory method, and field handling
void main() {
  group("OrderHistoryResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Arrange
      final PaymentDetailsResponseModel paymentDetails =
          PaymentDetailsResponseModel(
        id: "12345",
        cardNumber: "4242",
      );
      final BundleResponseModel bundle = BundleResponseModel(
        bundleCode: "bundle1",
        bundleName: "Test Bundle",
      );

      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderNumber: "ORD-001",
        orderStatus: "completed",
        orderAmount: 25.99,
        orderCurrency: "USD",
        orderDate: "2026-06-02",
        orderType: "purchase",
        quantity: 1,
        companyName: "Monty Mobile",
        companyAddress: "123 Main St",
        companyPhone: "+1-800-123-4567",
        companyEmail: "support@montymobile.com",
        companyWebsite: "https://montymobile.com",
        orderDisplayPrice: "25.99 USD",
        paymentDetails: paymentDetails,
        bundleDetails: bundle,
      );

      // Assert
      expect(model.orderNumber, "ORD-001");
      expect(model.orderStatus, "completed");
      expect(model.orderAmount, 25.99);
      expect(model.orderCurrency, "USD");
      expect(model.orderDate, "2026-06-02");
      expect(model.orderType, "purchase");
      expect(model.quantity, 1);
      expect(model.companyName, "Monty Mobile");
      expect(model.companyAddress, "123 Main St");
      expect(model.companyPhone, "+1-800-123-4567");
      expect(model.companyEmail, "support@montymobile.com");
      expect(model.companyWebsite, "https://montymobile.com");
      expect(model.orderDisplayPrice, "25.99 USD");
      expect(model.paymentDetails, isNotNull);
      expect(model.bundleDetails, isNotNull);
    });

    test("constructor with minimal fields", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderNumber: "ORD-001",
      );

      // Assert
      expect(model.orderNumber, "ORD-001");
      expect(model.orderStatus, isNull);
      expect(model.orderAmount, isNull);
      expect(model.paymentDetails, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel();

      // Assert
      expect(model.orderNumber, isNull);
      expect(model.orderStatus, isNull);
      expect(model.orderAmount, isNull);
      expect(model.orderCurrency, isNull);
      expect(model.orderDate, isNull);
      expect(model.orderType, isNull);
      expect(model.quantity, isNull);
      expect(model.companyName, isNull);
      expect(model.companyAddress, isNull);
      expect(model.companyPhone, isNull);
      expect(model.companyEmail, isNull);
      expect(model.companyWebsite, isNull);
      expect(model.orderDisplayPrice, isNull);
      expect(model.paymentDetails, isNull);
      expect(model.bundleDetails, isNull);
    });

    test("orderNumber getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderNumber: "ada2964e-81df-4a39-ab34-f1adde6e7b15",
      );

      // Assert
      expect(model.orderNumber, "ada2964e-81df-4a39-ab34-f1adde6e7b15");
    });

    test("orderStatus getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderStatus: "pending",
      );

      // Assert
      expect(model.orderStatus, "pending");
    });

    test("orderAmount getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderAmount: 99.99,
      );

      // Assert
      expect(model.orderAmount, 99.99);
    });

    test("orderCurrency getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderCurrency: "EUR",
      );

      // Assert
      expect(model.orderCurrency, "EUR");
    });

    test("orderDate getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderDate: "2026-05-15",
      );

      // Assert
      expect(model.orderDate, "2026-05-15");
    });

    test("orderType getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderType: "refund",
      );

      // Assert
      expect(model.orderType, "refund");
    });

    test("quantity getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        quantity: 5,
      );

      // Assert
      expect(model.quantity, 5);
    });

    test("companyName getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        companyName: "Acme Corp",
      );

      // Assert
      expect(model.companyName, "Acme Corp");
    });

    test("companyAddress getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        companyAddress: "456 Oak Ave, Springfield",
      );

      // Assert
      expect(model.companyAddress, "456 Oak Ave, Springfield");
    });

    test("companyPhone getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        companyPhone: "+1-555-0123",
      );

      // Assert
      expect(model.companyPhone, "+1-555-0123");
    });

    test("companyEmail getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        companyEmail: "info@company.com",
      );

      // Assert
      expect(model.companyEmail, "info@company.com");
    });

    test("companyWebsite getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        companyWebsite: "https://www.company.com",
      );

      // Assert
      expect(model.companyWebsite, "https://www.company.com");
    });

    test("orderDisplayPrice getter returns correct value", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderDisplayPrice: "99.99 EUR",
      );

      // Assert
      expect(model.orderDisplayPrice, "99.99 EUR");
    });

    test("paymentDetails getter returns nested model", () {
      // Arrange
      final PaymentDetailsResponseModel paymentDetails =
          PaymentDetailsResponseModel(
        id: "payment123",
        cardNumber: "1234",
      );

      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        paymentDetails: paymentDetails,
      );

      // Assert
      expect(model.paymentDetails, isNotNull);
      expect(model.paymentDetails?.id, "payment123");
      expect(model.paymentDetails?.cardNumber, "1234");
    });

    test("bundleDetails getter returns nested model", () {
      // Arrange
      final BundleResponseModel bundle = BundleResponseModel(
        bundleCode: "bundle123",
        bundleName: "Premium Plan",
      );

      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        bundleDetails: bundle,
      );

      // Assert
      expect(model.bundleDetails, isNotNull);
      expect(model.bundleDetails?.bundleCode, "bundle123");
      expect(model.bundleDetails?.bundleName, "Premium Plan");
    });

    test("mockData returns list of OrderHistoryResponseModel", () {
      // Act
      final List<OrderHistoryResponseModel> mockList =
          OrderHistoryResponseModel().mockData();

      // Assert
      expect(mockList, isNotEmpty);
      expect(mockList.length, 6);
      expect(mockList[0], isA<OrderHistoryResponseModel>());
    });

    test("mockData all items have required fields populated", () {
      // Act
      final List<OrderHistoryResponseModel> mockList =
          OrderHistoryResponseModel().mockData();

      // Assert
      for (final OrderHistoryResponseModel item in mockList) {
        expect(item.orderNumber, isNotNull);
        expect(item.orderStatus, isNotNull);
        expect(item.orderAmount, isNotNull);
        expect(item.orderCurrency, isNotNull);
        expect(item.orderDate, isNotNull);
        expect(item.orderType, isNotNull);
        expect(item.quantity, isNotNull);
        expect(item.companyName, isNotNull);
        expect(item.orderDisplayPrice, isNotNull);
      }
    });

    test("mockData first item has expected values", () {
      // Act
      final List<OrderHistoryResponseModel> mockList =
          OrderHistoryResponseModel().mockData();
      final OrderHistoryResponseModel first = mockList[0];

      // Assert
      expect(first.orderNumber, "ada2964e-81df-4a39-ab34-f1adde6e7b15");
      expect(first.orderStatus, "order status");
      expect(first.orderAmount, 355);
      expect(first.orderCurrency, "USD");
      expect(first.orderDate, "12344");
      expect(first.orderType, "order Type");
      expect(first.quantity, 2);
      expect(first.companyName, "Monty Mobile");
      expect(first.orderDisplayPrice, "2.5 USD");
    });

    test("mockData first item includes nested models", () {
      // Act
      final List<OrderHistoryResponseModel> mockList =
          OrderHistoryResponseModel().mockData();
      final OrderHistoryResponseModel first = mockList[0];

      // Assert
      expect(first.paymentDetails, isNotNull);
      expect(first.bundleDetails, isNotNull);
    });

    test("mockData all items are identical", () {
      // Act
      final List<OrderHistoryResponseModel> mockList =
          OrderHistoryResponseModel().mockData();

      // Assert
      final OrderHistoryResponseModel first = mockList[0];
      for (int i = 1; i < mockList.length; i++) {
        expect(mockList[i].orderNumber, first.orderNumber);
        expect(mockList[i].orderStatus, first.orderStatus);
        expect(mockList[i].orderAmount, first.orderAmount);
        expect(mockList[i].companyName, first.companyName);
      }
    });

    test("handles empty string values", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderNumber: "",
        orderStatus: "",
        orderCurrency: "",
        orderDate: "",
        orderType: "",
        companyName: "",
        companyAddress: "",
        companyPhone: "",
        companyEmail: "",
        companyWebsite: "",
        orderDisplayPrice: "",
      );

      // Assert
      expect(model.orderNumber, "");
      expect(model.orderStatus, "");
      expect(model.orderCurrency, "");
      expect(model.companyName, "");
    });

    test("handles zero order amount", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderAmount: 0.0,
      );

      // Assert
      expect(model.orderAmount, 0.0);
    });

    test("handles negative order amount", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderAmount: -25.50,
      );

      // Assert
      expect(model.orderAmount, -25.50);
    });

    test("handles large order amount", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderAmount: 999999.99,
      );

      // Assert
      expect(model.orderAmount, 999999.99);
    });

    test("handles zero quantity", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        quantity: 0,
      );

      // Assert
      expect(model.quantity, 0);
    });

    test("handles large quantity", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        quantity: 1000,
      );

      // Assert
      expect(model.quantity, 1000);
    });

    test("handles special characters in strings", () {
      // Act
      final OrderHistoryResponseModel model = OrderHistoryResponseModel(
        orderNumber: "ORD-2026-06-02-#001",
        companyName: "O'Brien's Mobile Co.",
        companyEmail: "support+esim@company.com",
        companyWebsite: "https://www.company.com/en-US",
        orderDisplayPrice: "€25.99 (incl. 19% VAT)",
      );

      // Assert
      expect(model.orderNumber, "ORD-2026-06-02-#001");
      expect(model.companyName, "O'Brien's Mobile Co.");
      expect(model.companyEmail, "support+esim@company.com");
      expect(model.companyWebsite, "https://www.company.com/en-US");
    });

    test("multiple instances are independent", () {
      // Act
      final OrderHistoryResponseModel order1 = OrderHistoryResponseModel(
        orderNumber: "ORD-001",
        orderAmount: 25.99,
        companyName: "Company A",
      );
      final OrderHistoryResponseModel order2 = OrderHistoryResponseModel(
        orderNumber: "ORD-002",
        orderAmount: 99.99,
        companyName: "Company B",
      );

      // Assert
      expect(order1.orderNumber, "ORD-001");
      expect(order1.orderAmount, 25.99);
      expect(order1.companyName, "Company A");
      expect(order2.orderNumber, "ORD-002");
      expect(order2.orderAmount, 99.99);
      expect(order2.companyName, "Company B");
    });

    test("orderStatus values are preserved", () {
      // Act
      final OrderHistoryResponseModel completedOrder =
          OrderHistoryResponseModel(
        orderStatus: "completed",
      );
      final OrderHistoryResponseModel pendingOrder = OrderHistoryResponseModel(
        orderStatus: "pending",
      );
      final OrderHistoryResponseModel cancelledOrder =
          OrderHistoryResponseModel(
        orderStatus: "cancelled",
      );

      // Assert
      expect(completedOrder.orderStatus, "completed");
      expect(pendingOrder.orderStatus, "pending");
      expect(cancelledOrder.orderStatus, "cancelled");
    });

    test("currency codes are preserved", () {
      // Act
      final OrderHistoryResponseModel usdOrder =
          OrderHistoryResponseModel(orderCurrency: "USD");
      final OrderHistoryResponseModel eurOrder =
          OrderHistoryResponseModel(orderCurrency: "EUR");
      final OrderHistoryResponseModel gbpOrder =
          OrderHistoryResponseModel(orderCurrency: "GBP");

      // Assert
      expect(usdOrder.orderCurrency, "USD");
      expect(eurOrder.orderCurrency, "EUR");
      expect(gbpOrder.orderCurrency, "GBP");
    });

    test("order type values are preserved", () {
      // Act
      final OrderHistoryResponseModel purchaseOrder =
          OrderHistoryResponseModel(orderType: "purchase");
      final OrderHistoryResponseModel refundOrder =
          OrderHistoryResponseModel(orderType: "refund");
      final OrderHistoryResponseModel renewalOrder =
          OrderHistoryResponseModel(orderType: "renewal");

      // Assert
      expect(purchaseOrder.orderType, "purchase");
      expect(refundOrder.orderType, "refund");
      expect(renewalOrder.orderType, "renewal");
    });

    test("nested payment details are optional", () {
      // Act
      final OrderHistoryResponseModel orderWithoutPayment =
          OrderHistoryResponseModel(
        orderNumber: "ORD-001",
      );
      final OrderHistoryResponseModel orderWithPayment =
          OrderHistoryResponseModel(
        orderNumber: "ORD-002",
        paymentDetails: PaymentDetailsResponseModel(id: "payment123"),
      );

      // Assert
      expect(orderWithoutPayment.paymentDetails, isNull);
      expect(orderWithPayment.paymentDetails, isNotNull);
    });

    test("nested bundle details are optional", () {
      // Act
      final OrderHistoryResponseModel orderWithoutBundle =
          OrderHistoryResponseModel(
        orderNumber: "ORD-001",
      );
      final OrderHistoryResponseModel orderWithBundle =
          OrderHistoryResponseModel(
        orderNumber: "ORD-002",
        bundleDetails: BundleResponseModel(bundleCode: "bundle123"),
      );

      // Assert
      expect(orderWithoutBundle.bundleDetails, isNull);
      expect(orderWithBundle.bundleDetails, isNotNull);
    });
  });
}
