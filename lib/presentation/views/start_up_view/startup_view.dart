import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/start_up_view/startup_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:stacked/stacked.dart";

class StartUpView extends HookWidget {
  const StartUpView({super.key});

  static const String routeName = "StartUpView";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => locator<StartUpViewModel>(),
      onViewModelReady: (StartUpViewModel model) async =>
          model.handleStartUpLogic(context),
      builder: (BuildContext context, StartUpViewModel model, Widget? child) =>
          Scaffold(
        backgroundColor: context.appColors.baseNavy,
        body: Center(
          child: SizedBox(
            width: screenWidth(context) / 3,
            child: Image.asset(
              EnvironmentImages.splashIcon.fullImagePath,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
