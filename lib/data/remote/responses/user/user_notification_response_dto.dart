import "dart:convert";

import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

UserNotificationModelDto userNotificationModelFromJson(String str) =>
    UserNotificationModelDto.fromJson(json: json.decode(str));
String userNotificationModelToJson(UserNotificationModelDto data) =>
    json.encode(data.toJson());

class NotificationContentParamsDto {
  NotificationContentParamsDto({
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

class NotificationTransactionParamsDto {
  NotificationTransactionParamsDto({
    this.transactionStatus,
    this.transaction,
    this.transactionMessage,
  });

  final String? transactionStatus;
  final String? transaction;
  final String? transactionMessage;
}

class NotificationMetaParamsDto {
  NotificationMetaParamsDto({
    this.notificationId,
    this.status,
    this.iccid,
  });

  final int? notificationId;
  final bool? status;
  final String? iccid;
}

class UserNotificationModelParamsDto {
  UserNotificationModelParamsDto({
    this.contentInfo,
    this.transactionInfo,
    this.metaInfo,
  });

  final NotificationContentParamsDto? contentInfo;
  final NotificationTransactionParamsDto? transactionInfo;
  final NotificationMetaParamsDto? metaInfo;
}

class UserNotificationModelDto {
  UserNotificationModelDto({
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

  UserNotificationModelDto.fromJson({dynamic json}) {
    _notificationId = json["notification_id"];
    _title = json["title"];
    _content = json["content"];
    _datetime = json["datetime"];
    _transactionStatus = json["transaction_status"];
    _transaction = json["transaction"];
    _transactionMessage = json["transaction_message"];
    _status = json["status"];
    _iccid = json["iccid"];
    _category = json["category"];
    _translatedMessage = json["translated_message"];
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

  UserNotificationModelDto copyWith([UserNotificationModelParamsDto? params]) =>
      UserNotificationModelDto(
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["notification_id"] = _notificationId;
    map["title"] = _title;
    map["content"] = _content;
    map["datetime"] = _datetime;
    map["transaction_status"] = _transactionStatus;
    map["transaction"] = _transaction;
    map["transaction_message"] = _transactionMessage;
    map["status"] = _status;
    map["iccid"] = _iccid;
    map["category"] = _category;
    map["translated_message"] = _translatedMessage;
    return map;
  }

  static List<UserNotificationModelDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: UserNotificationModelDto.fromJson,
      json: json,
    );
  }

  UserNotificationModel toDomain() {
    UserNotificationModel response = UserNotificationModel(
      notificationId: notificationId,
      title: title,
      content: content,
      datetime: datetime,
      transactionStatus: transactionStatus,
      transaction: transaction,
      transactionMessage: transactionMessage,
      status: status,
      iccid: iccid,
      category: category,
      translatedMessage: translatedMessage,
    );

    return response;
  }
}
