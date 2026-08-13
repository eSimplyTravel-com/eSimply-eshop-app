import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/share_referral_code/share_referral_code_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late ShareReferralCodeBottomSheetViewModel viewModel;
  late MockUserAuthenticationService mockUserAuthService;
  late MockReferralInfoService mockReferralInfoService;
  late MockDynamicLinkingService mockDynamicLinkingService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "ShareReferralCodeBottomSheet");

    viewModel = ShareReferralCodeBottomSheetViewModel();
    mockUserAuthService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    mockReferralInfoService =
        locator<ReferralInfoService>() as MockReferralInfoService;
    mockDynamicLinkingService =
        locator<DynamicLinkingService>() as MockDynamicLinkingService;
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("ShareReferralCodeBottomSheetViewModel Tests", () {
    test("line coverage test", () {
      // Setup mocks
      when(mockUserAuthService.referralCode).thenReturn("TEST123");
      when(mockReferralInfoService.getReferralAmountAndCurrency)
          .thenReturn(r"$10 USD");
      when(mockReferralInfoService.getReferralMessage)
          .thenReturn(r"Get $10 when you join!");

      // Hit all getters for line coverage
      final String referralCode = viewModel.referralCode;
      final String deepLink = viewModel.deepLink;
      final String amount = viewModel.amount;
      final String message = viewModel.getReferralMessage;

      // Basic assertions
      expect(referralCode, equals("TEST123"));
      expect(deepLink, contains("TEST123"));
      expect(amount, equals(r"$10 USD"));
      expect(message, equals(r"Get $10 when you join!"));
    });

    test("shareButtonTapped shares the plain website link, never Branch",
        () async {
      when(mockUserAuthService.referralCode).thenReturn("TEST123");
      when(mockReferralInfoService.getReferralAmountAndCurrency)
          .thenReturn(r"$10 USD");

      await viewModel.shareButtonTapped();

      // The Branch short-link path is gone with the SDK: the shared link is the
      // website URL, which the app's associated domains cover.
      expect(viewModel.deepLink, contains("TEST123"));
      verifyNever(
        mockDynamicLinkingService.generateBranchLink(
          deepLinkUrl: anyNamed("deepLinkUrl"),
          referUserID: anyNamed("referUserID"),
        ),
      );
    });
  });
}
