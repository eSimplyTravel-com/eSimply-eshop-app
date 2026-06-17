class NotificationContentParams {
  NotificationContentParams({
    this.title,
    this.content,
    this.datetime,
    this.category,
    this.translatedMessage,
  });

  final String? title;
  final String? content;
  final String? datetime;
  final String? category;
  final String? translatedMessage;
}

class NotificationTransactionParams {
  NotificationTransactionParams({
    this.transactionStatus,
    this.transaction,
    this.transactionMessage,
  });

  final String? transactionStatus;
  final String? transaction;
  final String? transactionMessage;
}

class NotificationMetaParams {
  NotificationMetaParams({
    this.notificationId,
    this.status,
    this.iccid,
  });

  final int? notificationId;
  final bool? status;
  final String? iccid;
}

class UserNotificationModelParams {
  UserNotificationModelParams({
    this.contentInfo,
    this.transactionInfo,
    this.metaInfo,
  });

  final NotificationContentParams? contentInfo;
  final NotificationTransactionParams? transactionInfo;
  final NotificationMetaParams? metaInfo;
}

class UserNotificationModel {
  UserNotificationModel({
    int? notificationId,
    String? title,
    String? content,
    String? datetime,
    String? transactionStatus,
    String? transaction,
    String? transactionMessage,
    bool? status,
    String? iccid,
    String? category,
    String? translatedMessage,
  }) {
    _notificationId = notificationId;
    _title = title;
    _content = content;
    _datetime = datetime;
    _transactionStatus = transactionStatus;
    _transaction = transaction;
    _transactionMessage = transactionMessage;
    _status = status;
    _iccid = iccid;
    _category = category;
    _translatedMessage = translatedMessage;
  }

  int? _notificationId;
  String? _title;
  String? _content;
  String? _datetime;
  String? _transactionStatus;
  String? _transaction;
  String? _transactionMessage;
  bool? _status;
  String? _iccid;
  String? _category;
  String? _translatedMessage;

  UserNotificationModel copyWith([UserNotificationModelParams? params]) =>
      UserNotificationModel(
        notificationId: params?.metaInfo?.notificationId ?? 0,
        title: params?.contentInfo?.title ?? _title,
        content: params?.contentInfo?.content ?? _content,
        datetime: params?.contentInfo?.datetime ?? _datetime,
        transactionStatus:
            params?.transactionInfo?.transactionStatus ?? _transactionStatus,
        transaction: params?.transactionInfo?.transaction ?? _transaction,
        transactionMessage:
            params?.transactionInfo?.transactionMessage ?? _transactionMessage,
        status: params?.metaInfo?.status ?? _status,
        iccid: params?.metaInfo?.iccid ?? _iccid,
        category: params?.contentInfo?.category ?? _category,
        translatedMessage:
            params?.contentInfo?.translatedMessage ?? _translatedMessage,
      );

  int? get notificationId => _notificationId;
  String? get title => _title;
  String? get content => _content;
  String? get datetime => _datetime;
  String? get transactionStatus => _transactionStatus;
  String? get transaction => _transaction;
  String? get transactionMessage => _transactionMessage;
  bool? get status => _status;
  String? get iccid => _iccid;
  String? get category => _category;
  String? get translatedMessage => _translatedMessage;

}
