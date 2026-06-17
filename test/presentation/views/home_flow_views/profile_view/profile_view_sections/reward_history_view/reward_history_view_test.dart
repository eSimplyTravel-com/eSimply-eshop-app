import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/reward_history_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  test("debugFillProperties", () {
    final RewardHistoryResponseModel mockModel =
    createTestRewardHistoryResponseModel(
      isReferral: false,
      name: "Cashback Reward",
      amount: r"$10.00",
      promotionName: "Special Offer",
    );
    final RewardHistoryView widget =
    RewardHistoryView(rewardHistoryModel: mockModel);
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);
    expect(builder.properties, isNotNull);
  });

  testWidgets("renders basic structure with cashback type",
          (WidgetTester tester) async {
        final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
          isReferral: false,
          name: "Cashback Reward",
          amount: r"$10.00",
          promotionName: "Special Offer",
        );

        await tester.pumpWidget(
          createTestableWidget(
            RewardHistoryView(
              rewardHistoryModel: mockModel,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(RewardHistoryView), findsOneWidget);
        expect(find.byType(DecoratedBox), findsWidgets);
        expect(find.byType(PaddingWidget), findsWidgets);
      });

  testWidgets("renders basic structure with referral type",
          (WidgetTester tester) async {
        final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
          isReferral: true,
          name: "Cashback Reward",
          amount: r"$10.00",
          promotionName: "Special Offer",
        );

        await tester.pumpWidget(
          createTestableWidget(
            RewardHistoryView(
              rewardHistoryModel: mockModel,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(RewardHistoryView), findsOneWidget);
        expect(find.byType(DecoratedBox), findsWidgets);
        expect(find.byType(PaddingWidget), findsWidgets);
      });

  testWidgets("renders with null name and amount uses empty string fallback",
          (WidgetTester tester) async {
        final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
          isReferral: false,
        );

        await tester.pumpWidget(
          createTestableWidget(
            RewardHistoryView(
              rewardHistoryModel: mockModel,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(RewardHistoryView), findsOneWidget);
      });

  testWidgets("viewHeaderBadge renders decorated box with badge text",
          (WidgetTester tester) async {
        final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
          isReferral: false,
          name: "Cashback Reward",
          amount: r"$10.00",
        );
        final RewardHistoryView widget =
        RewardHistoryView(rewardHistoryModel: mockModel);

        await tester.pumpWidget(
          createTestableWidget(
            Builder(
              builder: widget.viewHeaderBadge,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(DecoratedBox), findsWidgets);
        expect(find.byType(PaddingWidget), findsWidgets);
      });

  testWidgets("viewBundleContent renders name and amount",
          (WidgetTester tester) async {
        final RewardHistoryResponseModel mockModel =
        createTestRewardHistoryResponseModel(
          isReferral: false,
          name: "Global 1GB Plan",
          amount: r"$5.00",
        );
        final RewardHistoryView widget =
        RewardHistoryView(rewardHistoryModel: mockModel);

        await tester.pumpWidget(
          createTestableWidget(
            Builder(
              builder: widget.viewBundleContent,
            ),
          ),
        );
        await tester.pump();

        expect(find.text("Global 1GB Plan"), findsOneWidget);
        expect(find.text(r"$5.00"), findsOneWidget);
      });
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
