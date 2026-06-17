import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_sections.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MyWalletViewModel viewModel;
  late MockApiAuthRepository mockApiAuthRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "MyWalletView");

    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    viewModel = MyWalletViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("MyWalletViewModel Tests", () {
    test("initialization sets wallet sections correctly", () {
      expect(viewModel.walletSections, isNotEmpty);
      expect(
        viewModel.walletSections.length,
        equals(MyWalletViewSections.values.length),
      );
      expect(
        viewModel.walletSections,
        containsAll(MyWalletViewSections.values),
      );
    });

    test("getUserInfoUseCase is initialized correctly", () {
      expect(viewModel.getUserInfoUseCase, isA<GetUserInfoUseCase>());
      expect(viewModel.getUserInfoUseCase, isNotNull);
    });

    test("onViewModelReady calls refreshUserInfo", () async {
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async =>
            Resource<AuthResponseModel?>.success(null, message: "Success"),
      );

      await viewModel.onViewModelReady();

      verify(mockApiAuthRepository.getUserInfo()).called(1);
    });

    test("refreshUserInfo sets applyShimmer correctly during execution",
        () async {
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async =>
            Resource<AuthResponseModel?>.success(null, message: "Success"),
      );

      // Initially shimmer should be false
      expect(viewModel.applyShimmer, isFalse);

      // Call refreshUserInfo
      await viewModel.refreshUserInfo();

      // After completion, shimmer should be false
      expect(viewModel.applyShimmer, isFalse);
    });

    test("refreshUserInfo handles success response correctly", () async {
      final AuthResponseModel mockResponse = AuthResponseModel();
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async => Resource<AuthResponseModel?>.success(
          mockResponse,
          message: "Success",
        ),
      );

      await viewModel.refreshUserInfo();

      verify(mockApiAuthRepository.getUserInfo()).called(1);
      expect(viewModel.applyShimmer, isFalse);
    });

    test("refreshUserInfo calls notifyListeners", () async {
      when(mockApiAuthRepository.getUserInfo()).thenAnswer(
        (_) async =>
            Resource<AuthResponseModel?>.success(null, message: "Success"),
      );

      bool listenerCalled = false;
      viewModel.addListener(() {
        listenerCalled = true;
      });

      await viewModel.refreshUserInfo();

      expect(listenerCalled, isTrue);
    });

    test("wallet sections contain all expected sections", () {
      final List<MyWalletViewSections> expectedSections =
          <MyWalletViewSections>[
        MyWalletViewSections.voucherCode,
        MyWalletViewSections.referEarn,
        // MyWalletViewSections.cashbackRewards,
        MyWalletViewSections.rewardHistory,
        MyWalletViewSections.upgradeWallet,
      ];

      expect(viewModel.walletSections, containsAll(expectedSections));
      expect(viewModel.walletSections.length, equals(expectedSections.length));
    });

    test("viewModel extends BaseModel", () {
      expect(viewModel, isA<BaseModel>());
    });

    test("wallet sections maintain correct order", () {
      expect(
        viewModel.walletSections[0],
        equals(MyWalletViewSections.voucherCode),
      );
      expect(
        viewModel.walletSections[1],
        equals(MyWalletViewSections.referEarn),
      );
      // expect(viewModel.walletSections[2],
      //     equals(MyWalletViewSections.cashbackRewards),);
      expect(
        viewModel.walletSections[2],
        equals(MyWalletViewSections.rewardHistory),
      );
      expect(
        viewModel.walletSections[3],
        equals(MyWalletViewSections.upgradeWallet),
      );
    });

    test("wallet sections are properly typed", () {
      for (final MyWalletViewSections section in viewModel.walletSections) {
        expect(section, isA<MyWalletViewSections>());
      }
    });

    test("getUserInfoUseCase has correct repository dependency", () {
      expect(viewModel.getUserInfoUseCase.repository, isNotNull);
    });
  });
}
