import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/device/device_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/device/register_device_use_case.dart";
import "package:esim_open_source/domain/use_case/user/cancel_order_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:share_plus/share_plus.dart";
import "package:url_launcher/url_launcher.dart";

enum BundleExistsAction {
  close,
  buyNewEsim,
  goToEsim,
}

class NativeButtonParams {
  NativeButtonParams({
    required this.buttonTitle,
    required this.buttonAction,
  });

  final String buttonTitle;
  final VoidCallback buttonAction;
}

class NativeDialogParams {
  NativeDialogParams({
    required this.context,
    this.barrierDismissible = false,
    this.titleText,
    this.contentText,
    this.titleTextStyle,
    this.contentTextStyle,
    this.buttonTitleTextStyle,
    this.buttons = const <NativeButtonParams>[],
  });

  final BuildContext context;
  final bool barrierDismissible;
  final String? titleText;
  final String? contentText;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final TextStyle? buttonTitleTextStyle;
  final List<NativeButtonParams> buttons;
}

class AndroidDialogParams {
  AndroidDialogParams({
    required this.allowAndroidBackAction,
    required this.nativeParams,
  });

  final NativeDialogParams nativeParams;
  final bool allowAndroidBackAction;
}

Future<T?> showNativeDialog<T>({
  required NativeDialogParams params,
}) async {
  return showDialog(
    context: params.context,
    barrierDismissible: params.barrierDismissible,
    builder: (BuildContext context) {
      return Platform.isIOS
          ? _iOSNativeDialog(
              context: context,
              buttons: params.buttons,
              titleText: params.titleText,
              contentText: params.contentText,
              titleTextStyle: params.titleTextStyle,
              contentTextStyle: params.contentTextStyle,
              buttonTitleTextStyle: params.buttonTitleTextStyle,
            )
          : _androidNativeDialog(
              params: AndroidDialogParams(
                nativeParams: params,
                allowAndroidBackAction: params.barrierDismissible,
              ),
            );
    },
  );
}

Widget _iOSNativeDialog({
  required BuildContext context,
  String? titleText,
  String? contentText,
  TextStyle? titleTextStyle,
  TextStyle? contentTextStyle,
  TextStyle? buttonTitleTextStyle,
  List<NativeButtonParams> buttons = const <NativeButtonParams>[],
}) {
  return CupertinoAlertDialog(
    title: titleText == null
        ? null
        : Text(
            titleText,
            style: titleTextStyle ??
                bodyMediumTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
          ),
    content: contentText == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              contentText,
              style: contentTextStyle ??
                  captionOneNormalTextStyle(
                    context: context,
                    fontColor: contentTextColor(context: context),
                  ),
            ),
          ),
    actions: <Widget>[
      ...buttons.map(
        (NativeButtonParams button) => CupertinoDialogAction(
          onPressed: () {
            button.buttonAction();
          },
          child: Text(
            button.buttonTitle,
            style: buttonTitleTextStyle ??
                bodyMediumTextStyle(context: context, fontColor: Colors.blue),
          ),
        ),
      ),
      if (buttons.isNotEmpty && buttons.length > 2) Container(),
    ],
  );
}

Widget _androidNativeDialog({
  required AndroidDialogParams params,
}) {
  return PopScope(
    canPop: params.allowAndroidBackAction,
    child: AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: params.nativeParams.titleText == null
          ? null
          : Text(
              params.nativeParams.titleText ?? "",
              textAlign: TextAlign.center,
              style: params.nativeParams.titleTextStyle ??
                  bodyMediumTextStyle(
                    context: params.nativeParams.context,
                    fontColor:
                        mainDarkTextColor(context: params.nativeParams.context),
                  ),
            ),
      content: params.nativeParams.contentText == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                params.nativeParams.contentText ?? "",
                textAlign: TextAlign.center,
                style: params.nativeParams.contentTextStyle ??
                    captionOneNormalTextStyle(
                      context: params.nativeParams.context,
                      fontColor: contentTextColor(
                        context: params.nativeParams.context,
                      ),
                    ),
              ),
            ),
      actionsPadding: EdgeInsets.zero,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: params.nativeParams.buttons
              .map(
                (NativeButtonParams button) => Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      button.buttonAction();
                    },
                    child: Text(
                      textAlign: TextAlign.center,
                      button.buttonTitle,
                      style: params.nativeParams.buttonTitleTextStyle ??
                          bodyMediumTextStyle(
                            context: params.nativeParams.context,
                            fontColor: Colors.blue,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map(
        (MapEntry<String, String> e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}",
      )
      .join("&");
}

// mailto:<email address>?subject=<subject>&body=<body>
Uri _getEmailLaunchUri(String email, {String? subject, String? body}) => Uri(
      scheme: "mailto",
      path: email,
      query: _encodeQueryParameters(<String, String>{
        "subject": subject ?? "",
        "body": body ?? "",
      }),
    );

Future<bool> openEmail(String email, {String? subject}) {
  return launchUrl(_getEmailLaunchUri("nadimhaberel@gmail.com"));
}

Future<bool> openUrl(String url) async {
  final Uri? uri = Uri.tryParse(url);

  if (uri != null) {
    // bool can = await canLaunchUrl(uri);
    // if(can){
    return launchUrl(uri);
    // }
  }

  return Future<bool>(() => false);
}

Future<bool> openExternalApp({
  required String scheme,
  required String iOSAppId,
  required String packageName,
}) async {
  // https://flutteragency.com/how-to-open-application-from-a-flutter-application/

  bool can = await canLaunchUrl(Uri(scheme: scheme));
  if (can) {
    return launchUrl(Uri(scheme: scheme));
  } else {
    if (Platform.isIOS) {
      return launchUrl(
        Uri.parse("https://itunes.apple.com/app/id$iOSAppId"),
        mode: LaunchMode.externalApplication,
      );
    } else {
      return launchUrl(
        Uri.parse(
          "https://play.google.com/store/apps/details?id=$packageName",
        ),
        mode: LaunchMode.externalApplication,
      );
    }
  }
//   launch("waze://?ll=${latitude},${longitude}&navigate=yes");
// //gmaps
//   canLaunch("comgooglemaps://")
//   launch("comgooglemaps://?saddr=${latitude},${longitude}&directionsmode=driving")
}

// Future<void> launchReview({required String androidAppId, required String iOSAppId}) {
//   return LaunchReview.launch(androidAppId: "", iOSAppId: "");
// }

Future<ShareResult> shareUrl(String textToShare) {
  return SharePlus.instance.share(
    ShareParams(
      text: textToShare,
    ),
  );
}

Future<ShareResult> shareStoreLink({
  required String iOSAppId,
  String subject = "",
}) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  // String version = packageInfo.version;
  // String buildNumber = packageInfo.buildNumber;

  if (Platform.isIOS) {
    return SharePlus.instance.share(
      ShareParams(
        text: "$subject \n\nhttps://itunes.apple.com/app/id$iOSAppId",
      ),
    );
  } else {
    return SharePlus.instance.share(
      ShareParams(
        text:
            "$subject \n\nhttps://play.google.com/store/apps/details?id=$packageName",
      ),
    );
  }

  // try {
  //   launch("market://details?id=" + appPackageName);
  // } on PlatformException catch(e) {
  //   launch("https://play.google.com/store/apps/details?id=" + appPackageName);
  // } finally {
  //   launch("https://play.google.com/store/apps/details?id=" + appPackageName);
  // }
}

Future<void> openWhatsApp({
  required String phoneNumber,
  required String message,
}) async {
  // Format the phone number (remove any non-numeric characters except the + sign)
  final String formattedNumber = phoneNumber.replaceAll(RegExp(r"[^\d+]"), "");

  // Encode the message for URL
  final String encodedMessage = Uri.encodeComponent(message);

  // Create the WhatsApp URL
  final String whatsappUrl =
      "https://wa.me/$formattedNumber?text=$encodedMessage";
  final Uri uri = Uri.parse(whatsappUrl);

  try {
    // First try to launch the WhatsApp app
    final bool appLaunched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    // If app launch fails, open in browser
    if (!appLaunched) {
      await launchUrl(
        uri,
      );
    }
  } on Error {
    // If any error occurs, try opening in browser as fallback
    try {
      await launchUrl(
        uri,
      );
    } on Error catch (e) {
      log("Failed to open WhatsApp: $e");
      // Show an error message to the user
    }
  }
}

Future<void>? registerDevice({
  required String fcmToken,
  required String userGuid,
}) async {
  Resource<DeviceInfoResponseModel?> registerResponse =
      await RegisterDeviceUseCase(locator<ApiDeviceRepository>()).execute(
    RegisterDeviceUseCaseParams(
      fcmToken: fcmToken,
      userGuid: userGuid,
    ),
  );

  switch (registerResponse.resourceType) {
    case ResourceType.success:
      log("Success");
    case ResourceType.error:
      log("Error");
    case ResourceType.loading:
      log("Loading");
  }
}

Future<void> copyText(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  await showToast(
    LocaleKeys.copied_to_clipboard.tr(),
  );
}

Future<void> cancelOrder({required String orderID}) async {
  try {
    CancelOrderUseCase(locator<ApiUserRepository>()).execute(
      CancelOrderUseCaseParams(
        orderID: orderID,
      ),
    );
  } on Object catch (ex) {
    log("Failed to cancel order with error: $ex");
  }
}
