import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/theme/color_templates/open_source_color_template.dart";
import "package:esim_open_source/presentation/theme/color_templates/template_app_colors.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart";

class BodyStateWrapParams {
  BodyStateWrapParams({
    required this.context,
    required this.model,
    required this.child,
    this.noDataWidget,
    this.onBackPressed,
    this.backgroundColor,
    this.loaderColor,
    this.hideLoader = false,
    this.disableInteractionWhileBusy = true,
  });

  final BuildContext context;
  final BaseModel model;
  final Widget child;
  final Widget? noDataWidget;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? loaderColor;
  final bool hideLoader;
  final bool disableInteractionWhileBusy;
}

Widget wrapBodyWithState({
  required BodyStateWrapParams params,
}) {
  switch (params.model.viewState) {
    case ViewState.busy:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          params.onBackPressed?.call();
        },
        child: _getLoadingUi(
          params.context,
          params.child,
          params.loaderColor,
          params.hideLoader,
          params.disableInteractionWhileBusy,
        ),
      );
    case ViewState.noDataAvailable:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          params.onBackPressed?.call();
        },
        child: params.noDataWidget ?? _noDataUi(params.context, params.model),
      );
    case ViewState.error:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          params.onBackPressed?.call();
        },
        child: _errorUi(params.context, params.model),
      );
    case ViewState.dataFetched:
    case ViewState.idle:
    default:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          params.onBackPressed?.call();
        },
        child: params.child,
      );
  }
}

Widget _getLoadingUi(
  BuildContext context,
  Widget child,
  Color? loaderColor,
  bool hideLoader,
  bool disableInteractionWhileBusy,
) {
  // https://stackoverflow.com/questions/55430842/flutter-absorbpointer-vs-ignorepointer-difference
  return Stack(
    fit: StackFit.passthrough, // Makes Stack size to the first child
    clipBehavior: Clip.none, // Allows _LoadingView to overflow if needed
    children: <Widget>[
      // The first child defines the Stack size
      disableInteractionWhileBusy ? IgnorePointer(child: child) : child,

      // The loader is positioned over the first child without affecting size
      if (!hideLoader)
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            child: const _LoadingView(),
          ),
        ),
    ],
  );
}

Widget _noDataUi(BuildContext context, BaseModel model) {
  return _getCenteredViewMessage(
    context,
    LocaleKeys.noDataAvailableYet.tr(),
    model,
  );
}

Widget _errorUi(BuildContext context, BaseModel model) {
  return _getCenteredViewMessage(
    context,
    LocaleKeys.errorRetrievingYourData.tr(),
    model,
    error: true,
  );
}

Widget _getCenteredViewMessage(
  BuildContext context,
  String message,
  BaseModel model, {
  bool error = false,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          error
              ? const Icon(
                  // WWrap in gesture detector and call you refresh future here
                  Icons.refresh,
                  color: Colors.white,
                  size: 45,
                )
              : Container(),
        ],
      ),
    ),
  );
}

class _LoadingView extends HookWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    // final animationController = useAnimationController();

    return Center(
      child: SizedBox(
        width: 35,
        height: 35,
        child: getNativeIndicator(context),
      ),
    );
  }
}

Widget getNativeIndicator(BuildContext context) {
  if (Platform.isIOS) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        context.appColors.primary_900!,
        BlendMode.srcATop,
      ),
      child: const CupertinoActivityIndicator(
        radius: 15,
      ),
    );
  }
  return CircularProgressIndicator(
    strokeWidth: 3,
    color: context.appColors.primary_900,
  );
}

void setDefaultStatusBarColor() {
  TemplateAppColors templateAppColors = OpenSourceColorTemplate();

  // switch (AppEnvironment.appEnvironmentHelper.environmentTheme) {
  //   case EnvironmentTheme.openSource:
  //     templateAppColors = OpenSourceColorTemplate();
  // }
  // check in xcode info.plist (View controller-based status bar appearance) should be YES
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: templateAppColors.defBaseBlack,
      statusBarIconBrightness: Brightness.light, // for Android
      statusBarBrightness: Brightness.light, // for iOS (this is the inverse)
    ),
  );
}
