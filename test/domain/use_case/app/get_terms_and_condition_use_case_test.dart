import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_terms_and_condition_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetTermsAndConditionUseCase
/// Tests the get terms and conditions use case with language-aware caching functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetTermsAndConditionUseCase useCase;
  late MockApiAppRepository mockRepository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    mockLocalStorageService = locator<LocalStorageService>() as MockLocalStorageService;
    useCase = GetTermsAndConditionUseCase(mockRepository);
    // Clear previous response cache between tests
    GetTermsAndConditionUseCase.previousResponse = null;
  });

  tearDown(() async {
    // Clean up static cache
    GetTermsAndConditionUseCase.previousResponse = null;
    await locator.reset();
  });

  group("GetTermsAndConditionUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final DynamicPageResponse termsAndConditions =
          TestDataFactory.createDynamicPageResponse(
        pageTitle: "Terms and Conditions",
        pageIntro: "Please read these terms carefully",
        pageContent: "By using our service, you agree to...",
      );

      final Resource<DynamicPageResponse?> expectedResponse =
          TestDataFactory.createSuccessResource<DynamicPageResponse?>(
        data: termsAndConditions,
        message: "Success",
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<DynamicPageResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.pageTitle, equals("Terms and Conditions"));
      expect(result.data?.pageIntro, equals("Please read these terms carefully"));
      expect(result.data?.pageContent, equals("By using our service, you agree to..."));

      verify(mockRepository.getTermsConditions()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> expectedResponse =
          TestDataFactory.createErrorResource<DynamicPageResponse?>(
        message: "Failed to fetch terms and conditions",
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<DynamicPageResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch terms and conditions"));

      verify(mockRepository.getTermsConditions()).called(1);
    });

    test("execute caches successful response for same language", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> expectedResponse =
          TestDataFactory.createSuccessResource<DynamicPageResponse?>(
        data: TestDataFactory.createDynamicPageResponse(),
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => expectedResponse);

      // Act - First call
      final Resource<DynamicPageResponse?> result1 = await useCase.execute(NoParams());

      // Act - Second call with same language
      final Resource<DynamicPageResponse?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.success));
      expect(result2.resourceType, equals(ResourceType.success));
      expect(result1.data, equals(result2.data));

      // Repository should only be called once due to caching
      verify(mockRepository.getTermsConditions()).called(1);
    });

    test("execute fetches new data when language changes", () async {
      // Arrange - First call with English
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> englishResponse =
          TestDataFactory.createSuccessResource<DynamicPageResponse?>(
        data: TestDataFactory.createDynamicPageResponse(
          pageTitle: "Terms and Conditions",
        ),
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => englishResponse);

      // Act - First call
      final Resource<DynamicPageResponse?> result1 = await useCase.execute(NoParams());

      // Arrange - Second call with French
      when(mockLocalStorageService.languageCode).thenReturn("fr");

      final Resource<DynamicPageResponse?> frenchResponse =
          TestDataFactory.createSuccessResource<DynamicPageResponse?>(
        data: TestDataFactory.createDynamicPageResponse(
          pageTitle: "Termes et Conditions",
        ),
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => frenchResponse);

      // Act - Second call with different language
      final Resource<DynamicPageResponse?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.success));
      expect(result2.resourceType, equals(ResourceType.success));
      expect(result1.data?.pageTitle, equals("Terms and Conditions"));
      expect(result2.data?.pageTitle, equals("Termes et Conditions"));

      // Repository should be called twice due to language change
      verify(mockRepository.getTermsConditions()).called(2);
    });

    test("execute does not cache error response", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> errorResponse =
          TestDataFactory.createErrorResource<DynamicPageResponse?>(
        message: "Network error",
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => errorResponse);

      // Act - First call
      final Resource<DynamicPageResponse?> result1 = await useCase.execute(NoParams());

      // Act - Second call
      final Resource<DynamicPageResponse?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.error));
      expect(result2.resourceType, equals(ResourceType.error));

      // Repository should be called twice since error is not cached
      verify(mockRepository.getTermsConditions()).called(2);
    });

    test("execute does not cache loading response", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> loadingResponse =
          TestDataFactory.createLoadingResource<DynamicPageResponse?>();

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => loadingResponse);

      // Act - First call
      final Resource<DynamicPageResponse?> result1 = await useCase.execute(NoParams());

      // Act - Second call
      final Resource<DynamicPageResponse?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.loading));
      expect(result2.resourceType, equals(ResourceType.loading));

      // Repository should be called twice since loading is not cached
      verify(mockRepository.getTermsConditions()).called(2);
    });

    test("execute works with null params", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> expectedResponse =
          TestDataFactory.createSuccessResource<DynamicPageResponse?>(
        data: TestDataFactory.createDynamicPageResponse(),
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<DynamicPageResponse?> result = await useCase.execute(null);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.getTermsConditions()).called(1);
    });

    test("execute handles null data in success response", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> expectedResponse =
          TestDataFactory.createSuccessResource<DynamicPageResponse?>(
        data: null,
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<DynamicPageResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);

      verify(mockRepository.getTermsConditions()).called(1);
    });

    test("execute returns cached response when previous response exists for same language",
        () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<DynamicPageResponse?> expectedResponse =
          TestDataFactory.createSuccessResource<DynamicPageResponse?>(
        data: TestDataFactory.createDynamicPageResponse(),
      );

      when(mockRepository.getTermsConditions()).thenAnswer((_) async => expectedResponse);

      // Act - First call to cache the response
      await useCase.execute(NoParams());

      // Act - Second call should use cache
      final Resource<DynamicPageResponse?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      // Repository should only be called once
      verify(mockRepository.getTermsConditions()).called(1);
    });
  });
}
