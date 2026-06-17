import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/user/order_history_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/user/payment_details_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for OrderHistoryResponseModelDto
/// Tests JSON serialization/deserialization, domain mapping, and mock data
void main() {
  group("OrderHistoryResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "order_number": "ORDER-123",
        "order_status": "completed",
        "order_amount": 99.99,
        "order_currency": "USD",
        "order_date": "2024-01-01",
        "order_type": "purchase",
        "quantity": 2,
        "company_name": "Monty Mobile",
        "company_address": "123 Street",
        "company_phone": "+1234567890",
        "company_email": "info@company.com",
        "company_website": "https://company.com",
        "order_display_price": "99.99 USD",
        "payment_details": <String, dynamic>{
          "id": "pay-1",
          "card_display": "Visa ****4242",
        },
        "bundle_details": <String, dynamic>{
          "bundle_code": "BUNDLE-001",
          "display_title": "Test Bundle",
        },
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.orderNumber, "ORDER-123");
      expect(model.orderStatus, "completed");
      expect(model.orderAmount, 99.99);
      expect(model.orderCurrency, "USD");
      expect(model.orderDate, "2024-01-01");
      expect(model.orderType, "purchase");
      expect(model.quantity, 2);
      expect(model.companyName, "Monty Mobile");
      expect(model.companyAddress, "123 Street");
      expect(model.companyPhone, "+1234567890");
      expect(model.companyEmail, "info@company.com");
      expect(model.companyWebsite, "https://company.com");
      expect(model.orderDisplayPrice, "99.99 USD");
      expect(model.paymentDetails, isNotNull);
      expect(model.paymentDetails?.id, "pay-1");
      expect(model.bundleDetails, isNotNull);
      expect(model.bundleDetails?.bundleCode, "BUNDLE-001");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

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

    test("fromJson handles null payment_details", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "order_number": "ORDER-123",
        "bundle_details": <String, dynamic>{
          "bundle_code": "BUNDLE-001",
        },
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.paymentDetails, isNull);
      expect(model.bundleDetails, isNotNull);
    });

    test("fromJson handles null bundle_details", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "order_number": "ORDER-123",
        "payment_details": <String, dynamic>{
          "id": "pay-1",
        },
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.bundleDetails, isNull);
      expect(model.paymentDetails, isNotNull);
    });

    test("fromJson with explicit null nested values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "payment_details": null,
        "bundle_details": null,
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.paymentDetails, isNull);
      expect(model.bundleDetails, isNull);
    });

    test("fromJson handles order_amount as integer", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "order_amount": 100,
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.orderAmount, 100.0);
      expect(model.orderAmount, isA<double>());
    });

    test("fromJson handles order_amount as double", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "order_amount": 49.95,
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.orderAmount, 49.95);
    });

    test("fromJson handles null order_amount", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "order_number": "ORDER-123",
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.orderAmount, isNull);
    });

    test("constructor assigns values correctly", () {
      // Arrange
      final PaymentDetailsResponseModelDto payment =
          PaymentDetailsResponseModelDto(id: "pay-1");
      final BundleResponseModelDto bundle =
          BundleResponseModelDto(bundleCode: "BUNDLE-001");

      // Act
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto(
        orderNumber: "ORDER-456",
        orderStatus: "pending",
        orderAmount: 12.5,
        orderCurrency: "EUR",
        orderDate: "2024-02-01",
        orderType: "topup",
        quantity: 3,
        companyName: "Company",
        companyAddress: "Address",
        companyPhone: "+9876543210",
        companyEmail: "test@test.com",
        companyWebsite: "https://test.com",
        orderDisplayPrice: "12.5 EUR",
        paymentDetails: payment,
        bundleDetails: bundle,
      );

      // Assert
      expect(model.orderNumber, "ORDER-456");
      expect(model.orderStatus, "pending");
      expect(model.orderAmount, 12.5);
      expect(model.orderCurrency, "EUR");
      expect(model.orderDate, "2024-02-01");
      expect(model.orderType, "topup");
      expect(model.quantity, 3);
      expect(model.companyName, "Company");
      expect(model.companyAddress, "Address");
      expect(model.companyPhone, "+9876543210");
      expect(model.companyEmail, "test@test.com");
      expect(model.companyWebsite, "https://test.com");
      expect(model.orderDisplayPrice, "12.5 EUR");
      expect(model.paymentDetails, payment);
      expect(model.bundleDetails, bundle);
    });

    test("all fields are nullable", () {
      // Act
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto();

      // Assert
      expect(model.orderNumber, isNull);
      expect(model.orderStatus, isNull);
      expect(model.orderAmount, isNull);
      expect(model.quantity, isNull);
      expect(model.paymentDetails, isNull);
      expect(model.bundleDetails, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto(
        orderNumber: "ORDER-123",
        orderStatus: "completed",
        orderAmount: 99.99,
        orderCurrency: "USD",
        orderDate: "2024-01-01",
        orderType: "purchase",
        quantity: 2,
        companyName: "Monty Mobile",
        companyAddress: "123 Street",
        companyPhone: "+1234567890",
        companyEmail: "info@company.com",
        companyWebsite: "https://company.com",
        orderDisplayPrice: "99.99 USD",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["order_number"], "ORDER-123");
      expect(json["order_status"], "completed");
      expect(json["order_amount"], 99.99);
      expect(json["order_currency"], "USD");
      expect(json["order_date"], "2024-01-01");
      expect(json["order_type"], "purchase");
      expect(json["quantity"], 2);
      expect(json["company_name"], "Monty Mobile");
      expect(json["company_address"], "123 Street");
      expect(json["company_phone"], "+1234567890");
      expect(json["company_email"], "info@company.com");
      expect(json["company_website"], "https://company.com");
      expect(json["order_display_price"], "99.99 USD");
    });

    test("toJson handles null fields", () {
      // Arrange
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["order_number"], isNull);
      expect(json["order_status"], isNull);
      expect(json["order_amount"], isNull);
      expect(json["order_currency"], isNull);
      expect(json["order_date"], isNull);
      expect(json["order_type"], isNull);
      expect(json["quantity"], isNull);
      expect(json["company_name"], isNull);
      expect(json["company_address"], isNull);
      expect(json["company_phone"], isNull);
      expect(json["company_email"], isNull);
      expect(json["company_website"], isNull);
      expect(json["order_display_price"], isNull);
      expect(json["payment_details"], isNull);
      expect(json["bundle_details"], isNull);
    });

    test("toJson includes nested payment_details correctly", () {
      // Arrange
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto(
        paymentDetails: PaymentDetailsResponseModelDto(
          id: "pay-1",
          cardDisplay: "Visa ****4242",
        ),
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["payment_details"], isNotNull);
      expect(json["payment_details"]["id"], "pay-1");
      expect(json["payment_details"]["card_display"], "Visa ****4242");
    });

    test("toJson includes nested bundle_details correctly", () {
      // Arrange
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto(
        bundleDetails: BundleResponseModelDto(bundleCode: "BUNDLE-001"),
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["bundle_details"], isNotNull);
      expect(json["bundle_details"]["bundle_code"], "BUNDLE-001");
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{"order_number": "ORDER-1"},
        <String, dynamic>{"order_number": "ORDER-2"},
      ];

      // Act
      final List<OrderHistoryResponseModelDto> models =
          OrderHistoryResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].orderNumber, "ORDER-1");
      expect(models[1].orderNumber, "ORDER-2");
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<OrderHistoryResponseModelDto> models =
          OrderHistoryResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("toDomain maps all fields correctly", () {
      // Arrange
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto(
        orderNumber: "ORDER-123",
        orderStatus: "completed",
        orderAmount: 99.99,
        orderCurrency: "USD",
        orderDate: "2024-01-01",
        orderType: "purchase",
        quantity: 2,
        companyName: "Monty Mobile",
        companyAddress: "123 Street",
        companyPhone: "+1234567890",
        companyEmail: "info@company.com",
        companyWebsite: "https://company.com",
        orderDisplayPrice: "99.99 USD",
        paymentDetails: PaymentDetailsResponseModelDto(id: "pay-1"),
        bundleDetails: BundleResponseModelDto(bundleCode: "BUNDLE-001"),
      );

      // Act
      final OrderHistoryResponseModel domain = model.toDomain();

      // Assert
      expect(domain.orderNumber, "ORDER-123");
      expect(domain.orderStatus, "completed");
      expect(domain.orderAmount, 99.99);
      expect(domain.orderCurrency, "USD");
      expect(domain.orderDate, "2024-01-01");
      expect(domain.orderType, "purchase");
      expect(domain.quantity, 2);
      expect(domain.companyName, "Monty Mobile");
      expect(domain.companyAddress, "123 Street");
      expect(domain.companyPhone, "+1234567890");
      expect(domain.companyEmail, "info@company.com");
      expect(domain.companyWebsite, "https://company.com");
      expect(domain.orderDisplayPrice, "99.99 USD");
      expect(domain.paymentDetails, isNotNull);
      expect(domain.paymentDetails?.id, "pay-1");
      expect(domain.bundleDetails, isNotNull);
    });

    test("toDomain handles null nested fields", () {
      // Arrange
      final OrderHistoryResponseModelDto model = OrderHistoryResponseModelDto(
        orderNumber: "ORDER-123",
      );

      // Act
      final OrderHistoryResponseModel domain = model.toDomain();

      // Assert
      expect(domain.orderNumber, "ORDER-123");
      expect(domain.paymentDetails, isNull);
      expect(domain.bundleDetails, isNull);
    });

    test("mockData returns list of orders", () {
      // Act
      final List<OrderHistoryResponseModelDto> items =
          OrderHistoryResponseModelDto().mockData();

      // Assert
      expect(items, isNotEmpty);
      expect(items.length, 6);
    });

    test("mockData all items have required fields", () {
      // Act
      final List<OrderHistoryResponseModelDto> items =
          OrderHistoryResponseModelDto().mockData();

      // Assert
      for (final OrderHistoryResponseModelDto item in items) {
        expect(item.orderNumber, isNotNull);
        expect(item.orderStatus, isNotNull);
        expect(item.orderAmount, isNotNull);
        expect(item.paymentDetails, isNotNull);
        expect(item.bundleDetails, isNotNull);
      }
    });

    test("mockData first item has expected values", () {
      // Act
      final List<OrderHistoryResponseModelDto> items =
          OrderHistoryResponseModelDto().mockData();
      final OrderHistoryResponseModelDto first = items[0];

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

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "order_number": "ORDER-123",
        "order_status": "completed",
        "order_amount": 99.99,
        "order_currency": "USD",
        "order_date": "2024-01-01",
        "order_type": "purchase",
        "quantity": 2,
        "company_name": "Monty Mobile",
        "order_display_price": "99.99 USD",
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["order_number"], originalJson["order_number"]);
      expect(resultJson["order_status"], originalJson["order_status"]);
      expect(resultJson["order_amount"], originalJson["order_amount"]);
      expect(resultJson["order_currency"], originalJson["order_currency"]);
      expect(resultJson["order_date"], originalJson["order_date"]);
      expect(resultJson["order_type"], originalJson["order_type"]);
      expect(resultJson["quantity"], originalJson["quantity"]);
      expect(resultJson["company_name"], originalJson["company_name"]);
      expect(
        resultJson["order_display_price"],
        originalJson["order_display_price"],
      );
    });

    test("fromJson handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "order_number": "",
        "order_status": "",
        "company_name": "",
      };

      // Act
      final OrderHistoryResponseModelDto model =
          OrderHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.orderNumber, "");
      expect(model.orderStatus, "");
      expect(model.companyName, "");
    });

    test("multiple instances are independent", () {
      // Act
      final OrderHistoryResponseModelDto model1 =
          OrderHistoryResponseModelDto(orderNumber: "ORDER-1");
      final OrderHistoryResponseModelDto model2 =
          OrderHistoryResponseModelDto(orderNumber: "ORDER-2");

      // Assert
      expect(model1.orderNumber, "ORDER-1");
      expect(model2.orderNumber, "ORDER-2");
    });
  });
}
