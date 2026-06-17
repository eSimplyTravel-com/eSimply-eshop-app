import "package:esim_open_source/utils/date_time_utils.dart";

class RewardHistoryResponseModel {
  RewardHistoryResponseModel({
    this.isReferral,
    this.amount,
    this.name,
    this.promotionName,
    this.date,
  });

  final bool? isReferral;
  final String? amount;
  final String? name;
  final String? promotionName;
  final String? date;

  String get dateDisplayed => DateTimeUtils.formatTimestampToDate(
    timestamp: int.parse(date ?? "0"),
    format: DateTimeUtils.ddMmYyyy,
  );


  static List<RewardHistoryResponseModel> mockData =
  <RewardHistoryResponseModel>[
    RewardHistoryResponseModel(
      isReferral: false,
      name: "Global 1GB 7Days",
      promotionName: "10% Cashback",
      amount: r"$5.00",
      date: "1747125626",
    ),
    RewardHistoryResponseModel(
      isReferral: true,
      name: "kareem_chaheen123@yahoo.com",
      promotionName: "",
      amount: r"$5.00",
      date: "1747125626",
    ),
  ];
}
