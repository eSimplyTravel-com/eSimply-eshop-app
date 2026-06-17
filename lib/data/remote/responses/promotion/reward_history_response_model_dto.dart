import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class RewardHistoryResponseModelDto {
  RewardHistoryResponseModelDto({
    this.isReferral,
    this.amount,
    this.name,
    this.promotionName,
    this.date,
  });

  factory RewardHistoryResponseModelDto.fromJson({dynamic json}) {
    return RewardHistoryResponseModelDto(
      isReferral: json["is_referral"],
      amount: json["amount"],
      name: json["name"],
      promotionName: json["promotion_name"],
      date: json["date"],
    );
  }
  final bool? isReferral;
  final String? amount;
  final String? name;
  final String? promotionName;
  final String? date;

  // RewardHistoryType get type {
  //   if (isReferral ?? true) {
  //     return RewardHistoryType.referEarn;
  //   }
  //   return RewardHistoryType.cashback;
  // }

  String get dateDisplayed => DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(date ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "is_referral": isReferral,
      "amount": amount,
      "name": name,
      "promotion_name": promotionName,
      "date": date,
    };
  }

  static List<RewardHistoryResponseModelDto> fromJsonList({
    dynamic json,
  }) {
    return fromJsonListTyped(
      parser: RewardHistoryResponseModelDto.fromJson,
      json: json,
    );
  }

  RewardHistoryResponseModel toDomain() {
    RewardHistoryResponseModel response = RewardHistoryResponseModel(
      isReferral: isReferral,
      amount: amount,
      name: name,
      promotionName: promotionName,
      date: date,
    );

    return response;
  }

  static List<RewardHistoryResponseModelDto> mockData =
      <RewardHistoryResponseModelDto>[
    RewardHistoryResponseModelDto(
      isReferral: false,
      name: "Global 1GB 7Days",
      promotionName: "10% Cashback",
      amount: r"$5.00",
      date: "1747125626",
    ),
    RewardHistoryResponseModelDto(
      isReferral: true,
      name: "kareem_chaheen123@yahoo.com",
      promotionName: "",
      amount: r"$5.00",
      date: "1747125626",
    ),
  ];
}
