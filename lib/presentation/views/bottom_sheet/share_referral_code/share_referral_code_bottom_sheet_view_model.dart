import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/presentation/shared/deep_link_helper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:share_plus/share_plus.dart";

class ShareReferralCodeBottomSheetViewModel extends BaseModel {
  String get referralCode => userAuthenticationService.referralCode;

  String get deepLink =>
      "https://${AppEnvironment.appEnvironmentHelper.websiteUrl}/${DeepLinkDecodeKeys.referralCode.pathKey}?${DeepLinkDecodeKeys.referralCode.decodingKey}=$referralCode";

  String get amount =>
      locator<ReferralInfoService>().getReferralAmountAndCurrency;

  String get getReferralMessage =>
      locator<ReferralInfoService>().getReferralMessage;

  Future<void> shareButtonTapped() async {
    // Always the plain website link. The Branch short-link path is gone: the SDK
    // was never configured (empty key, disabled in every environment), so it
    // only ever returned an empty string. The website URL is covered by the
    // app's associated domains, so tapping it opens the app when installed.
    final String link = deepLink;

    log(link);

    SharePlus.instance.share(
      ShareParams(
        text: LocaleKeys.shareReferral_fullLinkText.tr(
          namedArgs: <String, String>{
            "amount": amount,
            "code": referralCode,
            "link": link,
          },
        ),
      ),
    );
  }
}
