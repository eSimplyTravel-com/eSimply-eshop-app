import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle/my_e_sim_bundle_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  late MyESimBundleBottomSheetViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;
  late SheetRequest<MyESimBundleRequest> testRequest;
  late MyESimBundleRequest testData;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "MyESimBundle");

    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;

    final PurchaseEsimBundleResponseModel testBundle =
        PurchaseEsimBundleResponseModel(
      iccid: "892200660703814876",
      displayTitle: "Global 1GB 7Days",
      displaySubtitle: "Global 1GB 7Days",
      gprsLimitDisplay: "1 GB",
      unlimited: false,
      icon: "https://test.com/icon.png",
      validityLabel: "Days",
      paymentDate: "1708876762000",
      countries: <CountryResponseModel>[
        CountryResponseModel(
          country: "United States",
          countryCode: "US",
        ),
      ],
      isTopupAllowed: true,
      orderNumber: "ORDER_123",
    );

    testData = MyESimBundleRequest(
      eSimBundleResponseModel: testBundle,
    );

    testRequest = SheetRequest<MyESimBundleRequest>(data: testData);

    void completer(SheetResponse<MainBottomSheetResponse> response) {}

    viewModel = MyESimBundleBottomSheetViewModel()
      ..request = testRequest
      ..completer = completer;
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("MyESimBundleBottomSheetViewModel Tests", () {
    test("initialization test", () {
      expect(viewModel, isNotNull);
      expect(viewModel, isA<MyESimBundleBottomSheetViewModel>());
      expect(viewModel.request, equals(testRequest));
      expect(viewModel.completer, isNotNull);
      expect(viewModel.state, isNotNull);
    });

    test("state initializes with correct default values", () {
      final MyESimBundleBottomState state = MyESimBundleBottomState();

      expect(state.item, isNull);
      expect(state.errorMessage, isNull);
      expect(state.percentageUI, equals("0.0 %"));
      expect(state.consumptionText, isEmpty);
      expect(state.consumption, equals(0));
      expect(state.consumptionLoading, isTrue);
      expect(state.showTopUP, isTrue);
      expect(state.expiryDate, isNull);
    });

    test("onViewModelReady when bundle is unlimited sets state correctly",
        () async {
      final PurchaseEsimBundleResponseModel unlimitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: true,
        isTopupAllowed: true,
      );

      viewModel..request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: unlimitedBundle),
      )

      ..onViewModelReady();

      expect(viewModel.state.item, equals(unlimitedBundle));
      expect(viewModel.state.showTopUP, isTrue);
      expect(viewModel.state.consumptionLoading, isFalse);
    });

    test("onViewModelReady when bundle is limited fetches consumption data",
        () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 500,
            dataAllocated: 1000,
            dataUsedDisplay: "500 MB",
            dataAllocatedDisplay: "1 GB",
            expiryDate: "2025-12-31",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.item, equals(limitedBundle));
      expect(viewModel.state.showTopUP, isTrue);
      expect(viewModel.state.consumptionLoading, isFalse);
      verify(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .called(1);
    });

    test("onViewModelReady when isTopupAllowed is false sets showTopUP false",
        () {
      final PurchaseEsimBundleResponseModel noTopUpBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: true,
        isTopupAllowed: false,
      );

      viewModel..request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: noTopUpBundle),
      )

      ..onViewModelReady();

      expect(viewModel.state.showTopUP, isFalse);
    });

    test("onViewModelReady when isTopupAllowed is null defaults to true", () {
      final PurchaseEsimBundleResponseModel nullTopUpBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: true,
      );

      viewModel..request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: nullTopUpBundle),
      )

      ..onViewModelReady();

      expect(viewModel.state.showTopUP, isTrue);
    });

    test("fetchConsumptionData success updates state correctly", () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 750,
            dataAllocated: 1000,
            dataUsedDisplay: "750 MB",
            dataAllocatedDisplay: "1 GB",
            expiryDate: "2025-12-31",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.percentageUI, equals("75.0 %"));
      expect(viewModel.state.consumption, equals(0.75));
      expect(viewModel.state.consumptionText, equals("750 MB of 1 GB"));
      expect(viewModel.state.consumptionLoading, isFalse);
      expect(viewModel.state.expiryDate, equals("31/12/2025"));
      expect(viewModel.viewState, equals(ViewState.idle));
    });

    test("fetchConsumptionData with zero allocated data handles division",
        () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 100,
            dataAllocated: 0,
            dataUsedDisplay: "100 MB",
            dataAllocatedDisplay: "0 GB",
            expiryDate: "2025-12-31",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Should handle division by zero gracefully (NaN or Infinity)
      expect(viewModel.state.consumptionLoading, isFalse);
    });

    test("fetchConsumptionData with 100 percent consumption", () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 1000,
            dataAllocated: 1000,
            dataUsedDisplay: "1 GB",
            dataAllocatedDisplay: "1 GB",
            expiryDate: "2025-12-31",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.percentageUI, equals("100.0 %"));
      expect(viewModel.state.consumption, equals(1.0));
      expect(viewModel.state.consumptionText, equals("1 GB of 1 GB"));
    });

    test("fetchConsumptionData with fractional percentage", () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 333,
            dataAllocated: 1000,
            dataUsedDisplay: "333 MB",
            dataAllocatedDisplay: "1 GB",
            expiryDate: "2025-12-31",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.percentageUI, equals("33.3 %"));
      expect(viewModel.state.consumption, closeTo(0.333, 0.001));
    });

    test("fetchConsumptionData failure updates error state", () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.error(
          "Failed to fetch consumption data",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.errorMessage, equals("Failed to fetch consumption data"));
      expect(viewModel.state.consumptionLoading, isFalse);
    });

    test("fetchConsumptionData failure with empty message uses it as error",
        () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.error(""),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.errorMessage, isEmpty);
      expect(viewModel.state.consumptionLoading, isFalse);
    });

    test("onTopUpClick calls completer with correct response", () {
      bool completerCalled = false;
      SheetResponse<MainBottomSheetResponse>? response;

      void testCompleter(SheetResponse<MainBottomSheetResponse> res) {
        completerCalled = true;
        response = res;
      }

      viewModel..completer = testCompleter

      ..onTopUpClick();

      expect(completerCalled, isTrue);
      expect(response, isNotNull);
      expect(response?.data, isNotNull);
      expect(response?.data?.canceled, isFalse);
      expect(response?.data?.tag, equals("top_up"));
    });

    test("handles null bundle data gracefully", () async {
      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: null),
      );

      // Mock the getUserConsumption call that will happen because null is treated as limited bundle
      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 0,
            dataAllocated: 0,
            dataUsedDisplay: "0 MB",
            dataAllocatedDisplay: "0 MB",
            expiryDate: "",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.item, isNull);
      expect(viewModel.state.showTopUP, isTrue);
      expect(viewModel.state.consumptionLoading, isFalse);
    });

    test("handles empty iccid when fetching consumption", () async {
      final PurchaseEsimBundleResponseModel bundleWithoutIccid =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: bundleWithoutIccid),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 500,
            dataAllocated: 1000,
            dataUsedDisplay: "500 MB",
            dataAllocatedDisplay: "1 GB",
            expiryDate: "2025-12-31",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      verify(mockApiUserRepository.getUserConsumption(iccID: "")).called(1);
    });

    test("inherits BaseModel functionality", () {
      expect(viewModel.localStorageService, isNotNull);
      expect(viewModel.analyticsService, isNotNull);
      expect(viewModel.themeService, isNotNull);
      expect(viewModel.userService, isNotNull);
      expect(viewModel.paymentService, isNotNull);
      expect(viewModel.redirectionsHandlerService, isNotNull);
    });

    test("maintains view state consistency", () {
      expect(viewModel.viewState, equals(ViewState.idle));
      expect(viewModel.isBusy, isFalse);
      expect(viewModel.hasError, isFalse);
    });

    test("fetchConsumptionData with null response data handles gracefully",
        () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          null,
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.consumptionLoading, isFalse);
      expect(viewModel.viewState, equals(ViewState.idle));
    });

    test("fetchConsumptionData with empty expiry date", () async {
      final PurchaseEsimBundleResponseModel limitedBundle =
          PurchaseEsimBundleResponseModel(
        unlimited: false,
        isTopupAllowed: true,
        iccid: "892200660703814876",
      );

      viewModel.request = SheetRequest<MyESimBundleRequest>(
        data: MyESimBundleRequest(eSimBundleResponseModel: limitedBundle),
      );

      when(mockApiUserRepository.getUserConsumption(iccID: anyNamed("iccID")))
          .thenAnswer(
        (_) async => Resource<UserBundleConsumptionResponse?>.success(
          UserBundleConsumptionResponse(
            dataUsed: 500,
            dataAllocated: 1000,
            dataUsedDisplay: "500 MB",
            dataAllocatedDisplay: "1 GB",
            expiryDate: "",
          ),
          message: "Success",
        ),
      );

      viewModel.onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.expiryDate, isEmpty);
    });

    test("ViewModel initialization without throwing errors", () {
      expect(() {
        MyESimBundleBottomSheetViewModel()
          ..request = testRequest
          ..completer = viewModel.completer;
      }, returnsNormally,);
    });

    test("isCruise returns false when state item is null", () {
      expect(viewModel.isCruise(), isFalse);
    });

    test("isCruise returns true when bundle category type is CRUISE", () {
      viewModel.state.item = PurchaseEsimBundleResponseModel(
        bundleCategory: BundleCategoryResponseModel(type: "CRUISE"),
      );
      expect(viewModel.isCruise(), isTrue);
    });

    test("isCruise returns false when bundle category type is not CRUISE", () {
      viewModel.state.item = PurchaseEsimBundleResponseModel(
        bundleCategory: BundleCategoryResponseModel(type: "GLOBAL"),
      );
      expect(viewModel.isCruise(), isFalse);
    });

    test("getBundleTranslation returns translation for primaryBundle type", () {
      final String result = viewModel.getBundleTranslation("Primary Bundle");
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });
  });
}
