sealed class AnalyticEvent {
  const AnalyticEvent(this.eventName);
  factory AnalyticEvent.appCheckApp() => AnalyticsEvent("app_check_app");
  factory AnalyticEvent.appCheckBackend() =>
      AnalyticsEvent("app_check_backend");
  factory AnalyticEvent.contactUsClicked() =>
      AnalyticsEvent("contact_us_clicked");
  factory AnalyticEvent.userGuideOpened() =>
      AnalyticsEvent("user_guide_opened");
  factory AnalyticEvent.regionsClicked() => AnalyticsEvent("regions_clicked");
  factory AnalyticEvent.firstOpenCampaign({
    required String utm,
    required String platform,
  }) =>
      CampaignEvent(
        "first_open_campaign",
        utm: utm,
        platform: platform,
      );
  factory AnalyticEvent.loginSuccess({
    required String utm,
    required String platform,
  }) =>
      CampaignEvent(
        "campaign_login",
        utm: utm,
        platform: platform,
      );
  factory AnalyticEvent.buySuccess({
    required String utm,
    required String platform,
    required String amount,
    required String currency,
  }) =>
      PurchaseSuccessEvent(
        "campaign_buy",
        utm: utm,
        platform: platform,
        amount: amount,
        currency: currency,
      );
  factory AnalyticEvent.buyTopUpSuccess({
    required String utm,
    required String platform,
    required String amount,
    required String currency,
  }) =>
      PurchaseSuccessEvent(
        "campaign_topup",
        utm: utm,
        platform: platform,
        amount: amount,
        currency: currency,
      );

  factory AnalyticEvent.bundleDetail({
    required String bundleCode,
    required String bundleName,
    required String user,
  }) =>
      BundleDetailEvent(
        "bundle_detail",
        bundleCode: bundleCode,
        bundleName: bundleName,
        user: user,
      );

  factory AnalyticEvent.createOrder({
    required String bundleCode,
    required String bundleName,
    required String user,
    required String orderId,
    required String method,
  }) =>
      CreateOrderEvent(
        "create_order",
        bundleCode: bundleCode,
        bundleName: bundleName,
        user: user,
        orderId: orderId,
        method: method,
      );

  factory AnalyticEvent.stripePay({
    required String bundleCode,
    required String bundleName,
    required String user,
    required String orderId,
  }) =>
      StripePaymentEvent(
        "stripe_pay",
        bundleCode: bundleCode,
        bundleName: bundleName,
        user: user,
        orderId: orderId,
        method: "Card",
      );

  factory AnalyticEvent.stripePaymentSuccessful({
    required String bundleCode,
    required String bundleName,
    required String user,
    required String orderId,
  }) =>
      StripePaymentEvent(
        "stripe_payment_successful",
        bundleCode: bundleCode,
        bundleName: bundleName,
        user: user,
        orderId: orderId,
        method: "Card",
      );

  factory AnalyticEvent.walletPaymentSuccessful({
    required String bundleCode,
    required String bundleName,
    required String user,
    required String orderId,
  }) =>
      StripePaymentEvent(
        "wallet_payment_successful",
        bundleCode: bundleCode,
        bundleName: bundleName,
        user: user,
        orderId: orderId,
        method: "Wallet",
      );

  final String eventName;
  Map<String, Object>? get parameters;
}

class AnalyticsEvent extends AnalyticEvent {
  AnalyticsEvent(super.eventName);

  @override
  Map<String, Object>? get parameters => null;
}

class CampaignEvent extends AnalyticEvent {
  CampaignEvent(
    super.eventName, {
    required this.utm,
    required this.platform,
  });
  final String utm;
  final String platform;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "utm": utm,
        "platform": platform,
      };
}

class PurchaseSuccessEvent extends AnalyticEvent {
  PurchaseSuccessEvent(
    super.eventName, {
    required this.utm,
    required this.platform,
    required this.amount,
    required this.currency,
  });
  final String utm;
  final String platform;
  final String amount;
  final String currency;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "utm": utm,
        "platform": platform,
        "amount": amount,
        "currency": currency,
      };
}

class BundleDetailEvent extends AnalyticEvent {
  BundleDetailEvent(
    super.eventName, {
    required this.bundleCode,
    required this.bundleName,
    required this.user,
  });

  final String bundleCode;
  final String bundleName;
  final String user;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "bundleCode": bundleCode,
        "bundleName": bundleName,
        "user": user,
      };
}

class CreateOrderEvent extends AnalyticEvent {
  CreateOrderEvent(
    super.eventName, {
    required this.bundleCode,
    required this.bundleName,
    required this.user,
    required this.orderId,
    required this.method,
  });

  final String bundleCode;
  final String bundleName;
  final String user;
  final String orderId;
  final String method;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "bundleCode": bundleCode,
        "bundleName": bundleName,
        "user": user,
        "orderId": orderId,
        "method": method,
      };
}

class StripePaymentEvent extends AnalyticEvent {
  StripePaymentEvent(
    super.eventName, {
    required this.bundleCode,
    required this.bundleName,
    required this.user,
    required this.orderId,
    required this.method,
  });

  final String bundleCode;
  final String bundleName;
  final String user;
  final String orderId;
  final String method;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "bundleCode": bundleCode,
        "bundleName": bundleName,
        "user": user,
        "orderId": orderId,
        "method": method,
      };
}

abstract class AnalyticsService {
  Future<void> configure({
    bool firebaseAnalytics = true,
  });

  Future<void> logEvent({
    required AnalyticEvent event,
  });

  Future<void> setUserId(String? hashedEmail);

  /// The stored analytics consent, or `null` when the user has never been
  /// asked. Deliberately tri-state: "not asked" is not the same as "refused",
  /// and only the first of those may be turned into a question.
  bool? get analyticsConsent;

  /// Records the user's choice and pushes it into both SDKs. Granting also
  /// clears the platform defaults that keep collection off at launch; both
  /// calls persist across launches, so this is not re-applied on every start.
  Future<void> setAnalyticsConsent({required bool granted});
}
