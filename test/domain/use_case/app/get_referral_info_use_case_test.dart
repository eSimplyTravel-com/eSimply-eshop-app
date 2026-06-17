import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/app/get_referral_info_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetReferralInfoUseCase
/// Tests the get referral info use case functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetReferralInfoUseCase useCase;
  late MockApiPromotionRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiPromotionRepository>() as MockApiPromotionRepository;
    useCase = GetReferralInfoUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("GetReferralInfoUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final ReferralInfoResponseModel referralInfo = ReferralInfoResponseModel(
        amount: 10.00,
        currency: "USD",
        type: "referral",
        message: "Referral info retrieved successfully",
      );

      final Resource<ReferralInfoResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<ReferralInfoResponseModel?>(
        data: referralInfo,
        message: "Success",
      );

      when(mockRepository.getReferralInfo()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<ReferralInfoResponseModel?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.amount, equals(10.00));
      expect(result.data?.currency, equals("USD"));
      expect(result.data?.type, equals("referral"));
      expect(result.data?.message, equals("Referral info retrieved successfully"));

      verify(mockRepository.getReferralInfo()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final Resource<ReferralInfoResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<ReferralInfoResponseModel?>(
        message: "Failed to fetch referral info",
      );

      when(mockRepository.getReferralInfo()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<ReferralInfoResponseModel?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch referral info"));

      verify(mockRepository.getReferralInfo()).called(1);
    });

    test("execute handles null data in success response", () async {
      // Arrange
      final Resource<ReferralInfoResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<ReferralInfoResponseModel?>(
        data: null,
      );

      when(mockRepository.getReferralInfo()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<ReferralInfoResponseModel?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);

      verify(mockRepository.getReferralInfo()).called(1);
    });

    test("execute works with null params", () async {
      // Arrange
      final Resource<ReferralInfoResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<ReferralInfoResponseModel?>(
        data: ReferralInfoResponseModel(),
      );

      when(mockRepository.getReferralInfo()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<ReferralInfoResponseModel?> result = await useCase.execute(null);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.getReferralInfo()).called(1);
    });
  });
}
