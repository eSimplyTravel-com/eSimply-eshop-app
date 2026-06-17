import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/contact_us_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for ContactUsUseCase
/// Tests the contact us use case functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late ContactUsUseCase useCase;
  late MockApiAppRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    useCase = ContactUsUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("ContactUsUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      const String email = "test@example.com";
      const String message = "Test message";
      final ContactUsParams params = ContactUsParams(
        email: email,
        message: message,
      );

      final Resource<StringResponse?> expectedResponse =
          TestDataFactory.createSuccessResource<StringResponse?>(
        data: StringResponse(stringValue: true),
        message: "Success",
      );

      when(
        mockRepository.contactUs(
          email: email,
          message: message,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<StringResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.stringValue, equals(true));

      verify(
        mockRepository.contactUs(
          email: email,
          message: message,
        ),
      ).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      const String email = "test@example.com";
      const String message = "Test message";
      final ContactUsParams params = ContactUsParams(
        email: email,
        message: message,
      );

      final Resource<StringResponse?> expectedResponse =
          TestDataFactory.createErrorResource<StringResponse?>(
        message: "Network error",
      );

      when(
        mockRepository.contactUs(
          email: email,
          message: message,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<StringResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Network error"));

      verify(
        mockRepository.contactUs(
          email: email,
          message: message,
        ),
      ).called(1);
    });

    test("execute passes correct parameters to repository", () async {
      // Arrange
      const String email = "user@test.com";
      const String message = "Help request";
      final ContactUsParams params = ContactUsParams(
        email: email,
        message: message,
      );

      final Resource<StringResponse?> expectedResponse =
          TestDataFactory.createSuccessResource<StringResponse?>(
        data: StringResponse(stringValue: true),
      );

      when(
        mockRepository.contactUs(
          email: anyNamed("email"),
          message: anyNamed("message"),
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      await useCase.execute(params);

      // Assert
      verify(
        mockRepository.contactUs(
          email: email,
          message: message,
        ),
      ).called(1);
    });
  });

  group("ContactUsParams Tests", () {
    test("ContactUsParams stores email and message correctly", () {
      // Arrange
      const String email = "test@example.com";
      const String message = "Test message";

      // Act
      final ContactUsParams params = ContactUsParams(
        email: email,
        message: message,
      );

      // Assert
      expect(params.email, equals(email));
      expect(params.message, equals(message));
    });
  });
}
