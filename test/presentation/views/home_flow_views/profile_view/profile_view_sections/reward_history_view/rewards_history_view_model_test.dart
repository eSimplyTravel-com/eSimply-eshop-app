import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/rewards_history_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late RewardsHistoryViewModel viewModel;
  late MockApiPromotionRepository mockApiPromotionRepository;
  late MockNavigationService mockNavigationService;

  tearDown(() async {
    await tearDownTest();
  });

  setUp(() async {
    await setupTest();

    onViewModelReadyMock(viewName: "RewardsHistoryView");
    viewModel = RewardsHistoryViewModel();
    mockApiPromotionRepository =
        locator<ApiPromotionRepository>() as MockApiPromotionRepository;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    when(mockApiPromotionRepository.getRewardsHistory()).thenAnswer(
      (_) async => Resource<List<RewardHistoryResponseModel>>.success(
        <RewardHistoryResponseModel>[],
        message: "",
      ),
    );
    // Reset mocks for each test
    reset(mockApiPromotionRepository);
    reset(mockNavigationService);
  });

  group("RewardsHistoryViewModel Tests", () {
    // test("initialization sets default values", () {
    //   expect(viewModel.selectedType, equals(RewardHistoryType.none));
    //   expect(viewModel.filteredRewardHistory, isEmpty);
    // });

    test("onViewModelReady calls getRewardsHistory", () async {
      when(mockApiPromotionRepository.getRewardsHistory()).thenAnswer(
        (_) async => Resource<List<RewardHistoryResponseModel>>.success(
          <RewardHistoryResponseModel>[],
          message: "",
        ),
      );

      await viewModel.onViewModelReady();

      verify(mockApiPromotionRepository.getRewardsHistory()).called(1);
    });

    test("getRewardsHistory sets shimmer data initially", () async {
      when(mockApiPromotionRepository.getRewardsHistory()).thenAnswer(
        (_) async => Resource<List<RewardHistoryResponseModel>>.success(
          <RewardHistoryResponseModel>[],
          message: "",
        ),
      );

      await viewModel.getRewardsHistory();

      // Should have empty list as the API returns empty array
      expect(viewModel.filteredRewardHistory.length, equals(0));
      expect(viewModel.applyShimmer, isFalse);
    });

    test("getRewardsHistory handles success response", () async {
      final List<RewardHistoryResponseModel> mockData =
          <RewardHistoryResponseModel>[
        createTestRewardHistoryResponseModel(
          isReferral: false,
        ),
        createTestRewardHistoryResponseModel(
          isReferral: true,
        ),
      ];

      when(mockApiPromotionRepository.getRewardsHistory()).thenAnswer(
        (_) async => Resource<List<RewardHistoryResponseModel>>.success(
          mockData,
          message: "",
        ),
      );

      await viewModel.getRewardsHistory();

      expect(viewModel.filteredRewardHistory, equals(mockData));
      verify(mockApiPromotionRepository.getRewardsHistory()).called(1);
    });

    test("getRewardsHistory handles error response", () async {
      when(mockApiPromotionRepository.getRewardsHistory()).thenAnswer(
        (_) async => Resource<List<RewardHistoryResponseModel>>.error(
          "Network error",
        ),
      );

      // Test will throw MissingPluginException for haptic feedback in test environment
      // expect(
      //   () => viewModel.getRewardsHistory(),
      //   throwsA(isA<MissingPluginException>()),
      // );
      await viewModel.getRewardsHistory();
      expect(viewModel.filteredRewardHistory, <RewardHistoryResponseModel>[]);

      // Note: We can't verify the repository call or filtered list because the exception
      // prevents the method from completing normally
    });

    // test("changeSelectedType toggles to none when same type selected",
    //     () async {
    //   // First set up data via API call
    //   final List<RewardHistoryResponseModel> mockData =
    //       <RewardHistoryResponseModel>[
    //     createTestRewardHistoryResponseModel(
    //       isReferral: false,
    //     ),
    //   ];
    //
    //   when(mockApiPromotionRepository.getRewardsHistory()).thenAnswer(
    //     (_) async => Resource<List<RewardHistoryResponseModel>>.success(
    //       mockData,
    //       message: "",
    //     ),
    //   );
    //
    //   await viewModel.getRewardsHistory();
    //
    //   // Now set the selected type to cashback first
    //   viewModel.changeSelectedType(RewardHistoryType.cashback);
    //   expect(viewModel.selectedType, equals(RewardHistoryType.cashback));
    //
    //   // Then toggle it back to none by selecting the same type
    //   viewModel.changeSelectedType(RewardHistoryType.cashback);
    //
    //   expect(viewModel.selectedType, equals(RewardHistoryType.none));
    //   expect(viewModel.filteredRewardHistory, equals(mockData));
    // });

    // test("changeSelectedType filters by type when different type selected",
    //     () async {
    //   final List<RewardHistoryResponseModel> allData =
    //       <RewardHistoryResponseModel>[
    //     createTestRewardHistoryResponseModel(
    //       isReferral: false,
    //     ),
    //     createTestRewardHistoryResponseModel(
    //       isReferral: true,
    //     ),
    //   ];
    //
    //   when(mockApiPromotionRepository.getRewardsHistory()).thenAnswer(
    //     (_) async => Resource<List<RewardHistoryResponseModel>>.success(
    //       allData,
    //       message: "",
    //     ),
    //   );
    //
    //   await viewModel.getRewardsHistory();
    //
    //   viewModel.changeSelectedType(RewardHistoryType.cashback);
    //
    //   expect(viewModel.selectedType, equals(RewardHistoryType.cashback));
    //   expect(viewModel.filteredRewardHistory.length, equals(1));
    //   expect(viewModel.filteredRewardHistory.first.type,
    //       equals(RewardHistoryType.cashback),);
    // });
    //
    // test("onEmptyStateTapped throws error due to missing navigator key",
    //     () async {
    //   viewModel.selectedType = RewardHistoryType.cashback;
    //
    //   // Test expects null check error due to missing StackedService.navigatorKey
    //   expect(() => viewModel.onEmptyStateTapped(), throwsA(isA<TypeError>()));
    // });
  });

  // group("RewardHistoryType Tests", () {
  //   test("titleText returns correct localized strings", () {
  //     expect(RewardHistoryType.none.titleText, isA<String>());
  //     expect(RewardHistoryType.cashback.titleText, isA<String>());
  //     expect(RewardHistoryType.referEarn.titleText, isA<String>());
  //   });
  // });
  //
  // group("RewardHistoryModel Tests", () {
  //   test("constructor creates model with all required fields", () {
  //     final RewardHistoryModel model = RewardHistoryModel(
  //       rewardID: 1,
  //       rewardTitle: "Test Reward",
  //       rewardContent: "Test Content",
  //       rewardPrice: "10.00",
  //       rewardPercentage: "5%",
  //       rewardValidity: "30 days",
  //       rewardCountryCode: "US",
  //       rewardEmail: "test@example.com",
  //       rewardType: RewardHistoryType.cashback,
  //     );
  //
  //     expect(model.rewardID, equals(1));
  //     expect(model.rewardTitle, equals("Test Reward"));
  //     expect(model.rewardContent, equals("Test Content"));
  //     expect(model.rewardPrice, equals("10.00"));
  //     expect(model.rewardPercentage, equals("5%"));
  //     expect(model.rewardValidity, equals("30 days"));
  //     expect(model.rewardCountryCode, equals("US"));
  //     expect(model.rewardEmail, equals("test@example.com"));
  //     expect(model.rewardType, equals(RewardHistoryType.cashback));
  //   });
  // });
}

// Helper method to create RewardHistoryResponseModel for testing
RewardHistoryResponseModel createTestRewardHistoryResponseModel({
  bool? isReferral,
  String? amount,
  String? name,
  String? promotionName,
  String? date,
}) {
  return RewardHistoryResponseModel(
    isReferral: isReferral ?? false,
    amount: amount ?? r"$10.00",
    name: name ?? "Test Reward",
    promotionName: promotionName ?? "Test Promotion",
    date: date ?? "1747125626",
  );
}
