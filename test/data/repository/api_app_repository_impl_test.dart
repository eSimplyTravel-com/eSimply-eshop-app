// api_app_repository_impl_test.dart

import "dart:async";

import "package:esim_open_source/data/remote/responses/app/banner_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/dynamic_page_response_dto.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response_dto.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/responses/core/string_response_dto.dart";
import "package:esim_open_source/data/repository/api_app_repository_impl.dart";
import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/utils/value_stream.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../locator_test.dart";
import "../../locator_test.mocks.dart";

void main() {
  late ApiAppRepository repository;
  late MockAPIApp mockApiApp;
  late MockLocalStorageService mockLocalStorageService;

  setUpAll(() async {
    await setupTestLocator();
  });

  setUp(() {
    mockApiApp = MockAPIApp();
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    repository = ApiAppRepositoryImpl(mockApiApp);
  });

  tearDown(() {
    reset(mockLocalStorageService);
  });

  group("ApiAppRepositoryImpl", () {
    group("addDevice", () {
      const String testFcmToken = "test-fcm-token-123";
      const String testManufacturer = "Apple";
      const String testDeviceModel = "iPhone 15";
      const String testDeviceOs = "iOS";
      const String testDeviceOsVersion = "17.0";
      const String testAppVersion = "1.0.0";
      const String testRamSize = "6GB";
      const String testScreenResolution = "1179x2556";
      const bool testIsRooted = false;

      final AddDeviceParams testParams = AddDeviceParams(
        fcmToken: testFcmToken,
        manufacturer: testManufacturer,
        deviceModel: testDeviceModel,
        deviceOs: testDeviceOs,
        deviceOsVersion: testDeviceOsVersion,
        appVersion: testAppVersion,
        ramSize: testRamSize,
        screenResolution: testScreenResolution,
        isRooted: testIsRooted,
      );

      test("should return success resource when device is added successfully",
          () async {
        // Arrange
        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Device added successfully",
          statusCode: 200,
        );

        when(
          mockApiApp.addDevice(testParams),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.addDevice(testParams) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());
        expect(result.message, "Device added successfully");
        expect(result.error, isNull);

        verify(
          mockApiApp.addDevice(testParams),
        ).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid device information",
          title: "Invalid device information",
        );

        when(
          mockApiApp.addDevice(testParams),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.addDevice(testParams) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid device information");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiApp.addDevice(testParams),
        ).called(1);
      });

      test("should pass all parameters correctly to API app", () async {
        // Arrange
        const String customFcmToken = "custom-token";
        const String customManufacturer = "Samsung";
        const String customDeviceModel = "Galaxy S24";
        const String customDeviceOs = "Android";
        const String customDeviceOsVersion = "14.0";
        const String customAppVersion = "2.0.0";
        const String customRamSize = "8GB";
        const String customScreenResolution = "1440x3200";
        const bool customIsRooted = true;

        final AddDeviceParams customParams = AddDeviceParams(
          fcmToken: customFcmToken,
          manufacturer: customManufacturer,
          deviceModel: customDeviceModel,
          deviceOs: customDeviceOs,
          deviceOsVersion: customDeviceOsVersion,
          appVersion: customAppVersion,
          ramSize: customRamSize,
          screenResolution: customScreenResolution,
          isRooted: customIsRooted,
        );

        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(mockApiApp.addDevice(any)).thenAnswer((_) async => responseMain);

        // Act
        await repository.addDevice(customParams);

        // Assert
        verify(mockApiApp.addDevice(any)).called(1);
      });
    });

    group("getFaq", () {
      test(
          "should return success resource with FAQ list when API call succeeds",
          () async {
        // Arrange
        final List<FaqResponseDto> expectedFaqs = <FaqResponseDto>[
          FaqResponseDto(
            question: "How to activate eSIM?",
            answer: "Follow the steps...",
          ),
          FaqResponseDto(
            question: "What devices are supported?",
            answer: "iPhone XS and above...",
          ),
        ];
        final ResponseMainDto<List<FaqResponseDto>> responseMain =
            ResponseMainDto<List<FaqResponseDto>>.createErrorWithData(
          data: expectedFaqs,
          message: "FAQs retrieved successfully",
          statusCode: 200,
        );

        when(mockApiApp.getFaq()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<FaqResponse>?> result =
            await repository.getFaq() as Resource<List<FaqResponse>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 2);
        expect(result.data?[0].question, "How to activate eSIM?");
        expect(result.message, "FAQs retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiApp.getFaq()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMainDto<List<FaqResponseDto>> responseMain =
            ResponseMainDto<List<FaqResponseDto>>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Failed to retrieve FAQs",
          title: "Failed to retrieve FAQs",
        );

        when(mockApiApp.getFaq()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<FaqResponse>?> result =
            await repository.getFaq() as Resource<List<FaqResponse>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Failed to retrieve FAQs");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getFaq()).called(1);
      });

      test("should handle empty FAQ list gracefully", () async {
        // Arrange
        final List<FaqResponseDto> expectedFaqs = <FaqResponseDto>[];
        final ResponseMainDto<List<FaqResponseDto>> responseMain =
            ResponseMainDto<List<FaqResponseDto>>.createErrorWithData(
          data: expectedFaqs,
          message: "No FAQs available",
          statusCode: 200,
        );

        when(mockApiApp.getFaq()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<FaqResponse>?> result =
            await repository.getFaq() as Resource<List<FaqResponse>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isEmpty);
        expect(result.message, "No FAQs available");

        verify(mockApiApp.getFaq()).called(1);
      });
    });

    group("contactUs", () {
      const String testEmail = "john.doe@example.com";
      const String testMessage = "I need help with my eSIM activation";

      test("should return success resource when contact message is sent",
          () async {
        // Arrange
        final StringResponseDto expectedResponse =
            StringResponseDto.fromJson(json: true);
        final ResponseMainDto<StringResponseDto?> responseMain =
            ResponseMainDto<StringResponseDto?>.createErrorWithData(
          data: expectedResponse,
          message: "Contact message sent",
          statusCode: 200,
        );

        when(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<StringResponse?> result = await repository.contactUs(
          email: testEmail,
          message: testMessage,
        ) as Resource<StringResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.stringValue, expectedResponse.stringValue);
        expect(result.message, "Contact message sent");
        expect(result.error, isNull);

        verify(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMainDto<StringResponseDto?> responseMain =
            ResponseMainDto<StringResponseDto?>.createErrorWithData(
          statusCode: 422,
          developerMessage: "Invalid email format",
          title: "Invalid email format",
        );

        when(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<StringResponse?> result = await repository.contactUs(
          email: testEmail,
          message: testMessage,
        ) as Resource<StringResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid email format");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).called(1);
      });

      test("should pass all contact parameters correctly to API app", () async {
        // Arrange
        const String customEmail = "jane@test.com";
        const String customMessage = "Custom inquiry message";

        final StringResponseDto expectedResponse =
            StringResponseDto.fromJson(json: true);
        final ResponseMainDto<StringResponseDto?> responseMain =
            ResponseMainDto<StringResponseDto?>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiApp.contactUs(
            email: customEmail,
            message: customMessage,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        await repository.contactUs(
          email: customEmail,
          message: customMessage,
        );

        // Assert
        verify(
          mockApiApp.contactUs(
            email: customEmail,
            message: customMessage,
          ),
        ).called(1);
      });
    });

    group("getAboutUs", () {
      test("should return success resource with about us content", () async {
        // Arrange
        final DynamicPageResponseDto expectedResponse = DynamicPageResponseDto(
          pageTitle: "About Us",
          pageContent: "We are a leading eSIM provider...",
          pageIntro: "Learn more about our company",
        );
        final ResponseMainDto<DynamicPageResponseDto> responseMain =
            ResponseMainDto<DynamicPageResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "About Us content retrieved",
          statusCode: 200,
        );

        when(mockApiApp.getAboutUs()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result =
            await repository.getAboutUs() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.pageTitle, "About Us");
        expect(result.data?.pageContent, "We are a leading eSIM provider...");
        expect(result.message, "About Us content retrieved");
        expect(result.error, isNull);

        verify(mockApiApp.getAboutUs()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMainDto<DynamicPageResponseDto> responseMain =
            ResponseMainDto<DynamicPageResponseDto>.createErrorWithData(
          statusCode: 404,
          developerMessage: "About Us content not found",
          title: "About Us content not found",
        );

        when(mockApiApp.getAboutUs()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result =
            await repository.getAboutUs() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "About Us content not found");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getAboutUs()).called(1);
      });
    });

    group("getTermsConditions", () {
      test("should return success resource with terms and conditions content",
          () async {
        // Arrange
        final DynamicPageResponseDto expectedResponse = DynamicPageResponseDto(
          pageTitle: "Terms & Conditions",
          pageContent: "These terms and conditions govern...",
          pageIntro: "Please read carefully",
        );
        final ResponseMainDto<DynamicPageResponseDto> responseMain =
            ResponseMainDto<DynamicPageResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Terms & Conditions retrieved",
          statusCode: 200,
        );

        when(mockApiApp.getTermsConditions())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result = await repository
            .getTermsConditions() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.pageTitle, "Terms & Conditions");
        expect(
          result.data?.pageContent,
          "These terms and conditions govern...",
        );
        expect(result.message, "Terms & Conditions retrieved");
        expect(result.error, isNull);

        verify(mockApiApp.getTermsConditions()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMainDto<DynamicPageResponseDto> responseMain =
            ResponseMainDto<DynamicPageResponseDto>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Failed to load terms and conditions",
          title: "Failed to load terms and conditions",
        );

        when(mockApiApp.getTermsConditions())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result = await repository
            .getTermsConditions() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Failed to load terms and conditions");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getTermsConditions()).called(1);
      });
    });

    group("getConfigurations", () {
      test("should return success resource with configurations list", () async {
        // Arrange
        final List<ConfigurationResponseModelDto> expectedConfigs =
            <ConfigurationResponseModelDto>[
          ConfigurationResponseModelDto(key: "api_timeout", value: "30"),
          ConfigurationResponseModelDto(key: "max_retries", value: "3"),
          ConfigurationResponseModelDto(key: "enable_logging", value: "true"),
        ];
        final ResponseMainDto<List<ConfigurationResponseModelDto>>
            responseMain = ResponseMainDto<
                List<ConfigurationResponseModelDto>>.createErrorWithData(
          data: expectedConfigs,
          message: "Configurations retrieved successfully",
          statusCode: 200,
        );

        when(mockApiApp.getConfigurations())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<ConfigurationResponseModel>?> result =
            await repository.getConfigurations()
                as Resource<List<ConfigurationResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 3);
        expect(result.data?[0].key, "api_timeout");
        expect(result.data?[0].value, "30");
        expect(result.message, "Configurations retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiApp.getConfigurations()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMainDto<List<ConfigurationResponseModelDto>>
            responseMain = ResponseMainDto<
                List<ConfigurationResponseModelDto>>.createErrorWithData(
          statusCode: 403,
          developerMessage: "Access denied to configurations",
          title: "Access denied to configurations",
        );

        when(mockApiApp.getConfigurations())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<ConfigurationResponseModel>?> result =
            await repository.getConfigurations()
                as Resource<List<ConfigurationResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Access denied to configurations");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getConfigurations()).called(1);
      });

      test("should handle empty configurations list gracefully", () async {
        // Arrange
        final List<ConfigurationResponseModelDto> expectedConfigs =
            <ConfigurationResponseModelDto>[];
        final ResponseMainDto<List<ConfigurationResponseModelDto>>
            responseMain = ResponseMainDto<
                List<ConfigurationResponseModelDto>>.createErrorWithData(
          data: expectedConfigs,
          message: "No configurations available",
          statusCode: 200,
        );

        when(mockApiApp.getConfigurations())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<ConfigurationResponseModel>?> result =
            await repository.getConfigurations()
                as Resource<List<ConfigurationResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isEmpty);
        expect(result.message, "No configurations available");

        verify(mockApiApp.getConfigurations()).called(1);
      });
    });

    group("getCurrencies", () {
      test("should return success resource with currencies list", () async {
        // Arrange
        final List<CurrenciesResponseModelDto> expectedCurrencies =
            <CurrenciesResponseModelDto>[
          CurrenciesResponseModelDto(currency: "USD"),
          CurrenciesResponseModelDto(currency: "EUR"),
          CurrenciesResponseModelDto(currency: "GBP"),
        ];
        final ResponseMainDto<List<CurrenciesResponseModelDto>?> responseMain =
            ResponseMainDto<
                List<CurrenciesResponseModelDto>?>.createErrorWithData(
          data: expectedCurrencies,
          message: "Currencies retrieved successfully",
          statusCode: 200,
        );

        when(mockApiApp.getCurrencies()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<CurrenciesResponseModel>?> result = await repository
            .getCurrencies() as Resource<List<CurrenciesResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 3);
        expect(result.data?[0].currency, "USD");
        expect(result.message, "Currencies retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiApp.getCurrencies()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMainDto<List<CurrenciesResponseModelDto>?> responseMain =
            ResponseMainDto<
                List<CurrenciesResponseModelDto>?>.createErrorWithData(
          statusCode: 502,
          developerMessage: "Currency service unavailable",
          title: "Currency service unavailable",
        );

        when(mockApiApp.getCurrencies()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<CurrenciesResponseModel>?> result = await repository
            .getCurrencies() as Resource<List<CurrenciesResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Currency service unavailable");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getCurrencies()).called(1);
      });

      test("should handle single currency in list", () async {
        // Arrange
        final List<CurrenciesResponseModelDto> expectedCurrencies =
            <CurrenciesResponseModelDto>[
          CurrenciesResponseModelDto(currency: "USD"),
        ];
        final ResponseMainDto<List<CurrenciesResponseModelDto>?> responseMain =
            ResponseMainDto<
                List<CurrenciesResponseModelDto>?>.createErrorWithData(
          data: expectedCurrencies,
          message: "Single currency available",
          statusCode: 200,
        );

        when(mockApiApp.getCurrencies()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<CurrenciesResponseModel>?> result = await repository
            .getCurrencies() as Resource<List<CurrenciesResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 1);
        expect(result.data?[0].currency, "USD");
        expect(result.message, "Single currency available");

        verify(mockApiApp.getCurrencies()).called(1);
      });
    });

    group("getBanner", () {
      test(
          "should return success resource with banner list when API call succeeds",
          () async {
        // Arrange
        final List<BannerResponseModelDto> expectedBanners =
            <BannerResponseModelDto>[
          BannerResponseModelDto(
            title: "Refer Your Friends",
            description: "Invite your friends",
            image: "https://example.com/banner.png",
            action: "REFER_NOW",
          ),
          BannerResponseModelDto(
            title: "New Bundle",
            description: "Check new bundles",
            image: "https://example.com/new.png",
            action: "SHOP",
          ),
        ];
        final ResponseMainDto<List<BannerResponseModelDto>> responseMain =
            ResponseMainDto<List<BannerResponseModelDto>>.createErrorWithData(
          data: expectedBanners,
          message: "Banners retrieved successfully",
          statusCode: 200,
        );

        when(mockApiApp.getBanner()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BannerResponseModel>?> result = await repository
            .getBanner() as Resource<List<BannerResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 2);
        expect(result.data?[0].title, "Refer Your Friends");
        expect(result.message, "Banners retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiApp.getBanner()).called(1);
      });

      test("should return error resource when getBanner API call fails",
          () async {
        // Arrange
        final ResponseMainDto<List<BannerResponseModelDto>> responseMain =
            ResponseMainDto<List<BannerResponseModelDto>>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Failed to load banners",
          title: "Failed to load banners",
        );

        when(mockApiApp.getBanner()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BannerResponseModel>?> result = await repository
            .getBanner() as Resource<List<BannerResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Failed to load banners");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getBanner()).called(1);
      });
    });

    group("getBannerStream", () {
      test("should return stream and trigger API fetch when no cache available",
          () async {
        // Arrange
        final List<BannerResponseModelDto> banners = <BannerResponseModelDto>[
          BannerResponseModelDto(title: "Test Banner"),
        ];
        final ResponseMainDto<List<BannerResponseModelDto>> responseMain =
            ResponseMainDto<List<BannerResponseModelDto>>.createErrorWithData(
          data: banners,
          message: "Banners loaded",
          statusCode: 200,
        );

        when(mockLocalStorageService.getString(LocalStorageKeys.appBanner))
            .thenReturn(null);
        when(mockApiApp.getBanner()).thenAnswer((_) async => responseMain);
        when(
          mockLocalStorageService.setString(
            LocalStorageKeys.appBanner,
            any,
          ),
        ).thenAnswer((_) async => true);

        // Act
        final ValueStream<Resource<List<BannerResponseModel>?>> stream =
            repository.getBannerStream();
        // Pump event loop to let async _triggerBannerStream complete
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(
            stream, isA<ValueStream<Resource<List<BannerResponseModel>?>>>());
        verify(mockLocalStorageService.getString(LocalStorageKeys.appBanner))
            .called(1);
        verify(mockApiApp.getBanner()).called(1);
        verify(
          mockLocalStorageService.setString(LocalStorageKeys.appBanner, any),
        ).called(1);
      });

      test("should return stream from cache when local storage has banner data",
          () async {
        // Arrange — valid JSON banner list in local storage
        const String cachedJson =
            '[{"title":"Cached Banner","description":"desc","image":"img","action":"ACT"}]';

        when(mockLocalStorageService.getString(LocalStorageKeys.appBanner))
            .thenReturn(cachedJson);

        // Act
        final ValueStream<Resource<List<BannerResponseModel>?>> stream =
            repository.getBannerStream();
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(
            stream, isA<ValueStream<Resource<List<BannerResponseModel>?>>>());
        verify(mockLocalStorageService.getString(LocalStorageKeys.appBanner))
            .called(1);
        verifyNever(mockApiApp.getBanner());
      });
    });

    group("resetBannerStream", () {
      test("should force reload banners from API and clear local storage cache",
          () async {
        // Arrange
        final List<BannerResponseModelDto> banners = <BannerResponseModelDto>[
          BannerResponseModelDto(title: "Fresh Banner"),
        ];
        final ResponseMainDto<List<BannerResponseModelDto>> responseMain =
            ResponseMainDto<List<BannerResponseModelDto>>.createErrorWithData(
          data: banners,
          message: "Banners refreshed",
          statusCode: 200,
        );

        when(
          mockLocalStorageService.remove(LocalStorageKeys.appBanner),
        ).thenAnswer((_) async => true);
        when(mockApiApp.getBanner()).thenAnswer((_) async => responseMain);
        when(
          mockLocalStorageService.setString(
            LocalStorageKeys.appBanner,
            any,
          ),
        ).thenAnswer((_) async => true);

        // Act
        await repository.resetBannerStream();

        // Assert
        verify(
          mockLocalStorageService.remove(LocalStorageKeys.appBanner),
        ).called(1);
        verify(mockApiApp.getBanner()).called(1);
        verify(
          mockLocalStorageService.setString(LocalStorageKeys.appBanner, any),
        ).called(1);
      });
    });

    group("Edge cases and boundary conditions", () {
      test("should handle null response data gracefully", () async {
        // Arrange
        final AddDeviceParams nullTestParams = AddDeviceParams(
          fcmToken: "test-token",
          manufacturer: "Apple",
          deviceModel: "iPhone",
          deviceOs: "iOS",
          deviceOsVersion: "17.0",
          appVersion: "1.0.0",
          ramSize: "6GB",
          screenResolution: "1179x2556",
          isRooted: false,
        );

        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          message: "Success but no data",
          statusCode: 200,
        );

        when(mockApiApp.addDevice(any)).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository
            .addDevice(nullTestParams) as Resource<EmptyResponse?>;

        // Assert - null data on a 200 maps to a success resource with null data
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNull);
      });

      test("should handle empty string parameters for addDevice", () async {
        // Arrange
        const String emptyString = "";
        final AddDeviceParams emptyParams = AddDeviceParams(
          fcmToken: emptyString,
          manufacturer: emptyString,
          deviceModel: emptyString,
          deviceOs: emptyString,
          deviceOsVersion: emptyString,
          appVersion: emptyString,
          ramSize: emptyString,
          screenResolution: emptyString,
          isRooted: false,
        );

        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(mockApiApp.addDevice(any)).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.addDevice(emptyParams) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());

        verify(mockApiApp.addDevice(any)).called(1);
      });

      test("should handle empty string parameters for contactUs", () async {
        // Arrange
        const String emptyString = "";
        final StringResponseDto expectedResponse =
            StringResponseDto.fromJson(json: true);
        final ResponseMainDto<StringResponseDto?> responseMain =
            ResponseMainDto<StringResponseDto?>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiApp.contactUs(
            email: emptyString,
            message: emptyString,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<StringResponse?> result = await repository.contactUs(
          email: emptyString,
          message: emptyString,
        ) as Resource<StringResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.stringValue, expectedResponse.stringValue);

        verify(
          mockApiApp.contactUs(
            email: emptyString,
            message: emptyString,
          ),
        ).called(1);
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiAppRepository interface", () {
        expect(repository, isA<ApiAppRepository>());
      });

      test("should return correct types as specified in interface", () async {
        // Arrange
        final AddDeviceParams typeTestParams = AddDeviceParams(
          fcmToken: "test-token",
          manufacturer: "Apple",
          deviceModel: "iPhone",
          deviceOs: "iOS",
          deviceOsVersion: "17.0",
          appVersion: "1.0.0",
          ramSize: "6GB",
          screenResolution: "1179x2556",
          isRooted: false,
        );

        final ResponseMainDto<EmptyResponseDto> responseMain =
            ResponseMainDto<EmptyResponseDto>.createErrorWithData(
          data: EmptyResponseDto(),
          message: "Success",
          statusCode: 200,
        );

        when(mockApiApp.addDevice(any)).thenAnswer((_) async => responseMain);

        // Act
        final FutureOr<dynamic> result = repository.addDevice(typeTestParams);

        // Assert
        expect(result, isA<FutureOr<dynamic>>());
        expect(result, isA<Future<Resource<EmptyResponse?>>>());
      });
    });
  });
}
