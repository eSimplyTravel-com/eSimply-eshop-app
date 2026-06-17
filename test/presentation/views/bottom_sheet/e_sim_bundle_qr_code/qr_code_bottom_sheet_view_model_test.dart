import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_qr_code/qr_code_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  late QrCodeBottomSheetViewModel viewModel;
  late MockFlutterChannelHandlerService mockChannelHandler;
  late MockApiUserRepository mockApiUserRepository;
  late MockNavigationService mockNavigationService;

  final SheetRequest<BundleQrBottomRequest> requestWithData =
      SheetRequest<BundleQrBottomRequest>(
    data: const BundleQrBottomRequest(
      iccID: "test-icc-id",
      smDpAddress: "test.smdp.address.com",
      activationCode: "test-activation-code-123",
    ),
  );

  void completer(SheetResponse<MainBottomSheetResponse> response) {}

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "ESimQrBottomSheet");
    viewModel = QrCodeBottomSheetViewModel(
      request: requestWithData,
      completer: completer,
    );
    mockChannelHandler = locator<FlutterChannelHandlerService>()
        as MockFlutterChannelHandlerService;
    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("QrCodeBottomSheetViewModel Tests", () {
    test("qrCodeValue returns correct LPA format", () {
      viewModel..smDpAddress = "smdp.example.com"
      ..activationCode = "activation123";

      expect(
        viewModel.qrCodeValue,
        equals(r"LPA:1$smdp.example.com$activation123"),
      );
    });

    test(
        "onViewModelReady sets smDpAddress and activationCode from request data",
        () async {
      viewModel.onViewModelReady();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.smDpAddress, equals("test.smdp.address.com"));
      expect(viewModel.activationCode, equals("test-activation-code-123"));
    });

    test("copyToClipboard skips when busy", () async {
      viewModel.setViewState(ViewState.busy);
      await viewModel.copyToClipboard("some text");
      expect(viewModel.isBusy, isTrue);
    });

    test("onOpenSettingsClicked calls openSimProfilesSettings", () async {
      when(mockChannelHandler.openSimProfilesSettings())
          .thenAnswer((_) async {});

      viewModel.onOpenSettingsClicked();

      verify(mockChannelHandler.openSimProfilesSettings()).called(1);
    });

    test("onUserGuideClick navigates to UserGuideView", () async {
      await viewModel.onUserGuideClick();

      verify(
        mockNavigationService.navigateTo(
          any,
          preventDuplicates: anyNamed("preventDuplicates"),
        ),
      ).called(1);
    });

    test("_getBundleDetailsInfo calls API when smDpAddress is null", () async {
      final SheetRequest<BundleQrBottomRequest> requestNoAddress =
          SheetRequest<BundleQrBottomRequest>(
        data: const BundleQrBottomRequest(iccID: "icc-123"),
      );
      final QrCodeBottomSheetViewModel viewModelNoAddress =
          QrCodeBottomSheetViewModel(
        request: requestNoAddress,
        completer: completer,
      );

      when(
        mockApiUserRepository.getMyEsimByIccID(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<PurchaseEsimBundleResponseModel?>.success(
          PurchaseEsimBundleResponseModel(
            smdpAddress: "api.smdp.address.com",
            activationCode: "api-activation-code",
          ),
          message: "Success",
        ),
      );

      viewModelNoAddress.onViewModelReady();
      await Future<void>.delayed(Duration.zero);

      verify(
        mockApiUserRepository.getMyEsimByIccID(iccID: anyNamed("iccID")),
      ).called(1);
    });

    test("_getBundleDetailsInfo calls completer on API failure", () async {
      final SheetRequest<BundleQrBottomRequest> requestNoAddress =
          SheetRequest<BundleQrBottomRequest>(
        data: const BundleQrBottomRequest(iccID: "icc-123"),
      );
      bool completerCalled = false;
      void failureCompleter(SheetResponse<MainBottomSheetResponse> response) {
        completerCalled = true;
      }

      final QrCodeBottomSheetViewModel viewModelFailure =
          QrCodeBottomSheetViewModel(
        request: requestNoAddress,
        completer: failureCompleter,
      );

      when(
        mockApiUserRepository.getMyEsimByIccID(iccID: anyNamed("iccID")),
      ).thenAnswer(
        (_) async => Resource<PurchaseEsimBundleResponseModel?>.error(
          "Server error",
        ),
      );

      viewModelFailure.onViewModelReady();
      await Future<void>.delayed(Duration.zero);

      expect(completerCalled, isTrue);
    });
  });
}
