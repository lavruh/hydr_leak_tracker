class CalculatedValue{
  final DateTime date;
  final double value;

  const CalculatedValue({
    required this.date,
    required this.value,
  });

  CalculatedValue copyWith({
    DateTime? date,
    double? value,
  }) {
    return CalculatedValue(
      date: date ?? this.date,
      value: value ?? this.value,
    );
  }

  @override
  String toString() {
    return 'CalculatedValue{date: $date, value: $value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculatedValue &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          value == other.value;

  @override
  int get hashCode => date.hashCode ^ value.hashCode;
}