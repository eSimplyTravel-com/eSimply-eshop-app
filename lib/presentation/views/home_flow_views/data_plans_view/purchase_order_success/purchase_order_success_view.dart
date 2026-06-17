import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_order_success/purchase_order_success_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_divider_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/circular_icon_button.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";

class PurchaseOrderSuccessView extends StatelessWidget {
  const PurchaseOrderSuccessView({required this.purchaseESimBundle, super.key});

  static const String routeName = "PurchaseOrderSuccessView";
  final PurchaseEsimBundleResponseModel? purchaseESimBundle;

  @override
  Widget build(BuildContext context) {
    return BaseView<PurchaseOrderSuccessViewModel>(
      routeName: routeName,
      hideAppBar: true,
      viewModel: locator<PurchaseOrderSuccessViewModel>()
        ..purchaseESimBundle = purchaseESimBundle,
      builder: (
        BuildContext context,
        PurchaseOrderSuccessViewModel viewModel,
        Widget? staticChild,
        double screenHeight,
      ) {
        return PaddingWidget.applySymmetricPadding(
          vertical: 15,
          horizontal: 20,
          child: Column(
            children: <Widget>[
              BottomSheetCloseButton(
                onTap: viewModel.onBackPressed,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    //qr code details title
                    buildTopHeader(context, viewModel),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            verticalSpaceSmall,
                            buildTextComponent(context, viewModel),
                            verticalSpaceSmall,
                            buildQrCode(context, viewModel),
                            verticalSpaceSmallMedium,
                            buildActionButtons(context, viewModel),
                            verticalSpaceSmallMedium,
                            buildInfoRow(
                              context: context,
                              label: LocaleKeys.smdp_address.tr(),
                              value: viewModel.state.smDpAddress,
                              isLoading: viewModel.isBusy,
                              onCopyClicked: () async {
                                viewModel.copyToClipboard(
                                  viewModel.state.smDpAddress,
                                );
                              },
                            ),
                            verticalSpaceSmall,
                            buildInfoRow(
                              context: context,
                              label: LocaleKeys.activation_code.tr(),
                              value: viewModel.state.activationCode,
                              isLoading: viewModel.isBusy,
                              onCopyClicked: () async {
                                viewModel.copyToClipboard(
                                  viewModel.state.activationCode,
                                );
                              },
                            ),
                            verticalSpaceMedium,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              viewModel.state.showGoToMyEsimButton
                  ? MainButton.emptyBackground(
                      params: MainButtonParams(
                        title: LocaleKeys.gotoMyESim.tr(),
                        onPressed: viewModel.onGotoMyESimClick,
                        hideShadows: true,
                        borderColor: greyBackGroundColor(context: context),
                        themeColor: mainDarkTextColor(context: context),
                      ),
                    )
                  : Container(),
              viewModel.state.showInstallButton
                  ? Column(
                      children: <Widget>[
                        verticalSpaceSmall,
                        MainButton(
                          isEnabled: !viewModel.isBusy,
                          title: LocaleKeys.install.tr(),
                          titleTextStyle: bodyBoldTextStyle(context: context),
                          onPressed: viewModel.onInstallClick,
                          themeColor: themeColor,
                          height: 53,
                          hideShadows: true,
                          enabledTextColor:
                              enabledMainButtonTextColor(context: context),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget buildTopHeader(
    BuildContext context,
    PurchaseOrderSuccessViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.asset(
              EnvironmentImages.compatibleIcon.fullImagePath,
              width: 60,
              height: 60,
            ),
            verticalSpaceMedium,
            Text(
              LocaleKeys.payment_success.tr(),
              style: headerThreeMediumTextStyle(
                context: context,
                fontColor: mainDarkTextColor(context: context),
              ),
            ),
            verticalSpaceSmall,
            const BundleDivider(
              verticalPadding: 0,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTextComponent(
    BuildContext context,
    PurchaseOrderSuccessViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        Text(
          LocaleKeys.the_qr_code_was_sent.tr(),
          textAlign: TextAlign.center,
          style: captionOneMediumTextStyle(
            context: context,
            fontColor: secondaryTextColor(context: context),
          ),
        ),
        verticalSpaceSmall,
        MainButton.emptyBackground(
          params: MainButtonParams(
            width: 200,
            hideShadows: true,
            title: LocaleKeys.check_user_guide.tr(),
            onPressed: viewModel.onUserGuideClick,
            themeColor: userGuideButtonColor(context: context),
          ),
        ),
      ],
    );
  }

  Widget buildQrCode(
    BuildContext context,
    PurchaseOrderSuccessViewModel viewModel,
  ) {
    return SizedBox(
      height: 180,
      child: RepaintBoundary(
        key: viewModel.state.globalKey,
        child: QrImageView(
          backgroundColor: context.appColors.baseWhite!,
          data: viewModel.state.qrCodeValue,
          size: 180,
        ),
      ),
    );
  }

  Widget buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required bool isLoading,
    required void Function() onCopyClicked,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: captionOneMediumTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ),
              verticalSpaceTiniest,
              Text(
                value.isEmpty && isLoading ? "------------" : value,
                style: captionTwoNormalTextStyle(
                  context: context,
                  fontColor: contentTextColor(context: context),
                ),
                maxLines: 2,
              ).applyShimmer(
                params: ShimmerParams(context: context, enable: isLoading),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.copy,
            size: 20,
            color: secondaryIconButtonColor(context: context),
          ).applyShimmer(
            params: ShimmerParams(
              context: context,
              enable: isLoading,
              borderRadius: 30,
            ),
          ),
          onPressed: onCopyClicked,
        ),
      ],
    );
  }

  Widget buildActionButtons(
    BuildContext context,
    PurchaseOrderSuccessViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularIconButton(
          icon: Icons.share_outlined,
          onPressed: viewModel.onShareClick,
          backgroundColor: myEsimIconButtonColor(context: context),
          iconColor: enabledMainButtonTextColor(context: context),
        ),
        horizontalSpaceSmall,
        AppEnvironment.isFromAppClip
            ? Container()
            : CircularIconButton(
                icon: Icons.file_download_outlined,
                onPressed: viewModel.onDownloadClick,
                backgroundColor: myEsimIconButtonColor(context: context),
                iconColor: enabledMainButtonTextColor(context: context),
              ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<PurchaseEsimBundleResponseModel?>(
        "purchaseESimBundle",
        purchaseESimBundle,
      ),
    );
  }
}
