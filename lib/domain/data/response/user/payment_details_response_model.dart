class PaymentDetailsResponseModel {
  PaymentDetailsResponseModel({
    this.id,
    this.description,
    this.paymentMethod,
    this.cardNumber,
    this.receiptEmail,
    this.address,
    this.displayBrand,
    this.country,
    this.cardDisplay,
  });

  final String? id;
  final String? description;
  final String? paymentMethod;
  final String? cardNumber;
  final String? receiptEmail;
  final String? address;
  final String? displayBrand;
  final String? country;
  final String? cardDisplay;

  PaymentDetailsResponseModel mockData() => PaymentDetailsResponseModel(
    id: "12345",
    description: "description",
    paymentMethod: "payment method",
    cardNumber: "4444",
    receiptEmail: "raed.nakour27@gmail.com",
    address: "Address",
    displayBrand: "display brand",
    country: "country",
    cardDisplay: "Visa ****4242",
  );
}
