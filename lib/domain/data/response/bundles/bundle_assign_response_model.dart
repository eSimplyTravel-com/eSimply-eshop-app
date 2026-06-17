class BundleAssignResponseModel {
  BundleAssignResponseModel({
    this.publishableKey,
    this.merchantIdentifier,
    this.billingCountryCode,
    this.paymentIntentClientSecret,
    this.customerId,
    this.customerEphemeralKeySecret,
    this.testEnv,
    this.hasTax,
    this.merchantDisplayName,
    this.stripeUrlScheme,
    this.orderId,
    this.paymentStatus,
    this.taxPriceDisplay,
    this.subtotalPriceDisplay,
    this.totalPriceDisplay,
  });

  final String? publishableKey;
  final String? merchantIdentifier;
  final String? billingCountryCode;
  final String? paymentIntentClientSecret;
  final String? customerId;
  final String? customerEphemeralKeySecret;
  final bool? testEnv;
  final bool? hasTax;
  final String? merchantDisplayName;
  final String? stripeUrlScheme;
  final String? orderId;
  final String? paymentStatus;
  final String? subtotalPriceDisplay;
  final String? taxPriceDisplay;
  final String? totalPriceDisplay;

  bool isTaxExist() {
    return hasTax ?? false;
  }

}
