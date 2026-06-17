import "package:esim_open_source/domain/data/request/related_search.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/assign_user_bundle_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for AssignUserBundleUseCase
/// Tests bundle assignment with payment processing
Future<void> main() async {
  await prepareTest();

  late AssignUserBundleUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = AssignUserBundleUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("AssignUserBundleUseCase Tests", () {
    test("execute returns success with payment details", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel(
        region: RegionRequestModel(
          isoCode: "EU",
          regionName: "Europe",
        ),
        countries: <CountriesRequestModel>[
          CountriesRequestModel(
            isoCode: "FRA",
            countryName: "France",
          ),
        ],
      );

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "",
        referralCode: "",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        publishableKey: "pk_test_123",
        paymentIntentClientSecret: "pi_secret_123",
        customerId: "cus_123",
        customerEphemeralKeySecret: "eph_123",
        orderId: "order_123",
        paymentStatus: "requires_payment_method",
        hasTax: false,
        testEnv: true,
        merchantDisplayName: "Test Merchant",
        stripeUrlScheme: "myapp://stripe",
        subtotalPriceDisplay: r"$29.99",
        totalPriceDisplay: r"$29.99",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: "Success");

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.orderId, equals("order_123"));
      expect(result.data?.paymentStatus, equals("requires_payment_method"));
      expect(result.data?.publishableKey, equals("pk_test_123"));

      verify(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).called(1);
    });

    test("execute returns error when bundle assignment fails", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "INVALID_CODE",
        promoCode: "",
        referralCode: "",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.error("Bundle not found");

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Bundle not found"));
      expect(result.data, isNull);

      verify(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).called(1);
    });

    test("execute handles promo code application", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "SUMMER2024",
        referralCode: "",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "order_123",
        paymentStatus: "requires_payment_method",
        hasTax: false,
        subtotalPriceDisplay: r"$24.99",
        totalPriceDisplay: r"$24.99",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.totalPriceDisplay, equals(r"$24.99"));

      verify(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: "SUMMER2024",
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).called(1);
    });

    test("execute handles referral code", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "",
        referralCode: "REF123",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "order_456",
        paymentStatus: "requires_payment_method",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: "REF123",
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).called(1);
    });

    test("execute handles bearer token for authenticated requests", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "",
        referralCode: "",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
        bearerToken: "Bearer token_123",
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "order_789",
        paymentStatus: "requires_payment_method",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: "Bearer token_123",
        relatedSearch: params.relatedSearch,
      ),).called(1);
    });

    test("execute handles assignment with tax", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "",
        referralCode: "",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "order_tax",
        paymentStatus: "requires_payment_method",
        hasTax: true,
        subtotalPriceDisplay: r"$29.99",
        taxPriceDisplay: r"$2.40",
        totalPriceDisplay: r"$32.39",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.hasTax, equals(true));
      expect(result.data?.taxPriceDisplay, equals(r"$2.40"));
      expect(result.data?.totalPriceDisplay, equals(r"$32.39"));
      expect(result.data?.isTaxExist(), equals(true));
    });

    test("execute handles repository exception", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "",
        referralCode: "",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).called(1);
    });

    test("execute handles null response data", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "",
        referralCode: "",
        affiliateCode: "",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(null, message: "No data available");

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });

    test("execute handles affiliate code", () async {
      // Arrange
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel();

      final AssignUserBundleParam params = AssignUserBundleParam(
        bundleCode: "EUROPE_5GB",
        promoCode: "",
        referralCode: "",
        affiliateCode: "AFF999",
        paymentType: "stripe",
        relatedSearch: relatedSearch,
      );

      final BundleAssignResponseModel mockResponse = BundleAssignResponseModel(
        orderId: "order_aff",
        paymentStatus: "requires_payment_method",
      );

      final Resource<BundleAssignResponseModel?> expectedResponse =
      Resource<BundleAssignResponseModel?>.success(mockResponse, message: null);

      when(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: params.affiliateCode,
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<BundleAssignResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.assignBundle(
        bundleCode: params.bundleCode,
        promoCode: params.promoCode,
        referralCode: params.referralCode,
        affiliateCode: "AFF999",
        paymentType: params.paymentType,
        bearerToken: params.bearerToken,
        relatedSearch: params.relatedSearch,
      ),).called(1);
    });
  });
}
