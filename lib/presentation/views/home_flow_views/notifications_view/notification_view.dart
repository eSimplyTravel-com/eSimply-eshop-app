import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class NotificationView extends StatelessWidget {
  const NotificationView({
    required this.notificationsModel,
    super.key,
  });
  final UserNotificationModel notificationsModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.appColors.grey_200!,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Badge(
              isLabelVisible: !(notificationsModel.status ?? false),
              backgroundColor: notificationBadgeColor(context: context),
            ),
          ),
          verticalSpaceTiny,
          Text(
            notificationsModel.title ?? "N/A",
            style: bodyNormalTextStyle(
              context: context,
              fontColor: titleTextColor(context: context),
            ),
          ),
          verticalSpaceSmall,
          Text(
            DateTimeUtils.formatTimestampToDate(
              timestamp: int.parse(notificationsModel.datetime ?? "0"),
              format: DateTimeUtils.ddMmYyyy,
            ),
            style: captionTwoNormalTextStyle(
              context: context,
              fontColor: contentTextColor(context: context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<UserNotificationModel>(
        "notificationsModel",
        notificationsModel,
      ),
    );
  }
}
