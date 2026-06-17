import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/top_up_wallet_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for TopUpWalletUseCase
/// Tests wallet top-up functionality
Future<void> main() async {
  await prepareTest();

  late TopUpWalletUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = TopUpWalletUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("TopUpWalletUseCase Tests", () {
    test("execute returns success with payment details", () async {
      // Arrange
      final TopUpWalletParam params = TopUpWalletParam(
        amount: 50,
        currencyCode: "USD",
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        publishableKey: "pk_test_wallet",
        paymentIntentClientSecret: "pi_wallet_secret",
        customerId: "cus_wallet",
        orderId: "wallet_topup_123",
        paymentStatus: "requires_payment_method",
        hasTax: false,
        subtotalPriceDisplay: r"$50.00",
        totalPriceDisplay: r"$50.00",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: "Success");

      when(mockRepository.topUpWallet(
        amount: 50,
        currency: "USD",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.orderId, equals("wallet_topup_123"));
      expect(result.data?.totalPriceDisplay, equals(r"$50.00"));

      verify(mockRepository.topUpWallet(
        amount: 50,
        currency: "USD",
      ),).called(1);
    });

    test("execute returns error when top-up fails", () async {
      // Arrange
      final TopUpWalletParam params = TopUpWalletParam(
        amount: 10,
        currencyCode: "USD",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.error(r"Minimum top-up amount is $20");

      when(mockRepository.topUpWallet(
        amount: 10,
        currency: "USD",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals(r"Minimum top-up amount is $20"));
      expect(result.data, isNull);

      verify(mockRepository.topUpWallet(
        amount: 10,
        currency: "USD",
      ),).called(1);
    });

    test("execute handles different currencies", () async {
      // Arrange
      final List<Map<String, dynamic>> testCases = <Map<String, dynamic>>[
        <String, dynamic>{"amount": 50.0, "currency": "USD"},
        <String, dynamic>{"amount": 45.0, "currency": "EUR"},
        <String, dynamic>{"amount": 40.0, "currency": "GBP"},
        <String, dynamic>{"amount": 5000.0, "currency": "JPY"},
      ];

      for (final Map<String, dynamic> testCase in testCases) {
        final double amount = testCase["amount"] as double;
        final String currency = testCase["currency"] as String;

        final TopUpWalletParam params = TopUpWalletParam(
          amount: amount,
          currencyCode: currency,
        );

        final BundleAssignResponseModel mockResponse =
            BundleAssignResponseModel(
          orderId: "wallet_$currency",
          paymentStatus: "requires_payment_method",
        );

        final Resource<BundleAssignResponseModel?> expectedResponse =
        Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

        when(mockRepository.topUpWallet(
          amount: amount,
          currency: currency,
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<BundleAssignResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.orderId, equals("wallet_$currency"));
        verify(mockRepository.topUpWallet(
          amount: amount,
          currency: currency,
        ),).called(1);
      }
    });

    test("execute handles different top-up amounts", () async {
      // Arrange
      final List<double> testAmounts = <double>[20, 50, 100, 500];

      for (final double amount in testAmounts) {
        final TopUpWalletParam params = TopUpWalletParam(
          amount: amount,
          currencyCode: "USD",
        );

        final BundleAssignResponseModel mockResponse =
            BundleAssignResponseModel(
          orderId: "wallet_$amount",
          totalPriceDisplay: "\$$amount",
        );

        final Resource<BundleAssignResponseModel?> expectedResponse =
        Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

        when(mockRepository.topUpWallet(
          amount: amount,
          currency: "USD",
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<BundleAssignResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.totalPriceDisplay, equals("\$$amount"));
        verify(mockRepository.topUpWallet(
          amount: amount,
          currency: "USD",
        ),).called(1);
      }
    });

    test("execute handles top-up with tax", () async {
      // Arrange
      final TopUpWalletParam params = TopUpWalletParam(
        amount: 100,
        currencyCode: "USD",
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "wallet_tax",
        paymentStatus: "requires_payment_method",
        hasTax: true,
        subtotalPriceDisplay: r"$100.00",
        taxPriceDisplay: r"$8.00",
        totalPriceDisplay: r"$108.00",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.topUpWallet(
        amount: 100,
        currency: "USD",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.hasTax, equals(true));
      expect(result.data?.taxPriceDisplay, equals(r"$8.00"));
      expect(result.data?.totalPriceDisplay, equals(r"$108.00"));
      expect(result.data?.isTaxExist(), equals(true));
    });

    test("execute handles repository exception", () async {
      // Arrange
      final TopUpWalletParam params = TopUpWalletParam(
        amount: 50,
        currencyCode: "USD",
      );

      when(mockRepository.topUpWallet(
        amount: 50,
        currency: "USD",
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.topUpWallet(
        amount: 50,
        currency: "USD",
      ),).called(1);
    });

    test("execute handles null response data", () async {
      // Arrange
      final TopUpWalletParam params = TopUpWalletParam(
        amount: 50,
        currencyCode: "USD",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(null, message: "No data available");

      when(mockRepository.topUpWallet(
        amount: 50,
        currency: "USD",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });

    test("execute handles zero amount error", () async {
      // Arrange
      final TopUpWalletParam params = TopUpWalletParam(
        amount: 0,
        currencyCode: "USD",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.error("Amount must be greater than zero");

      when(mockRepository.topUpWallet(
        amount: 0,
        currency: "USD",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Amount must be greater than zero"));
    });
  });
}
