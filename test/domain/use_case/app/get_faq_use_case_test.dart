import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_faq_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetFaqUseCase
/// Tests the get FAQ use case with language-aware caching functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetFaqUseCase useCase;
  late MockApiAppRepository mockRepository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    mockLocalStorageService = locator<LocalStorageService>() as MockLocalStorageService;
    useCase = GetFaqUseCase(mockRepository);
    // Clear previous response cache between tests
    GetFaqUseCase.previousResponse = null;
  });

  tearDown(() async {
    // Clean up static cache
    GetFaqUseCase.previousResponse = null;
    await locator.reset();
  });

  group("GetFaqUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final List<FaqResponse> faqs = TestDataFactory.createFaqResponseList(count: 5);

      final Resource<List<FaqResponse>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<FaqResponse>?>(
        data: faqs,
        message: "Success",
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<FaqResponse>?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(5));

      verify(mockRepository.getFaq()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<List<FaqResponse>?> expectedResponse =
          TestDataFactory.createErrorResource<List<FaqResponse>?>(
        message: "Failed to fetch FAQs",
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<FaqResponse>?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch FAQs"));

      verify(mockRepository.getFaq()).called(1);
    });

    test("execute caches successful response for same language", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<List<FaqResponse>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<FaqResponse>?>(
        data: TestDataFactory.createFaqResponseList(),
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => expectedResponse);

      // Act - First call
      final Resource<List<FaqResponse>?> result1 = await useCase.execute(NoParams());

      // Act - Second call with same language
      final Resource<List<FaqResponse>?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.success));
      expect(result2.resourceType, equals(ResourceType.success));
      expect(result1.data, equals(result2.data));

      // Repository should only be called once due to caching
      verify(mockRepository.getFaq()).called(1);
    });

    test("execute fetches new data when language changes", () async {
      // Arrange - First call with English
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<List<FaqResponse>?> englishResponse =
          TestDataFactory.createSuccessResource<List<FaqResponse>?>(
        data: <FaqResponse>[
          TestDataFactory.createFaqResponse(
            question: "How do I install eSIM?",
            answer: "Follow these steps...",
          ),
        ],
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => englishResponse);

      // Act - First call
      final Resource<List<FaqResponse>?> result1 = await useCase.execute(NoParams());

      // Arrange - Second call with Spanish
      when(mockLocalStorageService.languageCode).thenReturn("es");

      final Resource<List<FaqResponse>?> spanishResponse =
          TestDataFactory.createSuccessResource<List<FaqResponse>?>(
        data: <FaqResponse>[
          TestDataFactory.createFaqResponse(
            question: "¿Cómo instalo eSIM?",
            answer: "Sigue estos pasos...",
          ),
        ],
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => spanishResponse);

      // Act - Second call with different language
      final Resource<List<FaqResponse>?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.success));
      expect(result2.resourceType, equals(ResourceType.success));
      expect(result1.data?[0].question, equals("How do I install eSIM?"));
      expect(result2.data?[0].question, equals("¿Cómo instalo eSIM?"));

      // Repository should be called twice due to language change
      verify(mockRepository.getFaq()).called(2);
    });

    test("execute does not cache error response", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<List<FaqResponse>?> errorResponse =
          TestDataFactory.createErrorResource<List<FaqResponse>?>(
        message: "Network error",
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => errorResponse);

      // Act - First call
      final Resource<List<FaqResponse>?> result1 = await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<FaqResponse>?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.error));
      expect(result2.resourceType, equals(ResourceType.error));

      // Repository should be called twice since error is not cached
      verify(mockRepository.getFaq()).called(2);
    });

    test("execute does not cache loading response", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<List<FaqResponse>?> loadingResponse =
          TestDataFactory.createLoadingResource<List<FaqResponse>?>();

      when(mockRepository.getFaq()).thenAnswer((_) async => loadingResponse);

      // Act - First call
      final Resource<List<FaqResponse>?> result1 = await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<FaqResponse>?> result2 = await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.loading));
      expect(result2.resourceType, equals(ResourceType.loading));

      // Repository should be called twice since loading is not cached
      verify(mockRepository.getFaq()).called(2);
    });

    test("execute works with null params", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<List<FaqResponse>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<FaqResponse>?>(
        data: TestDataFactory.createFaqResponseList(),
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<FaqResponse>?> result = await useCase.execute(null);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.getFaq()).called(1);
    });

    test("execute handles empty FAQ list", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final Resource<List<FaqResponse>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<FaqResponse>?>(
        data: <FaqResponse>[],
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<FaqResponse>?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.isEmpty, isTrue);

      verify(mockRepository.getFaq()).called(1);
    });

    test("execute verifies FAQ data structure", () async {
      // Arrange
      when(mockLocalStorageService.languageCode).thenReturn("en");

      final List<FaqResponse> faqs = <FaqResponse>[
        TestDataFactory.createFaqResponse(
          id: 1,
          question: "What is eSIM?",
          answer: "eSIM is a digital SIM...",
        ),
        TestDataFactory.createFaqResponse(
          id: 2,
          question: "How to activate?",
          answer: "To activate your eSIM...",
        ),
      ];

      final Resource<List<FaqResponse>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<FaqResponse>?>(
        data: faqs,
      );

      when(mockRepository.getFaq()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<FaqResponse>?> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.length, equals(2));
      expect(result.data?[0].question, equals("What is eSIM?"));
      expect(result.data?[0].answer, equals("eSIM is a digital SIM..."));
      expect(result.data?[1].question, equals("How to activate?"));
      expect(result.data?[1].answer, equals("To activate your eSIM..."));

      verify(mockRepository.getFaq()).called(1);
    });
  });
}
