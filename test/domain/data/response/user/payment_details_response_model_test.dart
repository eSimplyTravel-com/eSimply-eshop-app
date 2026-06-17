import "package:esim_open_source/domain/data/response/user/payment_details_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for PaymentDetailsResponseModel
/// Tests constructor, getters, and mockData factory method
void main() {
  group("PaymentDetailsResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        id: "12345",
        description: "Credit card payment",
        paymentMethod: "credit_card",
        cardNumber: "4242",
        receiptEmail: "user@example.com",
        address: "123 Main St",
        displayBrand: "Visa",
        country: "US",
        cardDisplay: "Visa ****4242",
      );

      // Assert
      expect(model.id, "12345");
      expect(model.description, "Credit card payment");
      expect(model.paymentMethod, "credit_card");
      expect(model.cardNumber, "4242");
      expect(model.receiptEmail, "user@example.com");
      expect(model.address, "123 Main St");
      expect(model.displayBrand, "Visa");
      expect(model.country, "US");
      expect(model.cardDisplay, "Visa ****4242");
    });

    test("constructor with minimal fields", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        id: "12345",
      );

      // Assert
      expect(model.id, "12345");
      expect(model.description, isNull);
      expect(model.paymentMethod, isNull);
      expect(model.cardNumber, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel();

      // Assert
      expect(model.id, isNull);
      expect(model.description, isNull);
      expect(model.paymentMethod, isNull);
      expect(model.cardNumber, isNull);
      expect(model.receiptEmail, isNull);
      expect(model.address, isNull);
      expect(model.displayBrand, isNull);
      expect(model.country, isNull);
      expect(model.cardDisplay, isNull);
    });

    test("id getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        id: "payment-123",
      );

      // Assert
      expect(model.id, "payment-123");
    });

    test("description getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        description: "Monthly subscription",
      );

      // Assert
      expect(model.description, "Monthly subscription");
    });

    test("paymentMethod getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        paymentMethod: "debit_card",
      );

      // Assert
      expect(model.paymentMethod, "debit_card");
    });

    test("cardNumber getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        cardNumber: "5555",
      );

      // Assert
      expect(model.cardNumber, "5555");
    });

    test("receiptEmail getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        receiptEmail: "john.doe@example.com",
      );

      // Assert
      expect(model.receiptEmail, "john.doe@example.com");
    });

    test("address getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        address: "456 Oak Avenue, NY 10001",
      );

      // Assert
      expect(model.address, "456 Oak Avenue, NY 10001");
    });

    test("displayBrand getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        displayBrand: "Mastercard",
      );

      // Assert
      expect(model.displayBrand, "Mastercard");
    });

    test("country getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        country: "GB",
      );

      // Assert
      expect(model.country, "GB");
    });

    test("cardDisplay getter returns correct value", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        cardDisplay: "Mastercard ****5555",
      );

      // Assert
      expect(model.cardDisplay, "Mastercard ****5555");
    });

    test("mockData returns complete PaymentDetailsResponseModel", () {
      // Act
      final PaymentDetailsResponseModel mockModel =
          PaymentDetailsResponseModel().mockData();

      // Assert
      expect(mockModel.id, "12345");
      expect(mockModel.description, "description");
      expect(mockModel.paymentMethod, "payment method");
      expect(mockModel.cardNumber, "4444");
      expect(mockModel.receiptEmail, "raed.nakour27@gmail.com");
      expect(mockModel.address, "Address");
      expect(mockModel.displayBrand, "display brand");
      expect(mockModel.country, "country");
      expect(mockModel.cardDisplay, "Visa ****4242");
    });

    test("mockData creates instance with all fields populated", () {
      // Act
      final PaymentDetailsResponseModel mockModel =
          PaymentDetailsResponseModel().mockData();

      // Assert
      expect(mockModel.id, isNotNull);
      expect(mockModel.description, isNotNull);
      expect(mockModel.paymentMethod, isNotNull);
      expect(mockModel.cardNumber, isNotNull);
      expect(mockModel.receiptEmail, isNotNull);
      expect(mockModel.address, isNotNull);
      expect(mockModel.displayBrand, isNotNull);
      expect(mockModel.country, isNotNull);
      expect(mockModel.cardDisplay, isNotNull);
    });

    test("mockData can be called multiple times independently", () {
      // Act
      final PaymentDetailsResponseModel mock1 =
          PaymentDetailsResponseModel().mockData();
      final PaymentDetailsResponseModel mock2 =
          PaymentDetailsResponseModel().mockData();

      // Assert
      expect(mock1.id, mock2.id);
      expect(mock1.cardNumber, mock2.cardNumber);
      expect(mock1.receiptEmail, mock2.receiptEmail);
    });

    test("handles empty string values", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        id: "",
        description: "",
        paymentMethod: "",
        cardNumber: "",
        receiptEmail: "",
        address: "",
        displayBrand: "",
        country: "",
        cardDisplay: "",
      );

      // Assert
      expect(model.id, "");
      expect(model.description, "");
      expect(model.paymentMethod, "");
      expect(model.cardNumber, "");
      expect(model.receiptEmail, "");
      expect(model.address, "");
      expect(model.displayBrand, "");
      expect(model.country, "");
      expect(model.cardDisplay, "");
    });

    test("handles special characters in string fields", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        id: "payment-123-456-789",
        description: "O'Brien's Payment",
        paymentMethod: "credit_card",
        cardNumber: "****4242",
        receiptEmail: "jose.garcia@example.com",
        address: "123 Main St, Apt #456",
        displayBrand: "American Express",
        country: "United States",
        cardDisplay: "Visa ****4242 (expires 12/25)",
      );

      // Assert
      expect(model.id, "payment-123-456-789");
      expect(model.description, "O'Brien's Payment");
      expect(model.receiptEmail, "jose.garcia@example.com");
      expect(model.address, "123 Main St, Apt #456");
      expect(model.cardDisplay, "Visa ****4242 (expires 12/25)");
    });

    test("multiple instances are independent", () {
      // Act
      final PaymentDetailsResponseModel model1 = PaymentDetailsResponseModel(
        id: "payment-1",
        cardNumber: "1111",
        country: "US",
      );
      final PaymentDetailsResponseModel model2 = PaymentDetailsResponseModel(
        id: "payment-2",
        cardNumber: "2222",
        country: "GB",
      );

      // Assert
      expect(model1.id, "payment-1");
      expect(model1.cardNumber, "1111");
      expect(model1.country, "US");
      expect(model2.id, "payment-2");
      expect(model2.cardNumber, "2222");
      expect(model2.country, "GB");
    });

    test("handles long string values", () {
      // Act
      final String longAddress =
          "123 Very Long Street Name That Goes On For Many Words, City, State 12345, Country";
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        address: longAddress,
        description:
            "This is a very long description of the payment details that contains multiple lines worth of text",
      );

      // Assert
      expect(model.address, longAddress);
      expect(model.description, contains("very long description"));
    });

    test("email validation pattern handling", () {
      // Act
      final PaymentDetailsResponseModel validEmail =
          PaymentDetailsResponseModel(
        receiptEmail: "user.name+tag@example.co.uk",
      );
      final PaymentDetailsResponseModel invalidEmail =
          PaymentDetailsResponseModel(
        receiptEmail: "not-an-email",
      );

      // Assert
      expect(validEmail.receiptEmail, "user.name+tag@example.co.uk");
      expect(invalidEmail.receiptEmail, "not-an-email");
    });

    test("card number masking patterns", () {
      // Act
      final PaymentDetailsResponseModel visaCard = PaymentDetailsResponseModel(
        cardNumber: "4242",
        displayBrand: "Visa",
        cardDisplay: "Visa ****4242",
      );
      final PaymentDetailsResponseModel mastercardCard =
          PaymentDetailsResponseModel(
        cardNumber: "5555",
        displayBrand: "Mastercard",
        cardDisplay: "Mastercard ****5555",
      );

      // Assert
      expect(visaCard.cardNumber, "4242");
      expect(visaCard.cardDisplay, "Visa ****4242");
      expect(mastercardCard.cardNumber, "5555");
      expect(mastercardCard.cardDisplay, "Mastercard ****5555");
    });

    test("country code handling", () {
      // Act
      final PaymentDetailsResponseModel usModel =
          PaymentDetailsResponseModel(country: "US");
      final PaymentDetailsResponseModel gbModel =
          PaymentDetailsResponseModel(country: "GB");
      final PaymentDetailsResponseModel deModel =
          PaymentDetailsResponseModel(country: "DE");

      // Assert
      expect(usModel.country, "US");
      expect(gbModel.country, "GB");
      expect(deModel.country, "DE");
    });

    test("mockData preserves type as PaymentDetailsResponseModel", () {
      // Act
      final PaymentDetailsResponseModel mockModel =
          PaymentDetailsResponseModel().mockData();

      // Assert
      expect(mockModel, isA<PaymentDetailsResponseModel>());
      expect(mockModel.runtimeType.toString(), "PaymentDetailsResponseModel");
    });

    test("constructor preserves field order", () {
      // Act
      final PaymentDetailsResponseModel model = PaymentDetailsResponseModel(
        id: "id-value",
        description: "desc-value",
        paymentMethod: "method-value",
        cardNumber: "card-value",
        receiptEmail: "email-value",
        address: "address-value",
        displayBrand: "brand-value",
        country: "country-value",
        cardDisplay: "display-value",
      );

      // Assert
      expect(model.id, "id-value");
      expect(model.description, "desc-value");
      expect(model.paymentMethod, "method-value");
      expect(model.cardNumber, "card-value");
      expect(model.receiptEmail, "email-value");
      expect(model.address, "address-value");
      expect(model.displayBrand, "brand-value");
      expect(model.country, "country-value");
      expect(model.cardDisplay, "display-value");
    });

    test("payment methods are stored as-is", () {
      // Act
      final PaymentDetailsResponseModel creditCard =
          PaymentDetailsResponseModel(paymentMethod: "credit_card");
      final PaymentDetailsResponseModel debitCard =
          PaymentDetailsResponseModel(paymentMethod: "debit_card");
      final PaymentDetailsResponseModel paypal =
          PaymentDetailsResponseModel(paymentMethod: "paypal");

      // Assert
      expect(creditCard.paymentMethod, "credit_card");
      expect(debitCard.paymentMethod, "debit_card");
      expect(paypal.paymentMethod, "paypal");
    });
  });
}
