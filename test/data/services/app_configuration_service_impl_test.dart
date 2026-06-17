import "package:esim_open_source/data/remote/responses/app/configuration_response_model_dto.dart";
import "package:esim_open_source/data/services/app_configuration_service_impl.dart";
import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_configurations_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";
import "../../locator_test.dart";
import "../../locator_test.mocks.dart";

/// Additional coverage for AppConfigurationServiceImpl, focusing on the async
/// configuration getters (both the value-present and the await-on-completer
/// branches), payment-type parsing, the cashback getter and the cached
/// local-storage parse path. The broader behaviour lives in
/// app_configuration_service_impl_enhanced_test.dart.
Future<void> main() async {
  await prepareTest();

  late MockApiAppRepository mockApiAppRepository;
  late MockLocalStorageService mockLocalStorageService;

  void stubConfigurations(List<ConfigurationResponseModel> configs) {
    when(mockApiAppRepository.getConfigurations()).thenAnswer(
      (_) async => Resource<List<ConfigurationResponseModel>>.success(
        configs,
        message: null,
      ),
    );
  }

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    GetConfigurationsUseCase.previousResponse = null;

    mockApiAppRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;

    when(mockLocalStorageService.setString(any, any))
        .thenAnswer((_) async => true);
    when(mockLocalStorageService.getString(any)).thenReturn(null);
  });

  tearDown(() async {
    await tearDownTest();
    GetConfigurationsUseCase.previousResponse = null;
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("AppConfigurationServiceImpl async getters", () {
    test("getCatalogVersion returns the configured catalog version", () async {
      stubConfigurations(<ConfigurationResponseModel>[
        ConfigurationResponseModel(
          key: "CATALOG.BUNDLES_CACHE_VERSION",
          value: "v3.1",
        ),
      ]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(await service.getCatalogVersion, "v3.1");
    });

    test("getSupabaseUrl returns value when already present", () async {
      stubConfigurations(<ConfigurationResponseModel>[
        ConfigurationResponseModel(
          key: "SUPABASE_BASE_URL",
          value: "https://example.supabase.co",
        ),
      ]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(await service.getSupabaseUrl, "https://example.supabase.co");
    });

    test("getSupabaseUrl awaits completer and returns empty when absent",
        () async {
      stubConfigurations(<ConfigurationResponseModel>[]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(await service.getSupabaseUrl, "");
    });

    test("getSupabaseAnon returns value when already present", () async {
      stubConfigurations(<ConfigurationResponseModel>[
        ConfigurationResponseModel(
          key: "SUPABASE_BASE_ANON_KEY",
          value: "anon-key-123",
        ),
      ]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(await service.getSupabaseAnon, "anon-key-123");
    });

    test("getSupabaseAnon awaits completer and returns empty when absent",
        () async {
      stubConfigurations(<ConfigurationResponseModel>[]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(await service.getSupabaseAnon, "");
    });

    test("getWhatsAppNumber awaits completer and returns empty when absent",
        () async {
      stubConfigurations(<ConfigurationResponseModel>[]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(await service.getWhatsAppNumber, "");
    });
  });

  group("AppConfigurationServiceImpl sync getters", () {
    test("getPaymentTypes parses the configured payment types", () async {
      stubConfigurations(<ConfigurationResponseModel>[
        ConfigurationResponseModel(
          key: "ALLOWED_PAYMENT_TYPES",
          value: "Wallet,Card",
        ),
      ]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      final List<PaymentType>? types = service.getPaymentTypes;
      expect(types, isNotNull);
      expect(types, contains(PaymentType.wallet));
      expect(types, contains(PaymentType.card));
      expect(types, isNot(contains(PaymentType.dcb)));
    });

    test("getCashbackDiscount returns the configured percentage", () async {
      stubConfigurations(<ConfigurationResponseModel>[
        ConfigurationResponseModel(
          key: "REFERRAL_CODE_PERCENTAGE",
          value: "10",
        ),
      ]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(service.getCashbackDiscount, "10%");
    });
  });

  group("AppConfigurationServiceImpl cached storage", () {
    test("getAppConfigurations parses cached configuration from storage",
        () async {
      final String cached = ConfigurationResponseModelDto.toJsonListString(
        <ConfigurationResponseModelDto>[
          ConfigurationResponseModelDto(
            key: "default_currency",
            value: "JPY",
          ),
        ],
      );
      when(mockLocalStorageService
              .getString(LocalStorageKeys.appConfigurations),)
          .thenReturn(cached);
      // API returns an error so the cached value remains in place.
      when(mockApiAppRepository.getConfigurations()).thenAnswer(
        (_) async => Resource<List<ConfigurationResponseModel>>.error(
          "Network error",
        ),
      );

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;
      await service.getAppConfigurations();

      expect(service.getDefaultCurrency, "JPY");
    });

    test("getAppConfigurations tolerates malformed cached configuration",
        () async {
      when(mockLocalStorageService
              .getString(LocalStorageKeys.appConfigurations),)
          .thenReturn("not-json");
      stubConfigurations(<ConfigurationResponseModel>[
        ConfigurationResponseModel(key: "default_currency", value: "USD"),
      ]);

      final AppConfigurationServiceImpl service =
          AppConfigurationServiceImpl.instance;

      await expectLater(service.getAppConfigurations(), completes);
      expect(service.getDefaultCurrency, "USD");
    });
  });
}
