import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/log.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';

final filterDateTimeRangeProvider =
    StateNotifierProvider<FilterDateTimeRangeNotifier, DateTimeRange>((ref) {
  return FilterDateTimeRangeNotifier();
});

class FilterDateTimeRangeNotifier extends StateNotifier<DateTimeRange> {
  FilterDateTimeRangeNotifier()
      : super(DateTimeRange(
          start: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch -
                  const Duration(days: 14).inMilliseconds),
          end: DateTime.now(),
        ));

  setDateRange(DateTimeRange val) {
    state = val;
  }

}

final filteredByDateLog = StateProvider<List<LogEntry>>((ref) {
  final log = ref.watch(logProvider);
  final range = ref.watch(filterDateTimeRangeProvider);
  final end = DateTime(range.end.year, range.end.month, range.end.day, 23, 59);
  return log
      .where((e) =>
          e.date.millisecondsSinceEpoch >= range.start.millisecondsSinceEpoch &&
          e.date.millisecondsSinceEpoch <= end.millisecondsSinceEpoch)
      .toList();
});
