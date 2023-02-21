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

  setStartDateTime(DateTime val) {}
  setEndDateTime(DateTime? val) {
    final d = val ?? DateTime.now();
    if (d.millisecondsSinceEpoch > state.start.millisecondsSinceEpoch) {
      state = DateTimeRange(start: state.start, end: d);
    }
  }
}

final filteredByDateLog = StateProvider<List<LogEntry>>((ref) {
  final log = ref.watch(logProvider);
  final range = ref.watch(filterDateTimeRangeProvider);
  return log
      .where((e) =>
          e.date.millisecondsSinceEpoch >= range.start.millisecondsSinceEpoch &&
          e.date.millisecondsSinceEpoch <= range.end.millisecondsSinceEpoch)
      .toList();
});
