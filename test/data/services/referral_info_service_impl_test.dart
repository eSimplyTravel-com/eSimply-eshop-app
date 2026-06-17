import "package:esim_open_source/data/remote/responses/promotion/referral_info_response_model_dto.dart";
import "package:esim_open_source/data/services/referral_info_service_impl.dart";
import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";
import "../../locator_test.dart";
import "../../locator_test.mocks.dart";

/// Unit tests for ReferralInfoServiceImpl
/// Tests singleton access, referral info loading from local storage + API,
/// the configuration getters and refresh behaviour.
Future<void> main() async {
  await prepareTest();

  late MockLocalStorageService mockLocalStorageService;
  late MockApiPromotionRepository mockApiPromotionRepository;

  ReferralInfoResponseModel buildModel() => ReferralInfoResponseModel(
        amount: 10.5,
        currency: "USD",
        type: "referral",
        message: "Refer a friend",
      );

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();

    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockApiPromotionRepository =
        locator<ApiPromotionRepository>() as MockApiPromotionRepository;

    when(mockLocalStorageService.getString(LocalStorageKeys.referralInfo))
        .thenReturn(null);
    when(mockLocalStorageService.setString(any, any))
        .thenAnswer((_) async => true);
    when(mockApiPromotionRepository.getReferralInfo()).thenAnswer(
      (_) async => Resource<ReferralInfoResponseModel?>.success(
        buildModel(),
        message: null,
      ),
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("ReferralInfoServiceImpl Tests", () {
    test("singleton instance is created and reused", () {
      final ReferralInfoServiceImpl instance1 =
          ReferralInfoServiceImpl.instance;
      final ReferralInfoServiceImpl instance2 =
          ReferralInfoServiceImpl.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
    });

    test("instance implements ReferralInfoService interface", () {
      expect(ReferralInfoServiceImpl.instance, isA<ReferralInfoService>());
    });

    test("getReferralInfo fetches from API and exposes the amount", () async {
      final ReferralInfoServiceImpl service = ReferralInfoServiceImpl.instance;

      await service.getReferralInfo();

      expect(service.getReferralAmount, "10.5");
      expect(service.getReferralCurrency, "USD");
      expect(service.getReferralMessage, "Refer a friend");
      expect(service.getReferralAmountAndCurrency, "10.5 USD");
      verify(mockApiPromotionRepository.getReferralInfo())
          .called(greaterThan(0));
      verify(
        mockLocalStorageService.setString(LocalStorageKeys.referralInfo, any),
      ).called(greaterThan(0));
    });

    test("getReferralInfo loads cached data from local storage first",
        () async {
      const String cached =
          '{"amount": 20.0, "currency": "EUR", "message": "Cached"}';
      when(mockLocalStorageService.getString(LocalStorageKeys.referralInfo))
          .thenReturn(cached);
      when(mockApiPromotionRepository.getReferralInfo()).thenAnswer(
        (_) async => Resource<ReferralInfoResponseModel?>.error(
          "Network error",
        ),
      );

      final ReferralInfoServiceImpl service = ReferralInfoServiceImpl.instance;
      await service.getReferralInfo();

      // API failed, so the cached value remains exposed.
      expect(service.getReferralCurrency, "EUR");
      expect(service.getReferralAmount, "20.0");
    });

    test("getReferralInfo tolerates malformed cached JSON", () async {
      when(mockLocalStorageService.getString(LocalStorageKeys.referralInfo))
          .thenReturn("not-json");

      final ReferralInfoServiceImpl service = ReferralInfoServiceImpl.instance;

      await expectLater(service.getReferralInfo(), completes);
      // API still succeeds and populates data.
      expect(service.getReferralCurrency, "USD");
    });

    test("getReferralInfo handles API error without crashing", () async {
      when(mockLocalStorageService.getString(LocalStorageKeys.referralInfo))
          .thenReturn(null);
      when(mockApiPromotionRepository.getReferralInfo()).thenAnswer(
        (_) async => Resource<ReferralInfoResponseModel?>.error(
          "Network error",
        ),
      );

      final ReferralInfoServiceImpl service = ReferralInfoServiceImpl.instance;

      await expectLater(service.getReferralInfo(), completes);
    });

    test("getReferralInfo stores empty string when API returns null data",
        () async {
      when(mockApiPromotionRepository.getReferralInfo()).thenAnswer(
        (_) async => Resource<ReferralInfoResponseModel?>.success(
          null,
          message: null,
        ),
      );

      final ReferralInfoServiceImpl service = ReferralInfoServiceImpl.instance;
      await service.getReferralInfo();

      expect(service.getReferralAmount, "");
      expect(service.getReferralCurrency, "");
      verify(
        mockLocalStorageService.setString(LocalStorageKeys.referralInfo, ""),
      ).called(greaterThan(0));
    });

    test("refreshReferralInfo reloads referral info", () async {
      final ReferralInfoServiceImpl service = ReferralInfoServiceImpl.instance;

      await service.refreshReferralInfo();

      expect(service.getReferralCurrency, "USD");
      verify(mockApiPromotionRepository.getReferralInfo())
          .called(greaterThan(0));
    });
  });

  group("ReferralInfoResponseModelDto Tests", () {
    test("can parse referral info from JSON string", () {
      const String jsonString =
          '{"amount": 10.5, "currency": "USD", "message": "Refer a friend"}';

      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.referralInfoFromJsonString(jsonString);

      expect(model, isNotNull);
      expect(model.amount, 10.5);
      expect(model.currency, "USD");
      expect(model.message, "Refer a friend");
    });

    test("handles empty JSON string gracefully", () {
      const String jsonString = "";

      expect(
        () =>
            ReferralInfoResponseModelDto.referralInfoFromJsonString(jsonString),
        throwsA(isA<Object>()),
      );
    });

    test("can convert model to JSON string", () {
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 15.0,
        currency: "EUR",
        message: "Get 15 EUR for each referral",
      );

      final String jsonString = model.toJsonString();

      expect(jsonString, isNotEmpty);
      expect(jsonString, contains("amount"));
      expect(jsonString, contains("currency"));
    });
  });
}
