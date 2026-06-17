import "package:esim_open_source/domain/data/response/account/account_model.dart";
import "package:esim_open_source/presentation/reactive_service/user_service.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";

/// Unit tests for UserService - a reactive service that manages account list state
///
/// Tests cover:
/// - Service initialization with reactive values
/// - Account list getter and setter
/// - Listener notification on state changes
/// - Null handling for account list
Future<void> main() async {
  await prepareTest();

  late UserService userService;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    userService = UserService();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("UserService Initialization Tests", () {
    test("initializes with null accountList", () {
      // Assert
      expect(userService.accountList, isNull);
    });

    test("creates service with ListenableServiceMixin", () {
      // Assert
      expect(userService, isA<UserService>());
    });
  });

  group("UserService Account List Management Tests", () {
    test("sets and retrieves account list successfully", () {
      // Arrange
      final List<AccountModel> testAccounts = <AccountModel>[
        AccountModel(
          recordGuid: "guid-1",
          accountNumber: "ACC001",
          currentBalance: 100.0,
          previousBalance: 90.0,
          lockedBalance: 0.0,
          previousLockedBalance: 0.0,
          currencyCode: "USD",
          accountTypeTag: "PREPAID",
          isPrimary: true,
        ),
        AccountModel(
          recordGuid: "guid-2",
          accountNumber: "ACC002",
          currentBalance: 50.0,
          previousBalance: 40.0,
          lockedBalance: 10.0,
          previousLockedBalance: 5.0,
          currencyCode: "EUR",
          accountTypeTag: "POSTPAID",
          isPrimary: false,
        ),
      ];

      // Act
      userService.accountList = testAccounts;

      // Assert
      expect(userService.accountList, isNotNull);
      expect(userService.accountList, equals(testAccounts));
      expect(userService.accountList?.length, equals(2));
      expect(userService.accountList?[0].accountNumber, equals("ACC001"));
      expect(userService.accountList?[1].accountNumber, equals("ACC002"));
    });

    test("sets account list to null successfully", () {
      // Arrange
      final List<AccountModel> testAccounts = <AccountModel>[
        AccountModel(accountNumber: "ACC001"),
      ];
      userService.accountList = testAccounts;
      expect(userService.accountList, isNotNull);

      // Act
      userService.accountList = null;

      // Assert
      expect(userService.accountList, isNull);
    });

    test("updates account list multiple times correctly", () {
      // Arrange
      final List<AccountModel> firstBatch = <AccountModel>[
        AccountModel(accountNumber: "ACC001"),
      ];
      final List<AccountModel> secondBatch = <AccountModel>[
        AccountModel(accountNumber: "ACC002"),
        AccountModel(accountNumber: "ACC003"),
      ];

      // Act & Assert - First update
      userService.accountList = firstBatch;
      expect(userService.accountList?.length, equals(1));

      // Act & Assert - Second update
      userService.accountList = secondBatch;
      expect(userService.accountList?.length, equals(2));
      expect(userService.accountList?[0].accountNumber, equals("ACC002"));
      expect(userService.accountList?[1].accountNumber, equals("ACC003"));
    });

    test("sets empty list successfully", () {
      // Arrange
      final List<AccountModel> emptyList = <AccountModel>[];

      // Act
      userService.accountList = emptyList;

      // Assert
      expect(userService.accountList, isNotNull);
      expect(userService.accountList, isEmpty);
      expect(userService.accountList?.length, equals(0));
    });
  });

  group("UserService Reactive Behavior Tests", () {
    test("notifies listeners when account list changes", () {
      // Arrange
      int listenerCallCount = 0;
      userService.addListener(() {
        listenerCallCount++;
      });

      final List<AccountModel> testAccounts = <AccountModel>[
        AccountModel(accountNumber: "ACC001"),
      ];

      // Act
      userService.accountList = testAccounts;

      // Assert
      expect(listenerCallCount, equals(1));
    });

    test("notifies listeners when setting null", () {
      // Arrange
      int listenerCallCount = 0;
      userService..accountList = <AccountModel>[
        AccountModel(accountNumber: "ACC001"),
      ]

      ..addListener(() {
        listenerCallCount++;
      })

      // Act
      ..accountList = null;

      // Assert
      expect(listenerCallCount, equals(1));
    });

    test("notifies listeners on multiple updates", () {
      // Arrange
      int listenerCallCount = 0;
      userService..addListener(() {
        listenerCallCount++;
      })

      // Act
      ..accountList = <AccountModel>[AccountModel(accountNumber: "ACC001")]
      ..accountList = <AccountModel>[AccountModel(accountNumber: "ACC002")]
      ..accountList = null;

      // Assert
      expect(listenerCallCount, equals(3));
    });
  });

  group("UserService Account Model Properties Tests", () {
    test("stores account with all properties correctly", () {
      // Arrange
      final AccountModel account = AccountModel(
        recordGuid: "test-guid-123",
        accountNumber: "ACC12345",
        currentBalance: 250.50,
        previousBalance: 200.0,
        lockedBalance: 50.0,
        previousLockedBalance: 30.0,
        currencyCode: "USD",
        accountTypeTag: "PREPAID",
        isPrimary: true,
      );

      // Act
      userService.accountList = <AccountModel>[account];

      // Assert
      final AccountModel? retrievedAccount = userService.accountList?.first;
      expect(retrievedAccount?.recordGuid, equals("test-guid-123"));
      expect(retrievedAccount?.accountNumber, equals("ACC12345"));
      expect(retrievedAccount?.currentBalance, equals(250.50));
      expect(retrievedAccount?.previousBalance, equals(200.0));
      expect(retrievedAccount?.lockedBalance, equals(50.0));
      expect(retrievedAccount?.previousLockedBalance, equals(30.0));
      expect(retrievedAccount?.currencyCode, equals("USD"));
      expect(retrievedAccount?.accountTypeTag, equals("PREPAID"));
      expect(retrievedAccount?.isPrimary, equals(true));
      expect(retrievedAccount?.accountType, equals(AccountsType.prepaid));
    });

    test("handles multiple accounts with different types", () {
      // Arrange
      final List<AccountModel> accounts = <AccountModel>[
        AccountModel(
          accountNumber: "ACC001",
          accountTypeTag: "PREPAID",
          isPrimary: true,
        ),
        AccountModel(
          accountNumber: "ACC002",
          accountTypeTag: "POSTPAID",
          isPrimary: false,
        ),
        AccountModel(
          accountNumber: "ACC003",
          accountTypeTag: "UNKNOWN",
          isPrimary: false,
        ),
      ];

      // Act
      userService.accountList = accounts;

      // Assert
      expect(userService.accountList?[0].accountType, equals(AccountsType.prepaid));
      expect(userService.accountList?[1].accountType, equals(AccountsType.postpaid));
      expect(userService.accountList?[2].accountType, equals(AccountsType.unknown));
    });

    test("handles accounts with null/missing optional properties", () {
      // Arrange
      final AccountModel account = AccountModel();

      // Act
      userService.accountList = <AccountModel>[account];

      // Assert
      final AccountModel? retrievedAccount = userService.accountList?.first;
      expect(retrievedAccount?.recordGuid, isNull);
      expect(retrievedAccount?.accountNumber, isNull);
      expect(retrievedAccount?.currentBalance, isNull);
      expect(retrievedAccount?.currencyCode, isNull);
      expect(retrievedAccount?.isPrimary, isNull);
    });
  });

  group("UserService Edge Cases Tests", () {
    test("handles rapid successive updates", () {
      // Arrange & Act
      for (int i = 0; i < 10; i++) {
        userService.accountList = <AccountModel>[
          AccountModel(accountNumber: "ACC$i"),
        ];
      }

      // Assert
      expect(userService.accountList?.length, equals(1));
      expect(userService.accountList?[0].accountNumber, equals("ACC9"));
    });

    test("maintains reference to the same list instance", () {
      // Arrange
      final List<AccountModel> testList = <AccountModel>[
        AccountModel(accountNumber: "ACC001"),
      ];

      // Act
      userService.accountList = testList;

      // Assert
      expect(identical(userService.accountList, testList), isTrue);
    });

    test("allows modification of retrieved list", () {
      // Arrange
      final List<AccountModel> testList = <AccountModel>[
        AccountModel(accountNumber: "ACC001"),
      ];
      userService.accountList = testList;

      // Act
      testList.add(AccountModel(accountNumber: "ACC002"));

      // Assert
      expect(userService.accountList?.length, equals(2));
    });
  });
}
