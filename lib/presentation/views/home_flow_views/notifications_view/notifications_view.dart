import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notification_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_paginated_state_list_view.dart";
import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  static const String routeName = "NotificationsView";

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(
      routeName: routeName,
      hideAppBar: true,
      hideLoader: true,
      disposeViewModel: true,
      enableBottomSafeArea: false,
      viewModel: locator<NotificationsViewModel>(),
      builder: (
        BuildContext context,
        NotificationsViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        return SizedBox(
          height: double.infinity,
          child: PaddingWidget.applyPadding(
            top: 20,
            child: Column(
              children: <Widget>[
                CommonNavigationTitle(
                  navigationTitle: LocaleKeys.notificationView_title.tr(),
                  textStyle: headerTwoBoldTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ),
                ),
                Expanded(
                  child: PaddingWidget.applySymmetricPadding(
                    vertical: 25,
                    horizontal: 15,
                    child: EmptyPaginatedStateListView<UserNotificationModel>(
                      emptyStateWidget: EmptyStateWidget(
                        content: LocaleKeys.notificationView_emptyTitle.tr(),
                        imagePath:
                            EnvironmentImages.emptyNotifications.fullImagePath,
                      ),
                      paginationService:
                          viewModel.notificationPaginationService,
                      onRefresh: viewModel.refreshNotifications,
                      onLoadItems: viewModel.getNotifications,
                      separatorBuilder: (BuildContext context, int index) =>
                          verticalSpaceSmallMedium,
                      builder: (UserNotificationModel item) {
                        return GestureDetector(
                          onTap: () => viewModel.onNotificationCLicked(item),
                          child: NotificationView(
                            notificationsModel: item,
                          ).applyShimmer(
                            params: ShimmerParams(context: context,
                            enable: viewModel.isBusy,),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
