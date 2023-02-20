import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydr_leak_tracker/domain/log_analyse_provider.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/ui/widgets/calculated_value.dart';

final entry = LogEntry.empty();
final data = List.generate(5, (index) {
  final val = (100 - ((index + 1) * (index % 2 == 0 ? 10 : 20))).toDouble();
  final date = DateTime(2023, 1, index + 1);
  return entry.copyWith(volume: val, date: date);
});

main() {
  test('average', () {
    expect(LogAnalyse.average(data),
        CalculatedValue(date: data.first.date, value: 58));
  });

  test('loses', () {
    final res = LogAnalyse.calcLosesPerEntry(data);
    expect(res.length, 4);
    expect(res[0].value, -30.0);
    expect(res[1].value, 10.0);
    expect(res[2].value, -50.0);
    expect(res[3].value, 30.0);
  });

  test('average loses', () {
    final loses = LogAnalyse.calcLosesPerEntry(data);
    final res = LogAnalyse.average(loses);
    expect(res, CalculatedValue(date: data[1].date, value: -10));
  });

  test('average loses per day', () {
    final days = DateTimeRange(start: data.first.date, end: data.last.date)
        .duration
        .inDays;
    expect(days, 4);
    expect(LogAnalyse.averageLosesPerDay(data),
        CalculatedValue(date: data.last.date, value: 58 / 4));
  });
}
