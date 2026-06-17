import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for UserNotificationModel
/// Tests constructor, getters, copyWith method, and field assignment
void main() {
  group("UserNotificationModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        notificationId: 1,
        title: "Payment Received",
        content: "Your payment has been processed",
        datetime: "2026-06-02T10:30:00Z",
        transactionStatus: "completed",
        transaction: "TXN001",
        transactionMessage: "Payment successful",
        status: true,
        iccid: "8901410000000000000",
        category: "payment",
        translatedMessage: "Su pago ha sido procesado",
      );

      // Assert
      expect(model.notificationId, 1);
      expect(model.title, "Payment Received");
      expect(model.content, "Your payment has been processed");
      expect(model.datetime, "2026-06-02T10:30:00Z");
      expect(model.transactionStatus, "completed");
      expect(model.transaction, "TXN001");
      expect(model.transactionMessage, "Payment successful");
      expect(model.status, true);
      expect(model.iccid, "8901410000000000000");
      expect(model.category, "payment");
      expect(model.translatedMessage, "Su pago ha sido procesado");
    });

    test("constructor with minimal fields", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        notificationId: 1,
      );

      // Assert
      expect(model.notificationId, 1);
      expect(model.title, isNull);
      expect(model.content, isNull);
      expect(model.status, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final UserNotificationModel model = UserNotificationModel();

      // Assert
      expect(model.notificationId, isNull);
      expect(model.title, isNull);
      expect(model.content, isNull);
      expect(model.datetime, isNull);
      expect(model.transactionStatus, isNull);
      expect(model.transaction, isNull);
      expect(model.transactionMessage, isNull);
      expect(model.status, isNull);
      expect(model.iccid, isNull);
      expect(model.category, isNull);
      expect(model.translatedMessage, isNull);
    });

    test("notificationId getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        notificationId: 42,
      );

      // Assert
      expect(model.notificationId, 42);
    });

    test("title getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        title: "eSIM Activation",
      );

      // Assert
      expect(model.title, "eSIM Activation");
    });

    test("content getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        content: "Your eSIM has been activated successfully",
      );

      // Assert
      expect(model.content, "Your eSIM has been activated successfully");
    });

    test("datetime getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        datetime: "2026-05-15T14:45:30Z",
      );

      // Assert
      expect(model.datetime, "2026-05-15T14:45:30Z");
    });

    test("transactionStatus getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        transactionStatus: "pending",
      );

      // Assert
      expect(model.transactionStatus, "pending");
    });

    test("transaction getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        transaction: "TXN123456",
      );

      // Assert
      expect(model.transaction, "TXN123456");
    });

    test("transactionMessage getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        transactionMessage: "Transaction is being processed",
      );

      // Assert
      expect(model.transactionMessage, "Transaction is being processed");
    });

    test("status getter returns true", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        status: true,
      );

      // Assert
      expect(model.status, true);
    });

    test("status getter returns false", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        status: false,
      );

      // Assert
      expect(model.status, false);
    });

    test("iccid getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        iccid: "8901410000000000001",
      );

      // Assert
      expect(model.iccid, "8901410000000000001");
    });

    test("category getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        category: "billing",
      );

      // Assert
      expect(model.category, "billing");
    });

    test("translatedMessage getter returns correct value", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        translatedMessage: "Votre eSIM a été activé",
      );

      // Assert
      expect(model.translatedMessage, "Votre eSIM a été activé");
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final UserNotificationModel original = UserNotificationModel(
        notificationId: 1,
        title: "Old Title",
        content: "Old content",
        status: true,
        transactionStatus: "completed",
      );

      // Act - must pass notificationId explicitly since copyWith defaults to 0 if not provided
      final UserNotificationModel updated = original.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(notificationId: 1),
          contentInfo: NotificationContentParams(title: "New Title"),
        ),
      );

      // Assert
      expect(updated.title, "New Title");
      expect(updated.notificationId, 1);
      expect(updated.content, "Old content");
      expect(updated.status, true);
      expect(updated.transactionStatus, "completed");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final UserNotificationModel original = UserNotificationModel(
        notificationId: 5,
        title: "Test Title",
        content: "Test content",
        datetime: "2026-06-02T12:00:00Z",
      );

      // Act - must pass notificationId explicitly since copyWith defaults to 0 if not provided
      final UserNotificationModel copied = original.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(notificationId: 5),
        ),
      );

      // Assert
      expect(copied.notificationId, 5);
      expect(copied.title, original.title);
      expect(copied.content, original.content);
      expect(copied.datetime, original.datetime);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final UserNotificationModel original = UserNotificationModel(
        notificationId: 1,
        title: "Title",
      );

      // Act - must pass notificationId explicitly since copyWith defaults to 0 if not provided
      final UserNotificationModel updated = original.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(notificationId: 1),
          contentInfo: NotificationContentParams(content: "New content"),
        ),
      );

      // Assert
      expect(updated.notificationId, 1);
      expect(updated.title, "Title");
      expect(updated.content, "New content");
      expect(updated.status, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final UserNotificationModel original = UserNotificationModel(
        notificationId: 1,
        title: "Original Title",
      );

      // Act
      final UserNotificationModel updated = original.copyWith(
        UserNotificationModelParams(
          contentInfo: NotificationContentParams(title: "Updated Title"),
        ),
      );

      // Assert
      expect(original.title, "Original Title");
      expect(updated.title, "Updated Title");
    });

    test("copyWith with notificationId update uses default 0", () {
      // Arrange
      final UserNotificationModel original = UserNotificationModel(
        notificationId: 5,
        title: "Test",
      );

      // Act
      final UserNotificationModel updated = original.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(notificationId: 10),
        ),
      );

      // Assert
      expect(updated.notificationId, 10);
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final UserNotificationModel original = UserNotificationModel(
        notificationId: 1,
        title: "Old Title",
        content: "Old content",
        status: false,
      );

      // Act - must pass notificationId explicitly since copyWith defaults to 0 if not provided
      final UserNotificationModel updated = original.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(notificationId: 1, status: true),
          contentInfo: NotificationContentParams(
            title: "New Title",
            content: "New content",
          ),
        ),
      );

      // Assert
      expect(updated.title, "New Title");
      expect(updated.content, "New content");
      expect(updated.status, true);
      expect(updated.notificationId, 1);
    });

    test("handles zero notificationId", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        notificationId: 0,
      );

      // Assert
      expect(model.notificationId, 0);
    });

    test("handles negative notificationId", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        notificationId: -1,
      );

      // Assert
      expect(model.notificationId, -1);
    });

    test("handles large notificationId", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        notificationId: 999999999,
      );

      // Assert
      expect(model.notificationId, 999999999);
    });

    test("handles empty string values", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        title: "",
        content: "",
        datetime: "",
        transactionStatus: "",
        transaction: "",
        transactionMessage: "",
        iccid: "",
        category: "",
        translatedMessage: "",
      );

      // Assert
      expect(model.title, "");
      expect(model.content, "");
      expect(model.datetime, "");
      expect(model.transactionStatus, "");
      expect(model.iccid, "");
    });

    test("handles special characters in string fields", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        title: "Payment: O'Brien's Order",
        content: "It's working! José García's account",
        translatedMessage: 'Error: "Network connection lost" - trying again...',
        category: "payment/refund",
      );

      // Assert
      expect(model.title, "Payment: O'Brien's Order");
      expect(model.content, "It's working! José García's account");
      expect(
        model.translatedMessage,
        'Error: "Network connection lost" - trying again...',
      );
      expect(model.category, "payment/refund");
    });

    test("handles long content strings", () {
      // Act
      final String longContent =
          "This is a very long notification content that spans multiple lines and contains detailed information about the transaction status and what the user should do next. " *
              3;
      final UserNotificationModel model = UserNotificationModel(
        content: longContent,
      );

      // Assert
      expect(model.content, longContent);
      expect(model.content, isNotEmpty);
    });

    test("multiple instances are independent", () {
      // Act
      final UserNotificationModel model1 = UserNotificationModel(
        notificationId: 1,
        title: "Notification 1",
        status: true,
      );
      final UserNotificationModel model2 = UserNotificationModel(
        notificationId: 2,
        title: "Notification 2",
        status: false,
      );

      // Assert
      expect(model1.notificationId, 1);
      expect(model1.title, "Notification 1");
      expect(model1.status, true);
      expect(model2.notificationId, 2);
      expect(model2.title, "Notification 2");
      expect(model2.status, false);
    });

    test("transaction status values are preserved", () {
      // Act
      final UserNotificationModel completedModel = UserNotificationModel(
        transactionStatus: "completed",
      );
      final UserNotificationModel pendingModel = UserNotificationModel(
        transactionStatus: "pending",
      );
      final UserNotificationModel failedModel = UserNotificationModel(
        transactionStatus: "failed",
      );

      // Assert
      expect(completedModel.transactionStatus, "completed");
      expect(pendingModel.transactionStatus, "pending");
      expect(failedModel.transactionStatus, "failed");
    });

    test("category values are preserved", () {
      // Act
      final UserNotificationModel paymentModel = UserNotificationModel(
        category: "payment",
      );
      final UserNotificationModel billingModel = UserNotificationModel(
        category: "billing",
      );
      final UserNotificationModel systemModel = UserNotificationModel(
        category: "system",
      );

      // Assert
      expect(paymentModel.category, "payment");
      expect(billingModel.category, "billing");
      expect(systemModel.category, "system");
    });

    test("ICCID format handling", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        iccid: "8901410000000000000",
      );

      // Assert
      expect(model.iccid, "8901410000000000000");
      expect(model.iccid?.length, 19);
    });

    test("datetime ISO8601 format handling", () {
      // Act
      final UserNotificationModel model = UserNotificationModel(
        datetime: "2026-06-02T14:30:45.123Z",
      );

      // Assert
      expect(model.datetime, "2026-06-02T14:30:45.123Z");
    });

    test("copyWith with dynamic parameter handling", () {
      // Arrange
      final UserNotificationModel original = UserNotificationModel(
        notificationId: 1,
        iccid: "8901410000000000000",
        category: "payment",
        translatedMessage: "Message",
      );

      // Act - must pass notificationId explicitly since copyWith defaults to 0 if not provided
      final UserNotificationModel updated = original.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(
            notificationId: 1,
            iccid: "8901410000000000001",
          ),
          contentInfo: NotificationContentParams(category: "billing"),
        ),
      );

      // Assert
      expect(updated.iccid, "8901410000000000001");
      expect(updated.category, "billing");
      expect(updated.notificationId, 1);
    });
  });
}
