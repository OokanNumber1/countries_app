class Continent {
  Continent(this.text, this.isSelected);
  final String text;
  bool isSelected;

  Continent copyWith({
    String? text,
    bool? isSelected,
  }) {
    return Continent(
      text ?? this.text,
      isSelected ?? this.isSelected,
    );
  }
}
