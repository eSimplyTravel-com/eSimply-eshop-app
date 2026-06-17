import "dart:async";

import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/repository/api_notifications_repository_impl.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_notifications_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../locator_test.mocks.dart";

void main() {
  late ApiNotificationsRepository repository;
  late MockAPINotifications mockApiNotifications;

  setUp(() {
    mockApiNotifications = MockAPINotifications();
    repository = ApiNotificationsRepositoryImpl(mockApiNotifications);
  });

  group("ApiNotificationsRepositoryImpl", () {
    group("getConsumptionLimit", () {
      test("should return success resource when API returns 200", () async {
        // Arrange
        final EmptyResponseDto expectedResponse = EmptyResponseDto();
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          data: expectedResponse,
          message: "Consumption limit set successfully",
          statusCode: 200,
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.getConsumptionLimit() as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isA<EmptyResponse>());
        expect(result.message, "Consumption limit set successfully");
        expect(result.error, isNull);

        verify(mockApiNotifications.getConsumptionLimit()).called(1);
      });

      test("should return error resource when API returns 400", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Bad request",
          title: "Bad request",
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.getConsumptionLimit() as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Bad request");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiNotifications.getConsumptionLimit()).called(1);
      });

      test("should return error resource when API returns 401", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Unauthorized",
          title: "Unauthorized",
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.getConsumptionLimit() as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Unauthorized");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiNotifications.getConsumptionLimit()).called(1);
      });

      test("should return error resource when API returns 404", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          statusCode: 404,
          developerMessage: "Resource not found",
          title: "Resource not found",
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.getConsumptionLimit() as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Resource not found");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiNotifications.getConsumptionLimit()).called(1);
      });

      test("should return error resource when API returns 500", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Internal server error",
          title: "Internal server error",
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.getConsumptionLimit() as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Internal server error");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiNotifications.getConsumptionLimit()).called(1);
      });

      test("should call API exactly once per invocation", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          data: EmptyResponseDto(),
          statusCode: 200,
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        await repository.getConsumptionLimit();

        // Assert
        verify(mockApiNotifications.getConsumptionLimit()).called(1);
        verifyNoMoreInteractions(mockApiNotifications);
      });
    });

    group("Edge cases and boundary conditions", () {
      test("should handle null response data gracefully", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          message: "Success but no data",
          statusCode: 200,
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.getConsumptionLimit() as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNull);
      });

      test("should return error resource when API returns 403", () async {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          statusCode: 403,
          developerMessage: "Forbidden",
          title: "Forbidden",
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result =
            await repository.getConsumptionLimit() as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Forbidden");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiNotifications.getConsumptionLimit()).called(1);
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiNotificationsRepository interface", () {
        expect(repository, isA<ApiNotificationsRepository>());
      });

      test("should return FutureOr<Resource<EmptyResponse?>> as specified", () {
        // Arrange
        final ResponseMainDto<EmptyResponseDto?> responseMain =
            ResponseMainDto<EmptyResponseDto?>.createErrorWithData(
          data: EmptyResponseDto(),
          message: "Success",
          statusCode: 200,
        );

        when(mockApiNotifications.getConsumptionLimit())
            .thenAnswer((_) async => responseMain);

        // Act
        final FutureOr<dynamic> result = repository.getConsumptionLimit();

        // Assert
        expect(result, isA<FutureOr<dynamic>>());
        expect(result, isA<Future<Resource<EmptyResponse?>>>());
      });
    });
  });
}
