import "dart:convert";

import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

/// question : "string"
/// answer : "string"

FaqResponseDto faqResponseFromJson(String str) =>
    FaqResponseDto.fromJson(json: json.decode(str));

String faqResponseToJson(FaqResponseDto data) => json.encode(data.toJson());

class FaqResponseDto {
  FaqResponseDto({
    String? question,
    String? answer,
  }) {
    _question = question;
    _answer = answer;
  }

  FaqResponseDto.fromJson({dynamic json}) {
    _question = json["question"];
    _answer = json["answer"];
  }

  String? _question;
  String? _answer;

  FaqResponseDto copyWith({
    String? question,
    String? answer,
  }) =>
      FaqResponseDto(
        question: question ?? _question,
        answer: answer ?? _answer,
      );

  String? get question => _question;

  String? get answer => _answer;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["question"] = _question;
    map["answer"] = _answer;
    return map;
  }

  static List<FaqResponseDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(parser: FaqResponseDto.fromJson, json: json);
  }

  FaqResponse toDomain() {
    FaqResponse response = FaqResponse(
      question: question,
      answer: answer,
    );
    return response;
  }
}
