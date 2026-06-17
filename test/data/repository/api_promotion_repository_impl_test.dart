// api_promotion_repository_impl_test.dart

import "dart:async";

import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/responses/promotion/referral_info_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model_dto.dart";
import "package:esim_open_source/data/repository/api_promotion_repository_impl.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../locator_test.mocks.dart";

/// Unit tests for ApiPromotionRepositoryImpl
/// Tests promotion, referral, voucher, and rewards functionality
void main() {
  late ApiPromotionRepository repository;
  late MockAPIPromotion mockApiPromotion;

  setUp(() {
    mockApiPromotion = MockAPIPromotion();
    repository = ApiPromotionRepositoryImpl(apiPromotion: mockApiPromotion);
  });

  group("ApiPromotionRepositoryImpl", () {
    group("validatePromoCode", () {
      const String testPromoCode = "SUMMER2024";
      const String testBundleCode = "EUROPE_5GB";

      test("should return success resource when promo code is valid", () async {
        // Arrange
        final BundleResponseModelDto expectedBundle = BundleResponseModelDto(
          bundleCode: testBundleCode,
          displayTitle: "Europe 5GB Plan",
          price: 24.99, // Discounted price
          currencyCode: "USD",
        );

        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          data: expectedBundle,
          message: "Promo code applied successfully",
          statusCode: 200,
        );

        when(
          mockApiPromotion.validatePromoCode(
            promoCode: testPromoCode,
            bundleCode: testBundleCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result =
            await repository.validatePromoCode(
          promoCode: testPromoCode,
          bundleCode: testBundleCode,
        ) as Resource<BundleResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.bundleCode, testBundleCode);
        expect(result.data?.displayTitle, "Europe 5GB Plan");
        expect(result.data?.price, 24.99);
        expect(result.data?.currencyCode, "USD");
        expect(result.message, "Promo code applied successfully");
        expect(result.error, isNull);

        verify(
          mockApiPromotion.validatePromoCode(
            promoCode: testPromoCode,
            bundleCode: testBundleCode,
          ),
        ).called(1);
      });

      test("should return error resource when promo code is invalid", () async {
        // Arrange
        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid promo code",
          title: "Invalid promo code",
        );

        when(
          mockApiPromotion.validatePromoCode(
            promoCode: testPromoCode,
            bundleCode: testBundleCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result =
            await repository.validatePromoCode(
          promoCode: testPromoCode,
          bundleCode: testBundleCode,
        ) as Resource<BundleResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid promo code");
        expect(result.data, isNull);
        expect(result.error, isNotNull);
      });

      test("should return error when promo code is expired", () async {
        // Arrange
        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Promo code has expired",
          title: "Promo code has expired",
        );

        when(
          mockApiPromotion.validatePromoCode(
            promoCode: testPromoCode,
            bundleCode: testBundleCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result =
            await repository.validatePromoCode(
          promoCode: testPromoCode,
          bundleCode: testBundleCode,
        ) as Resource<BundleResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Promo code has expired");
      });

      test("should handle empty promo code", () async {
        // Arrange
        const String emptyPromoCode = "";

        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Promo code is required",
          title: "Promo code is required",
        );

        when(
          mockApiPromotion.validatePromoCode(
            promoCode: emptyPromoCode,
            bundleCode: testBundleCode,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result =
            await repository.validatePromoCode(
          promoCode: emptyPromoCode,
          bundleCode: testBundleCode,
        ) as Resource<BundleResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        verify(
          mockApiPromotion.validatePromoCode(
            promoCode: emptyPromoCode,
            bundleCode: testBundleCode,
          ),
        ).called(1);
      });
    });

    group("applyReferralCode", () {
      const String testReferralCode = "FRIEND123";

      test("should return success resource when referral code is applied",
          () async {
        // Arrange
        final EmptyResponseDto expectedResponse = EmptyResponseDto();

        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Referral code applied successfully",
          statusCode: 200,
        );

        when(
          mockApiPromotion.applyReferralCode(referralCode: testReferralCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.applyReferralCode(
          referralCode: testReferralCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());
        expect(result.message, "Referral code applied successfully");

        verify(
          mockApiPromotion.applyReferralCode(referralCode: testReferralCode),
        ).called(1);
      });

      test("should return error resource when referral code is invalid",
          () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid referral code",
          title: "Invalid referral code",
        );

        when(
          mockApiPromotion.applyReferralCode(referralCode: testReferralCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.applyReferralCode(
          referralCode: testReferralCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid referral code");
      });

      test("should return error when referral code already used", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Referral code already used",
          title: "Referral code already used",
        );

        when(
          mockApiPromotion.applyReferralCode(referralCode: testReferralCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.applyReferralCode(
          referralCode: testReferralCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Referral code already used");
      });

      test("should handle unauthorized access (401)", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Unauthorized",
          title: "Unauthorized",
        );

        when(
          mockApiPromotion.applyReferralCode(referralCode: testReferralCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.applyReferralCode(
          referralCode: testReferralCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Unauthorized");
      });
    });

    group("redeemVoucher", () {
      const String testVoucherCode = "VOUCHER2024";

      test("should return success resource when voucher is redeemed", () async {
        // Arrange
        final EmptyResponseDto expectedResponse = EmptyResponseDto();

        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Voucher redeemed successfully",
          statusCode: 200,
        );

        when(
          mockApiPromotion.redeemVoucher(voucherCode: testVoucherCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.redeemVoucher(
          voucherCode: testVoucherCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());
        expect(result.message, "Voucher redeemed successfully");

        verify(
          mockApiPromotion.redeemVoucher(voucherCode: testVoucherCode),
        ).called(1);
      });

      test("should return error resource when voucher is invalid", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid voucher code",
          title: "Invalid voucher code",
        );

        when(
          mockApiPromotion.redeemVoucher(voucherCode: testVoucherCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.redeemVoucher(
          voucherCode: testVoucherCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid voucher code");
      });

      test("should return error when voucher already redeemed", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Voucher already redeemed",
          title: "Voucher already redeemed",
        );

        when(
          mockApiPromotion.redeemVoucher(voucherCode: testVoucherCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.redeemVoucher(
          voucherCode: testVoucherCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Voucher already redeemed");
      });

      test("should handle server error (500)", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Internal server error",
          title: "Internal server error",
        );

        when(
          mockApiPromotion.redeemVoucher(voucherCode: testVoucherCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.redeemVoucher(
          voucherCode: testVoucherCode,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Internal server error");
      });
    });

    group("getRewardsHistory", () {
      test("should return success resource with rewards history list",
          () async {
        // Arrange
        final List<RewardHistoryResponseModelDto> expectedRewards =
            <RewardHistoryResponseModelDto>[
          RewardHistoryResponseModelDto(
            isReferral: true,
            amount: r"$5.00",
            name: "friend@email.com",
            promotionName: "",
            date: "1704067200",
          ),
          RewardHistoryResponseModelDto(
            isReferral: false,
            amount: r"$10.00",
            name: "Europe 5GB",
            promotionName: "10% Cashback",
            date: "1703980800",
          ),
        ];

        final ResponseMainDto<List<RewardHistoryResponseModelDto>> responseMain =
            ResponseMainDto<List<RewardHistoryResponseModelDto>>.createErrorWithData(
          data: expectedRewards,
          message: "Rewards history retrieved successfully",
          statusCode: 200,
        );

        when(mockApiPromotion.getRewardsHistory())
            .thenAnswer((_) async => responseMain);

        // Act — repo returns domain (§6.2); result.data is a fresh domain
        // list from toDomain(), so assert on fields not whole-object (§6.3).
        final Resource<List<RewardHistoryResponseModel>?> result =
            await repository.getRewardsHistory()
                as Resource<List<RewardHistoryResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 2);
        expect(result.data?[0].amount, r"$5.00");
        expect(result.data?[0].name, "friend@email.com");
        expect(result.data?[1].amount, r"$10.00");
        expect(result.data?[1].promotionName, "10% Cashback");
        expect(result.message, "Rewards history retrieved successfully");

        verify(mockApiPromotion.getRewardsHistory()).called(1);
      });

      test("should return success with empty list when no rewards", () async {
        // Arrange
        final List<RewardHistoryResponseModelDto> emptyRewards =
            <RewardHistoryResponseModelDto>[];

        final ResponseMainDto<List<RewardHistoryResponseModelDto>> responseMain =
            ResponseMainDto<List<RewardHistoryResponseModelDto>>.createErrorWithData(
          data: emptyRewards,
          message: "No rewards found",
          statusCode: 200,
        );

        when(mockApiPromotion.getRewardsHistory())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<RewardHistoryResponseModel>?> result =
            await repository.getRewardsHistory()
                as Resource<List<RewardHistoryResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isEmpty);
        expect(result.data?.length, 0);
      });

      test("should return error resource when API call fails", () async {
        // Arrange
        final ResponseMainDto<List<RewardHistoryResponseModelDto>> responseMain =
            ResponseMainDto<List<RewardHistoryResponseModelDto>>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Failed to retrieve rewards history",
          title: "Failed to retrieve rewards history",
        );

        when(mockApiPromotion.getRewardsHistory())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<RewardHistoryResponseModel>?> result =
            await repository.getRewardsHistory()
                as Resource<List<RewardHistoryResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Failed to retrieve rewards history");
      });

      test("should handle unauthorized access (401)", () async {
        // Arrange
        final ResponseMainDto<List<RewardHistoryResponseModelDto>> responseMain =
            ResponseMainDto<List<RewardHistoryResponseModelDto>>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Unauthorized",
          title: "Unauthorized",
        );

        when(mockApiPromotion.getRewardsHistory())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<RewardHistoryResponseModel>?> result =
            await repository.getRewardsHistory()
                as Resource<List<RewardHistoryResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Unauthorized");
      });
    });

    group("getReferralInfo", () {
      test("should return success resource with referral info", () async {
        // Arrange — the repo test mocks the API, so it returns the DTO
        final ReferralInfoResponseModelDto expectedInfo =
            ReferralInfoResponseModelDto(
          amount: 5.0,
          currency: "USD",
          type: "credit",
          message: r"Earn $5 for each referral",
        );

        final ResponseMainDto<ReferralInfoResponseModelDto?> responseMain =
            ResponseMainDto<ReferralInfoResponseModelDto?>.createErrorWithData(
          data: expectedInfo,
          message: "Referral info retrieved successfully",
          statusCode: 200,
        );

        when(mockApiPromotion.getReferralInfo())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<ReferralInfoResponseModel?> result =
            await repository.getReferralInfo()
                as Resource<ReferralInfoResponseModel?>;

        // Assert — result.data is a fresh domain instance from toDomain(),
        // so assert on fields rather than whole-object equality (§6.3).
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.amount, 5.0);
        expect(result.data?.currency, "USD");
        expect(result.data?.type, "credit");
        expect(result.message, "Referral info retrieved successfully");

        verify(mockApiPromotion.getReferralInfo()).called(1);
      });

      test("should return success(null) when API returns 200 with null data",
          () async {
        // Arrange — a 200 with data: null is a valid success, not an error
        // (§6b). The nullable inner type mirrors the impl (§6a).
        final ResponseMainDto<ReferralInfoResponseModelDto?> responseMain =
            ResponseMainDto<ReferralInfoResponseModelDto?>.createErrorWithData(
          message: "Referral info retrieved successfully",
          statusCode: 200,
        );

        when(mockApiPromotion.getReferralInfo())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<ReferralInfoResponseModel?> result =
            await repository.getReferralInfo()
                as Resource<ReferralInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNull);
      });

      test("should return error resource when API call fails", () async {
        // Arrange
        final ResponseMainDto<ReferralInfoResponseModelDto?> responseMain =
            ResponseMainDto<ReferralInfoResponseModelDto?>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Failed to retrieve referral info",
          title: "Failed to retrieve referral info",
        );

        when(mockApiPromotion.getReferralInfo())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<ReferralInfoResponseModel?> result =
            await repository.getReferralInfo()
                as Resource<ReferralInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Failed to retrieve referral info");
      });

      test("should handle server error (500)", () async {
        // Arrange
        final ResponseMainDto<ReferralInfoResponseModelDto?> responseMain =
            ResponseMainDto<ReferralInfoResponseModelDto?>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Internal server error",
          title: "Internal server error",
        );

        when(mockApiPromotion.getReferralInfo())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<ReferralInfoResponseModel?> result =
            await repository.getReferralInfo()
                as Resource<ReferralInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Internal server error");
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiPromotionRepository interface", () {
        expect(repository, isA<ApiPromotionRepository>());
      });

      test("should return FutureOr<dynamic> as specified in interface",
          () async {
        // Arrange
        const String testCode = "TEST";
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: EmptyResponseDto(),
          message: "Success",
          statusCode: 200,
        );

        when(mockApiPromotion.redeemVoucher(voucherCode: testCode))
            .thenAnswer((_) async => responseMain);

        // Act
        final FutureOr<dynamic> result = repository.redeemVoucher(
          voucherCode: testCode,
        );

        // Assert
        expect(result, isA<FutureOr<dynamic>>());
        expect(result, isA<Future<Resource<EmptyResponse?>>>());
      });
    });
  });
}
