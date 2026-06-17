import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "base_api_helper.dart";
import "base_repository_helper.dart";
import "http_client_helper.dart";
import "http_response_test_mixin.dart";
import "mock_service_manager.dart";
import "resource_test_mixin.dart";
import "test_constants.dart";
import "test_data_factory.dart";
import "test_environment_setup.dart";

/// Test suite to verify that all helper infrastructure works correctly.
/// This ensures that imports, dependencies, and basic functionality are working.
void main() {
  group("Test Infrastructure Verification", () {
    test("TestConstants should have expected values", () {
      expect(TestConstants.testDeviceId, equals("test_device_123"));
      expect(TestConstants.testUserId, equals("test_user_456"));
      expect(TestConstants.httpOk, equals(200));
      expect(TestConstants.httpUnauthorized, equals(401));
      expect(TestConstants.testAccessToken, isNotEmpty);
      expect(TestConstants.defaultBearerToken, startsWith("Bearer "));
    });

    test("TestDataFactory should create valid test data", () {
      // Test device response creation
      final DeviceInfoResponseModelDto deviceResponse =
          TestDataFactory.createDeviceResponse();
      expect(
        deviceResponse.device,
        isNull,
      ); // DeviceInfoResponseModel only has device field
      expect(deviceResponse, isNotNull);

      // Test FAQ response creation
      final FaqResponse faqResponse = TestDataFactory.createFaqResponse();
      expect(faqResponse.question, contains("Test Question"));
      expect(faqResponse.answer, contains("Test Answer"));

      // Test API endpoint creation
      final APIEndPoint endpoint = TestDataFactory.createTestEndpoint();
      expect(endpoint.path, equals("/test"));
      expect(endpoint.hasAuthorization, isFalse);

      // Test success response creation
      final ResponseMainDto<String> successResponse =
          TestDataFactory.createSuccessResponse<String>(data: "test");
      expect(successResponse.statusCode, equals(200));
      expect(successResponse.data, equals("test"));

      // Test error response creation
      final ResponseMainDto<String> errorResponse =
          TestDataFactory.createErrorResponse<String>(
        errorMessage: "Test error",
      );
      expect(errorResponse.statusCode, isNot(equals(200)));
      expect(errorResponse.message, equals("Test error"));
    });

    test("TestEnvironmentSetup should initialize environment", () async {
      // Test environment initialization
      await TestEnvironmentSetup.initializeTestEnvironment();
      expect(TestEnvironmentSetup.validateTestEnvironment(), isTrue);

      // Test environment configuration
      await TestEnvironmentSetup.configureTestEnvironment(isFromAppClip: true);
      expect(TestEnvironmentSetup.isAppClipMode, isTrue);

      // Test environment reset
      TestEnvironmentSetup.disableAppClipMode();
      expect(TestEnvironmentSetup.isStandardAppMode, isTrue);

      // Cleanup
      TestEnvironmentSetup.cleanupTestEnvironment();
    });

    test("MockServiceManager should create and configure mocks", () async {
      final MockServiceManager mockManager = MockServiceManager();
      await mockManager.setupMocks();

      // Verify mocks are created
      expect(mockManager.mockConnectivityService, isNotNull);
      expect(mockManager.mockLocalStorageService, isNotNull);
      expect(mockManager.mockDeviceInfoService, isNotNull);
      expect(mockManager.mockSecureStorageService, isNotNull);

      // Test configuration methods
      mockManager
        ..setupConnectedState()
        ..setupAuthenticatedState()
        ..setupDeviceState()

        // Test scenario presets
        ..setupSuccessfulApiCallScenario()
        ..setupNetworkErrorScenario()
        ..setupAuthErrorScenario()

        // Cleanup
        ..cleanup();
    });

    group("Test Mixins Verification", () {
      late _TestMixinContainer mixinContainer;

      setUp(() {
        mixinContainer = _TestMixinContainer();
      });

      test("ResourceTestMixin should provide validation methods", () {
        // Test success resource validation
        final Resource<String> successResource =
            TestDataFactory.createSuccessResource<String>(data: "test");
        expect(
          () => mixinContainer.expectSuccessResource(successResource),
          returnsNormally,
        );

        // Test error resource validation
        final Resource<String> errorResource =
            TestDataFactory.createErrorResource<String>(message: "error");
        expect(
          () => mixinContainer.expectErrorResource(errorResource),
          returnsNormally,
        );

        // Test loading resource validation
        final Resource<String> loadingResource =
            TestDataFactory.createLoadingResource<String>();
        expect(
          () => mixinContainer.expectLoadingResource(loadingResource),
          returnsNormally,
        );
      });

      test("HttpResponseTestMixin should provide HTTP validation methods", () {
        // Test ResponseMain success validation
        final ResponseMainDto<String> successResponse =
            TestDataFactory.createSuccessResponse<String>(data: "test");
        expect(
          () => mixinContainer.expectResponseMainSuccess(successResponse),
          returnsNormally,
        );

        // Test ResponseMain error validation
        final ResponseMainDto<String> errorResponse =
            TestDataFactory.createErrorResponse<String>(errorMessage: "error");
        expect(
          () => mixinContainer.expectResponseMainError(errorResponse),
          returnsNormally,
        );
      });
    });

    group("Base Test Classes Verification", () {
      test("BaseRepositoryHelper should be extensible", () {
        final _TestRepository testRepo = _TestRepository();
        expect(testRepo, isA<BaseRepositoryHelper<dynamic, dynamic>>());
        expect(testRepo.repositoryName, equals("TestRepository"));
      });

      test("BaseApiHelper should be extensible", () {
        final _TestApiTest testApi = _TestApiTest();
        expect(testApi, isA<BaseApiHelper>());
        expect(testApi.apiClassName, equals("TestApi"));
      });

      test("HttpClientHelper should be extensible", () {
        final _TestHttpClient testHttpClient = _TestHttpClient();
        expect(testHttpClient, isA<HttpClientHelper>());
        expect(testHttpClient.httpClientName, equals("TestHttpClient"));
      });
    });

    test("Test data batch creation should work", () {
      final Map<String, dynamic> testDataSet =
          TestDataFactory.createCompleteTestDataSet();

      expect(testDataSet["device"], isNotNull);
      expect(testDataSet["devices"], isA<List<dynamic>>());
      expect(testDataSet["faq"], isNotNull);
      expect(testDataSet["faqs"], isA<List<dynamic>>());
      expect(testDataSet["endpoint"], isNotNull);
      expect(testDataSet["authEndpoint"], isNotNull);
      expect(testDataSet["refreshEndpoint"], isNotNull);
    });

    test("Error test cases should be comprehensive", () {
      final Map<String, dynamic> errorCases =
          TestDataFactory.createErrorTestCases();

      expect(errorCases["badRequest"], isNotNull);
      expect(errorCases["unauthorized"], isNotNull);
      expect(errorCases["forbidden"], isNotNull);
      expect(errorCases["notFound"], isNotNull);
      expect(errorCases["serverError"], isNotNull);
    });
  });
}

// Helper classes for testing the infrastructure

class MockTestApi extends Mock {}

class _TestMixinContainer with ResourceTestMixin, HttpResponseTestMixin {}

class _TestRepository extends BaseRepositoryHelper<String, String> {
  @override
  String get repositoryName => "TestRepository";

  @override
  String get apiName => "TestApi";

  @override
  MockTestApi createMockApi() => MockTestApi();

  @override
  String createRepository() => "TestRepository";
}

class _TestApiTest extends BaseApiHelper {
  @override
  String get apiClassName => "TestApi";
}

class _TestHttpClient extends HttpClientHelper {
  @override
  String get httpClientName => "TestHttpClient";
}
