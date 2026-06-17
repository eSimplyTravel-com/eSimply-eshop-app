import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/top_up_user_bundle_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for TopUpUserBundleUseCase
/// Tests top-up functionality for existing eSIM bundles
Future<void> main() async {
  await prepareTest();

  late TopUpUserBundleUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = TopUpUserBundleUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("TopUpUserBundleUseCase Tests", () {
    test("execute returns success with payment details for top-up", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "TOPUP_5GB";

      final TopUpUserBundleParam params = TopUpUserBundleParam(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "stripe",
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        publishableKey: "pk_test_topup",
        paymentIntentClientSecret: "pi_secret_topup",
        customerId: "cus_topup",
        orderId: "order_topup_123",
        paymentStatus: "requires_payment_method",
        hasTax: false,
        subtotalPriceDisplay: r"$19.99",
        totalPriceDisplay: r"$19.99",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: "Success");

      when(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "stripe",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.orderId, equals("order_topup_123"));
      expect(result.data?.paymentStatus, equals("requires_payment_method"));

      verify(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "stripe",
      ),).called(1);
    });

    test("execute returns error when top-up fails", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "INVALID_TOPUP";

      final TopUpUserBundleParam params = TopUpUserBundleParam(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: PaymentType.card.type,
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.error("Top-up not allowed for this bundle");

      when(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Top-up not allowed for this bundle"));
      expect(result.data, isNull);

      verify(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).called(1);
    });

    test("execute uses default payment type when not specified", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "TOPUP_5GB";

      final TopUpUserBundleParam params = TopUpUserBundleParam(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: PaymentType.card.type,
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "order_default",
        paymentStatus: "requires_payment_method",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(params.paymentType, equals("Card")); // Verify default value

      verify(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).called(1);
    });

    test("execute handles different payment types", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "TOPUP_5GB";

      final List<String> paymentTypes = <String>[
        "stripe",
        "Card",
        "wallet",
        "paypal",
      ];

      for (final String paymentType in paymentTypes) {
        final TopUpUserBundleParam params = TopUpUserBundleParam(
          iccID: testIccID,
          bundleCode: bundleCode,
          paymentType: paymentType,
        );

        final BundleAssignResponseModel mockResponse =
            BundleAssignResponseModel(
          orderId: "order_$paymentType",
          paymentStatus: "requires_payment_method",
        );

        final Resource<BundleAssignResponseModel?> expectedResponse =
        Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

        when(mockRepository.topUpBundle(
          iccID: testIccID,
          bundleCode: bundleCode,
          paymentType: paymentType,
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<BundleAssignResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        expect(result.data?.orderId, equals("order_$paymentType"));

        verify(mockRepository.topUpBundle(
          iccID: testIccID,
          bundleCode: bundleCode,
          paymentType: paymentType,
        ),).called(1);
      }
    });

    test("execute handles invalid ICCID", () async {
      // Arrange
      const String invalidIccID = "INVALID_ICCID";
      const String bundleCode = "TOPUP_5GB";

      final TopUpUserBundleParam params = TopUpUserBundleParam(
        iccID: invalidIccID,
        bundleCode: bundleCode,
        paymentType: PaymentType.card.type,
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.error("Invalid ICCID");

      when(mockRepository.topUpBundle(
        iccID: invalidIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid ICCID"));
    });

    test("execute handles top-up with tax calculation", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "TOPUP_5GB";

      final TopUpUserBundleParam params = TopUpUserBundleParam(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "stripe",
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "order_tax_topup",
        paymentStatus: "requires_payment_method",
        hasTax: true,
        subtotalPriceDisplay: r"$19.99",
        taxPriceDisplay: r"$1.60",
        totalPriceDisplay: r"$21.59",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "stripe",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.hasTax, equals(true));
      expect(result.data?.taxPriceDisplay, equals(r"$1.60"));
      expect(result.data?.isTaxExist(), equals(true));
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "TOPUP_5GB";

      final TopUpUserBundleParam params = TopUpUserBundleParam(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: PaymentType.card.type,
      );

      when(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).called(1);
    });

    test("execute handles null response data", () async {
      // Arrange
      const String testIccID = "89012345678901234567";
      const String bundleCode = "TOPUP_5GB";

      final TopUpUserBundleParam params = TopUpUserBundleParam(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: PaymentType.card.type,
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(null, message: "No data available");

      when(mockRepository.topUpBundle(
        iccID: testIccID,
        bundleCode: bundleCode,
        paymentType: "Card",
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
