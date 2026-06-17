class FaqResponse {
  FaqResponse({
    String? question,
    String? answer,
  }) {
    _question = question;
    _answer = answer;
  }

  String? _question;
  String? _answer;

  FaqResponse copyWith({
    String? question,
    String? answer,
  }) =>
      FaqResponse(
        question: question ?? _question,
        answer: answer ?? _answer,
      );

  String? get question => _question;

  String? get answer => _answer;
}
