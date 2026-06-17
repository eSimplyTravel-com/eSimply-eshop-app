import "package:esim_open_source/data/remote/responses/user/user_notification_response_dto.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("UserNotificationModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "notification_id": 123,
        "title": "Test Notification",
        "content": "Test content",
        "datetime": "2024-01-01",
        "transaction_status": "completed",
        "transaction": "trans-123",
        "transaction_message": "Success",
        "status": true,
        "iccid": "iccid-456",
        "category": "info",
        "translated_message": "Translated message",
      };

      // Act
      final UserNotificationModelDto model =
          UserNotificationModelDto.fromJson(json: json);

      // Assert
      expect(model.notificationId, 123);
      expect(model.title, "Test Notification");
      expect(model.content, "Test content");
      expect(model.datetime, "2024-01-01");
      expect(model.transactionStatus, "completed");
      expect(model.transaction, "trans-123");
      expect(model.transactionMessage, "Success");
      expect(model.status, true);
      expect(model.iccid, "iccid-456");
      expect(model.category, "info");
      expect(model.translatedMessage, "Translated message");
    });

    test("constructor assigns values correctly", () {
      // Act
      final UserNotificationModelDto model = UserNotificationModelDto(
        notificationId: 456,
        title: "Another Notification",
        content: "Another content",
        datetime: "2024-02-01",
        transactionStatus: "pending",
        transaction: "trans-456",
        transactionMessage: "Pending",
        status: false,
        iccid: "iccid-789",
        category: "alert",
        translatedMessage: "Another translated message",
      );

      // Assert
      expect(model.notificationId, 456);
      expect(model.title, "Another Notification");
      expect(model.content, "Another content");
      expect(model.datetime, "2024-02-01");
      expect(model.transactionStatus, "pending");
      expect(model.transaction, "trans-456");
      expect(model.transactionMessage, "Pending");
      expect(model.status, false);
      expect(model.iccid, "iccid-789");
      expect(model.category, "alert");
      expect(model.translatedMessage, "Another translated message");
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final UserNotificationModelDto model = UserNotificationModelDto(
        notificationId: 123,
        title: "Test",
        content: "Content",
        datetime: "2024-01-01",
        transactionStatus: "completed",
        transaction: "trans-123",
        transactionMessage: "Success",
        status: true,
        iccid: "iccid-456",
        category: "info",
        translatedMessage: "Translated",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["notification_id"], 123);
      expect(json["title"], "Test");
      expect(json["content"], "Content");
      expect(json["datetime"], "2024-01-01");
      expect(json["transaction_status"], "completed");
      expect(json["transaction"], "trans-123");
      expect(json["transaction_message"], "Success");
      expect(json["status"], true);
      expect(json["iccid"], "iccid-456");
      expect(json["category"], "info");
      expect(json["translated_message"], "Translated");
    });

    test("copyWith creates new instance with updated values", () {
      // Arrange
      final UserNotificationModelDto original = UserNotificationModelDto(
        notificationId: 123,
        title: "Original",
      );

      // Act
      final UserNotificationModelDto copied = original.copyWith(
        UserNotificationModelParamsDto(
          contentInfo: NotificationContentParamsDto(
            title: "Updated",
            content: "New content",
          ),
        ),
      );

      // Assert
      expect(copied.notificationId, 0);
      expect(copied.title, "Updated");
      expect(copied.content, "New content");
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{
          "notification_id": 1,
          "title": "Notification 1",
        },
        <String, dynamic>{
          "notification_id": 2,
          "title": "Notification 2",
        },
      ];

      // Act
      final List<UserNotificationModelDto> models =
          UserNotificationModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].notificationId, 1);
      expect(models[1].notificationId, 2);
    });
  });
}
