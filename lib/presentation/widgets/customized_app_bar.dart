import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AppBarParams {
  AppBarParams({
    this.actionList,
    this.leading,
    this.backButtonIcon,
    this.backButtonColor,
    this.statusBarColor,
    this.backgroundColor,
    this.title,
    this.leadingWidthAndroid,
    this.customTitleStyle,
    this.centerTitle = false,
    this.closeFlutterOnBack = false,
    this.removeBackButton = false,
    this.primaryStatusBarColor = false,
    this.isPageVisible = false,
    this.showBorder = false,
    this.onBackPress,
});
  List<Widget>? actionList;
  Widget? leading;
  Icon? backButtonIcon;
  Color? backButtonColor;
  Color? statusBarColor;
  Color? backgroundColor;
  String? title;
  double? leadingWidthAndroid;
  TextStyle? customTitleStyle;
  bool centerTitle;
  bool closeFlutterOnBack;
  bool removeBackButton;
  bool primaryStatusBarColor;
  bool isPageVisible;
  bool showBorder;
  final VoidCallback? onBackPress;
}

PreferredSizeWidget myAppBar(
  BuildContext context, {
  required AppBarParams params,
}) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return _buildIOSAppBar(
      context: context,
      params: params,
    );
  }

  return _buildAndroidAppBar(
    context: context,
    params: params,
  );
}

CupertinoNavigationBar _buildIOSAppBar({
  required BuildContext context,
  required AppBarParams params,
}) {
  return CupertinoNavigationBar(
    border: _buildIOSBorder(context, params.showBorder),
    backgroundColor: params.backgroundColor ?? context.appColors.baseBlack!,
    middle: _buildIOSMiddleWidget(context, params.centerTitle, params.title, params.customTitleStyle),
    leading: _buildIOSLeading(
      context: context,
      params: params,
    ),
    trailing: _buildIOSTrailing(params.actionList),
  );
}

AppBar _buildAndroidAppBar({
  required BuildContext context,
  required AppBarParams params,
}) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    backgroundColor: params.backgroundColor ??
        Theme.of(context).colorScheme.cPrimaryColor(context),
    title: Text(
      params.title ?? "",
      style: params.customTitleStyle ?? headerFourMediumTextStyle(context: context),
    ),
    elevation: params.showBorder ? 1 : 0,
    shadowColor:
        Theme.of(context).colorScheme.cHintTextColor(context).withAlpha(50),
    leadingWidth: _calculateAndroidLeadingWidth(params.removeBackButton, params.leading, params.leadingWidthAndroid),
    actions: params.actionList,
    centerTitle: params.centerTitle,
    leading: _buildAndroidLeading(
      context: context,
      leading: params.leading,
      removeBackButton: params.removeBackButton,
      backButtonIcon: params.backButtonIcon,
      backButtonColor: params.backButtonColor,
      closeFlutterOnBack: params.closeFlutterOnBack,
      onBackPress: params.onBackPress,
    ),
  );
}

Border _buildIOSBorder(BuildContext context, bool showBorder) {
  return Border(
    bottom: BorderSide(
      color: showBorder
          ? Theme.of(context)
              .colorScheme
              .cHintTextColor(context)
              .withAlpha(50)
          : Colors.transparent,
    ),
  );
}

Widget _buildIOSMiddleWidget(
  BuildContext context,
  bool centerTitle,
  String? title,
  TextStyle? customTitleStyle,
) {
  if (!centerTitle || title == null) {
    return Container();
  }

  return Text(
    title,
    style: customTitleStyle ?? headerFourMediumTextStyle(context: context),
  );
}

Row _buildIOSLeading({
  required BuildContext context,
  required AppBarParams params,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _buildIOSBackButton(
        context: context,
        removeBackButton: params.removeBackButton,
        backButtonIcon: params.backButtonIcon,
        backButtonColor: params.backButtonColor,
        closeFlutterOnBack: params.closeFlutterOnBack,
        onBackPress: params.onBackPress,
      ),
      _buildIOSLeadingWidget(
        context: context,
        leading: params.leading,
        centerTitle: params.centerTitle,
        title: params.title,
        customTitleStyle: params.customTitleStyle,
      ),
    ],
  );
}

Widget _buildIOSBackButton({
  required BuildContext context,
  required bool removeBackButton,
  required Icon? backButtonIcon,
  required Color? backButtonColor,
  required bool closeFlutterOnBack,
  required VoidCallback? onBackPress,
}) {
  if (removeBackButton) {
    return Container();
  }

  return Material(
    color: Colors.transparent,
    child: IconButton(
      icon: backButtonIcon ?? const Icon(Icons.arrow_back_ios),
      color: backButtonColor ?? context.appColors.baseWhite,
      iconSize: 17,
      onPressed: () => _handleBackPress(
        context: context,
        onBackPress: onBackPress,
        closeFlutterOnBack: closeFlutterOnBack,
      ),
    ),
  );
}

Widget _buildIOSLeadingWidget({
  required BuildContext context,
  required Widget? leading,
  required bool centerTitle,
  required String? title,
  required TextStyle? customTitleStyle,
}) {
  if (leading != null) {
    return Material(
      color: Colors.transparent,
      child: leading,
    );
  }

  if (!centerTitle && title != null) {
    return Material(
      color: Colors.transparent,
      child: Text(
        title,
        style: customTitleStyle ?? headerFourMediumTextStyle(context: context),
      ),
    );
  }

  return Container();
}

Widget? _buildIOSTrailing(List<Widget>? actionList) {
  if (actionList == null) {
    return null;
  }

  return Material(
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: actionList,
    ),
  );
}

double? _calculateAndroidLeadingWidth(
  bool removeBackButton,
  Widget? leading,
  double? leadingWidthAndroid,
) {
  if (removeBackButton && leading == null) {
    return 0;
  }
  return leadingWidthAndroid;
}

Widget? _buildAndroidLeading({
  required BuildContext context,
  required Widget? leading,
  required bool removeBackButton,
  required Icon? backButtonIcon,
  required Color? backButtonColor,
  required bool closeFlutterOnBack,
  required VoidCallback? onBackPress,
}) {
  if (leading != null) {
    return leading;
  }

  if (removeBackButton) {
    return Container();
  }

  return IconButton(
    icon: backButtonIcon ?? const Icon(Icons.arrow_back_ios),
    color: backButtonColor ??
        Theme.of(context).colorScheme.cNavigationActionsColor(context),
    iconSize: 20,
    onPressed: () => _handleBackPress(
      context: context,
      onBackPress: onBackPress,
      closeFlutterOnBack: closeFlutterOnBack,
    ),
  );
}

void _handleBackPress({
  required BuildContext context,
  required VoidCallback? onBackPress,
  required bool closeFlutterOnBack,
}) {
  if (onBackPress != null) {
    onBackPress.call();
    return;
  }

  if (closeFlutterOnBack) {
    SystemNavigator.pop();
  } else {
    Navigator.pop(context);
  }
}

@AppPreview(name: "Customized App Bar")
Widget myAppBarPreview() {
  return Builder(
    builder: (BuildContext context) => Scaffold(
      appBar: myAppBar(
        context,
        params: AppBarParams(
          title: "Sample Title",
          centerTitle: true,
          showBorder: true,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text("App bar preview content"),
      ),
    ),
  );
}
