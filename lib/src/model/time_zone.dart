class TimeZone {
  TimeZone(this.text,this.isSelected);
  final String text;
  bool isSelected;

  TimeZone copyWith({
    String? text,
    bool? isSelected
  }) {
    return TimeZone(
      text ?? this.text,
      isSelected ?? this.isSelected
    );
  }
}
