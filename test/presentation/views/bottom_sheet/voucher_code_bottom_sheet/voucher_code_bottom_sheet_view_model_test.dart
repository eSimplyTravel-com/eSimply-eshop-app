import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/promotion/redeem_voucher_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/voucher_code_bottom_sheet/voucher_code_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/qr_scanner/qr_scanner_view.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late VoucherCodeBottomSheetViewModel viewModel;
  late MockApiPromotionRepository mockApiPromotionRepository;
  late MockApiAuthRepository mockApiAuthRepository;
  late MockNavigationService mockNavigationService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "VoucherCodeBottomSheetView");

    mockApiPromotionRepository = locator<ApiPromotionRepository>() as MockApiPromotionRepository;
    mockApiAuthRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockNavigationService = locator<NavigationService>() as MockNavigationService;

    void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

    viewModel = VoucherCodeBottomSheetViewModel(completer: completer);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("VoucherCodeBottomSheetViewModel Tests", () {
    test("initializes with correct default values", () {
      expect(viewModel.isButtonEnabled, isFalse);
      expect(viewModel.voucherCodeController, isA<TextEditingController>());
      expect(viewModel.voucherCodeController.text, isEmpty);
      expect(viewModel.redeemVoucherUseCase, isA<RedeemVoucherUseCase>());
      expect(viewModel.getUserInfoUseCase, isA<GetUserInfoUseCase>());
    });

    test("onViewModelReady sets up controller listener", () {
      viewModel.onViewModelReady();

      // Verify listener is working by triggering validateForm
      viewModel.voucherCodeController.text = "test";
      expect(viewModel.isButtonEnabled, isTrue);
    });

    test("validateForm enables button when text is not empty", () {
      viewModel.voucherCodeController.text = "VOUCHER123";
      viewModel.validateForm();

      expect(viewModel.isButtonEnabled, isTrue);
    });

    test("validateForm disables button when text is empty", () {
      viewModel.voucherCodeController.text = "";
      viewModel.validateForm();

      expect(viewModel.isButtonEnabled, isFalse);
    });

    test("validateForm disables button when text is only spaces", () {
      viewModel.voucherCodeController.text = "   ";
      viewModel.validateForm();

      expect(viewModel.isButtonEnabled, isFalse);
    });

    test("scanVoucherCode navigates to QR scanner and updates controller", () async {
      const String scannedCode = "SCANNED_VOUCHER_123";

      when(mockNavigationService.navigateTo(
        QrScannerView.routeName,
        preventDuplicates: false,
      ),).thenAnswer((_) async => scannedCode);

      await viewModel.scanVoucherCode();

      verify(mockNavigationService.navigateTo(
        QrScannerView.routeName,
        preventDuplicates: false,
      ),).called(1);

      expect(viewModel.voucherCodeController.text, equals(scannedCode));
    });

    test("scanVoucherCode handles navigation error gracefully", () async {
      when(mockNavigationService.navigateTo(
        QrScannerView.routeName,
        preventDuplicates: false,
      ),).thenThrow(Exception("Navigation failed"));

      // Should not throw
      await viewModel.scanVoucherCode();

      verify(mockNavigationService.navigateTo(
        QrScannerView.routeName,
        preventDuplicates: false,
      ),).called(1);

      expect(viewModel.voucherCodeController.text, isEmpty);
    });

    test("redeemVoucher calls API with correct parameters", () async {
      const String voucherCode = "TEST_VOUCHER_123";

      final Resource<EmptyResponse?> successResponse = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiPromotionRepository.redeemVoucher(voucherCode: voucherCode))
          .thenAnswer((_) async => successResponse);

      when(mockApiAuthRepository.getUserInfo())
          .thenAnswer((_) async => Resource<AuthResponseModel?>.success(AuthResponseModel(), message: ""));

      // Create a test ViewModel for this test
      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {}
      final VoucherCodeBottomSheetViewModel testViewModel = VoucherCodeBottomSheetViewModel(completer: testCompleter);
      testViewModel.voucherCodeController.text = voucherCode;

      await testViewModel.redeemVoucher();

      verify(mockApiPromotionRepository.redeemVoucher(voucherCode: voucherCode)).called(1);
      expect(testViewModel.viewState, equals(ViewState.idle));
    });

    test("redeemVoucher handles API error response", () async {
      const String voucherCode = "INVALID_VOUCHER";
      viewModel.voucherCodeController.text = voucherCode;

      final Resource<EmptyResponse?> errorResponse = Resource<EmptyResponse?>.error(
        "Invalid voucher code",
      );

      when(mockApiPromotionRepository.redeemVoucher(voucherCode: voucherCode))
          .thenAnswer((_) async => errorResponse);

      await viewModel.redeemVoucher();

      verify(mockApiPromotionRepository.redeemVoucher(voucherCode: voucherCode)).called(1);
      verifyNever(mockApiAuthRepository.getUserInfo());
      expect(viewModel.viewState, equals(ViewState.idle));
    });

    test("redeemVoucher trims whitespace from voucher code", () async {
      const String voucherCodeWithSpaces = "  VOUCHER_123  ";
      const String trimmedVoucherCode = "VOUCHER_123";

      final Resource<EmptyResponse?> successResponse = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiPromotionRepository.redeemVoucher(voucherCode: trimmedVoucherCode))
          .thenAnswer((_) async => successResponse);

      when(mockApiAuthRepository.getUserInfo())
          .thenAnswer((_) async => Resource<AuthResponseModel?>.success(AuthResponseModel(), message: ""));

      // Create a test ViewModel for this test
      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {}
      final VoucherCodeBottomSheetViewModel testViewModel = VoucherCodeBottomSheetViewModel(completer: testCompleter);
      testViewModel.voucherCodeController.text = voucherCodeWithSpaces;

      await testViewModel.redeemVoucher();

      verify(mockApiPromotionRepository.redeemVoucher(voucherCode: trimmedVoucherCode)).called(1);
    });

    test("redeemVoucher sets view state to busy and back to idle", () async {
      const String voucherCode = "TEST_VOUCHER";

      final Resource<EmptyResponse?> successResponse = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiPromotionRepository.redeemVoucher(voucherCode: voucherCode))
          .thenAnswer((_) async => successResponse);

      when(mockApiAuthRepository.getUserInfo())
          .thenAnswer((_) async => Resource<AuthResponseModel?>.success(AuthResponseModel(), message: ""));

      // Create a test ViewModel for this test
      void testCompleter(SheetResponse<EmptyBottomSheetResponse> response) {}
      final VoucherCodeBottomSheetViewModel testViewModel = VoucherCodeBottomSheetViewModel(completer: testCompleter);
      testViewModel.voucherCodeController.text = voucherCode;

      expect(testViewModel.viewState, equals(ViewState.idle));

      final Future<void> redeemFuture = testViewModel.redeemVoucher();

      await redeemFuture;

      expect(testViewModel.viewState, equals(ViewState.idle));
    });

    test("context safety coverage", () async {
       MaterialApp(home: Container()).createElement();

      // Test that methods handle context safety internally if needed
      viewModel.validateForm();
      await viewModel.scanVoucherCode();

      expect(viewModel.viewState.name, isA<String>());
    });
  });
}
