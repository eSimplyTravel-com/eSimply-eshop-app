import "dart:async";

import "package:esim_open_source/domain/data/request/related_search.dart";

abstract interface class ApiUser {
  FutureOr<dynamic> getUserConsumption({required String iccID});

  FutureOr<dynamic> assignBundle({
    required String bundleCode,
    required String promoCode,
    required String referralCode,
    required String affiliateCode,
    required String paymentType,
    required RelatedSearchRequestModel relatedSearch,
    String? bearerToken,
  });

  FutureOr<dynamic> topUpBundle({
    required String iccID,
    required String bundleCode,
    required String paymentType,
  });

  FutureOr<dynamic> getUserNotifications({
    required int pageIndex,
    required int pageSize,
  });

  FutureOr<dynamic> setNotificationsRead();

  FutureOr<dynamic> getBundleExists({
    required String code,
  });

  FutureOr<dynamic> getBundleLabel({
    required String iccid,
    required String label,
  });

  FutureOr<dynamic> getMyEsims();

  FutureOr<dynamic> getMyEsimByIccID({
    required String iccID,
  });

  FutureOr<dynamic> getMyEsimByOrder({
    required String orderID,
    String? bearerToken,
  });

  FutureOr<dynamic> getRelatedTopUp({
    required String iccID,
    required String bundleCode,
  });

  FutureOr<dynamic> getOrderHistory({
    required int pageIndex,
    required int pageSize,
  });

  FutureOr<dynamic> getOrderByID({
    required String orderID,
  });

  FutureOr<dynamic> topUpWallet({
    required double amount,
    required String currency,
  });

  FutureOr<dynamic> cancelOrder({
    required String orderID,
  });

  FutureOr<dynamic> resendOrderOtp({
    required String orderID,
  });

  FutureOr<dynamic> verifyOrderOtp({
    required String otp,
    required String iccid,
    required String orderID,
  });
}
