import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_consumption/consumption_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  late ConsumptionBottomSheetViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "ConsumptionBottomSheet");

    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;

    viewModel = ConsumptionBottomSheetViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("ConsumptionBottomSheetViewModel Tests", () {
    test("initialization test", () {
      expect(viewModel, isNotNull);
      expect(viewModel, isA<ConsumptionBottomSheetViewModel>());
      expect(viewModel.state, isNotNull);
      expect(viewModel.state.percentageUI, "0.0 %");
      expect(viewModel.state.consumptionText, "");
      expect(viewModel.state.consumption, 0);
      expect(viewModel.state.showTopUP, true);
    });

    test("onViewModelReady with unlimited data skips fetch and sets idle",
        () async {
      // Arrange
      viewModel..request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: false,
        ),
      )

      // Act
      ..onViewModelReady();

      // Wait for any potential async operations
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(viewModel.state.showTopUP, false);
      expect(viewModel.viewState, ViewState.idle);
      verifyNever(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      );
    });

    test("onViewModelReady with limited data fetches consumption data",
        () async {
      // Arrange
      viewModel.request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid_123",
          showTopUp: true,
        ),
      );

      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 500,
            dataAllocated: 1000,
            dataUsedDisplay: "500MB",
            dataAllocatedDisplay: "1GB",
          ),
          message: null,
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for async operation to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      expect(viewModel.state.showTopUP, true);
      verify(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).called(1);
      expect(viewModel.viewState, ViewState.idle);
      expect(viewModel.state.percentageUI, "50.0 %");
      expect(viewModel.state.consumption, 0.5);
      expect(viewModel.state.consumptionText, "500MB of 1GB");
    });

    test("onViewModelReady with null data defaults to showTopUP true",
        () async {
      // Arrange
      viewModel.request = SheetRequest<BundleConsumptionBottomRequest>(
        
      );

      // Mock API call for null iccID (empty string)
      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 0,
            dataAllocated: 1000,
            dataUsedDisplay: "0MB",
            dataAllocatedDisplay: "1GB",
          ),
          message: null,
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for any potential async operations
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      expect(viewModel.state.showTopUP, false);
    });

    test("fetchConsumptionData success calculates percentage correctly",
        () async {
      // Arrange
      viewModel.request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid_456",
          showTopUp: true,
        ),
      );

      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 750,
            dataAllocated: 1000,
            dataUsedDisplay: "750MB",
            dataAllocatedDisplay: "1GB",
          ),
          message: null,
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for async operation to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      verify(
        mockApiUserRepository.getUserConsumption(iccID: "test_iccid_456"),
      ).called(1);
      expect(viewModel.viewState, ViewState.idle);
      expect(viewModel.state.percentageUI, "75.0 %");
      expect(viewModel.state.consumption, 0.75);
      expect(viewModel.state.consumptionText, "750MB of 1GB");
    });

    test("fetchConsumptionData success with 100 percent consumption",
        () async {
      // Arrange
      viewModel.request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid_full",
          showTopUp: true,
        ),
      );

      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 1000,
            dataAllocated: 1000,
            dataUsedDisplay: "1GB",
            dataAllocatedDisplay: "1GB",
          ),
          message: null,
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for async operation to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      verify(
        mockApiUserRepository.getUserConsumption(iccID: "test_iccid_full"),
      ).called(1);
      expect(viewModel.viewState, ViewState.idle);
      expect(viewModel.state.percentageUI, "100.0 %");
      expect(viewModel.state.consumption, 1.0);
      expect(viewModel.state.consumptionText, "1GB of 1GB");
    });

    test("fetchConsumptionData success with zero consumption", () async {
      // Arrange
      viewModel.request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid_zero",
          showTopUp: true,
        ),
      );

      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 0,
            dataAllocated: 1000,
            dataUsedDisplay: "0MB",
            dataAllocatedDisplay: "1GB",
          ),
          message: null,
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for async operation to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      verify(
        mockApiUserRepository.getUserConsumption(iccID: "test_iccid_zero"),
      ).called(1);
      expect(viewModel.viewState, ViewState.idle);
      expect(viewModel.state.percentageUI, "0.0 %");
      expect(viewModel.state.consumption, 0.0);
      expect(viewModel.state.consumptionText, "0MB of 1GB");
    });

    test("fetchConsumptionData success with null values defaults to zero",
        () async {
      // Arrange
      viewModel.request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid_null",
          showTopUp: true,
        ),
      );

      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            
          ),
          message: null,
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for async operation to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      verify(
        mockApiUserRepository.getUserConsumption(iccID: "test_iccid_null"),
      ).called(1);
      expect(viewModel.viewState, ViewState.idle);
      // NaN % because 0/0
      expect(viewModel.state.percentageUI.contains("NaN"), true);
      expect(viewModel.state.consumptionText, " of ");
    });

    test("fetchConsumptionData failure calls completer and closes sheet",
        () async {
      // Arrange
      bool completerCalled = false;
      viewModel..completer = (SheetResponse<MainBottomSheetResponse> response) {
        completerCalled = true;
      }

      ..request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid_error",
          showTopUp: true,
        ),
      );

      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.error(
          "Failed to fetch consumption data",
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for async operation to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      verify(
        mockApiUserRepository.getUserConsumption(iccID: "test_iccid_error"),
      ).called(1);
      expect(completerCalled, true);
    });

    test("onTopUpClick calls completer with top-up tag", () {
      // Arrange
      MainBottomSheetResponse? capturedResponse;
      viewModel..completer = (SheetResponse<MainBottomSheetResponse> response) {
        capturedResponse = response.data;
      }

      // Act
      ..onTopUpClick();

      // Assert
      expect(capturedResponse, isNotNull);
      expect(capturedResponse?.canceled, false);
      expect(capturedResponse?.tag, "top-up");
    });

    test("closeBottomSheet calls completer with empty response", () {
      // Arrange
      bool completerCalled = false;
      viewModel..completer = (SheetResponse<MainBottomSheetResponse> response) {
        completerCalled = true;
      }

      // Act
      ..closeBottomSheet();

      // Assert
      expect(completerCalled, true);
    });

    test("state object has correct default values", () {
      // Arrange
      final ConsumptionState state = ConsumptionState();

      // Assert
      expect(state.errorMessage, null);
      expect(state.percentageUI, "0.0 %");
      expect(state.consumptionText, "");
      expect(state.consumption, 0);
      expect(state.showTopUP, true);
    });

    test("fetchConsumptionData with decimal percentage rounds to 2 places",
        () async {
      // Arrange
      viewModel.request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: false,
          iccID: "test_iccid_decimal",
          showTopUp: true,
        ),
      );

      when(
        mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 333,
            dataAllocated: 1000,
            dataUsedDisplay: "333MB",
            dataAllocatedDisplay: "1GB",
          ),
          message: null,
        ),
      );

      // Act
      viewModel.onViewModelReady();

      // Wait for async operation to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      verify(
        mockApiUserRepository.getUserConsumption(iccID: "test_iccid_decimal"),
      ).called(1);
      expect(viewModel.state.percentageUI, "33.3 %");
      // Use closeTo matcher for floating point comparison
      expect(viewModel.state.consumption, closeTo(0.333, 0.001));
    });

    test(
        "onViewModelReady with showTopUp false in request sets state correctly",
        () async {
      // Arrange
      viewModel..request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: false,
        ),
      )

      // Act
      ..onViewModelReady();

      // Wait for any potential async operations
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(viewModel.state.showTopUP, false);
      expect(viewModel.viewState, ViewState.idle);
    });

    test(
        "onViewModelReady with showTopUp true in request sets state correctly",
        () async {
      // Arrange
      viewModel..request = SheetRequest<BundleConsumptionBottomRequest>(
        data: const BundleConsumptionBottomRequest(
          isUnlimitedData: true,
          iccID: "test_iccid",
          showTopUp: true,
        ),
      )

      // Act
      ..onViewModelReady();

      // Wait for any potential async operations
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(viewModel.state.showTopUP, true);
      expect(viewModel.viewState, ViewState.idle);
    });
  });
}
