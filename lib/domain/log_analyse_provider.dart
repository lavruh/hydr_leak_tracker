import 'package:fl_chart/fl_chart.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/ui/widgets/calculated_value.dart';

class LogAnalyse {
  static CalculatedValue average(var data) {
    if (data is List<LogEntry>) {
      return _average(_convertLogEntries(data));
    }
    if (data is List<CalculatedValue>) {
      return _average(data);
    }
    throw Exception('Input data format is not supported');
  }

  static List<CalculatedValue> _convertLogEntries(List<LogEntry> data) {
    return data
        .map((e) => CalculatedValue(date: e.date, value: e.volume))
        .toList();
  }

  static CalculatedValue _average(List<CalculatedValue> data) {
    if (data.length < 2) {
      return CalculatedValue(date: DateTime.now(), value: 0);
    }
    double sum = 0;
    for (CalculatedValue entry in data) {
      sum += entry.value;
    }
    final average = sum / data.length;
    return CalculatedValue(date: data.first.date, value: average);
  }

  static List<CalculatedValue> calcLosesPerEntry(var data) {
    if (data is List<LogEntry>) {
      return _calcLosesPerEntry(_convertLogEntries(data));
    }
    if (data is List<CalculatedValue>) {
      return _calcLosesPerEntry(data);
    }
    if (data is List<FlSpot>) {
      return _calcLosesPerEntry(_convertFlSpots(data));
    }
    throw Exception('Input data format is not supported');
  }

  static List<CalculatedValue> _calcLosesPerEntry(List<CalculatedValue> data) {
    List<CalculatedValue> loses = [];
    for (int i = 1; i < data.length; i++) {
      final entry = data[i];
      final prevEntry = data[i - 1];
      loses.add(CalculatedValue(
          date: entry.date, value: entry.value - prevEntry.value));
    }
    return loses;
  }

  static double spotsDelta(FlSpot s1, FlSpot s2) {
    return s2.y - s1.y;
  }

  static List<CalculatedValue> _convertFlSpots(List<FlSpot> data) {
    return data
        .map(
          (e) => CalculatedValue(
              date: DateTime.fromMillisecondsSinceEpoch(e.x.toInt()),
              value: e.y),
        )
        .toList();
  }
}
