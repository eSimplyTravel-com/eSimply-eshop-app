class StringResponse {
  StringResponse({
    bool? stringValue,
  }) {
    _stringValue = stringValue;
  }

  bool? _stringValue;
  bool? get stringValue => _stringValue;
}
