import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/datetime_filtered_log_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final logScrollControllerProvider =
    StateProvider<ItemScrollController>((ref) => ItemScrollController());

final logSelectedItemProvider =
    StateNotifierProvider<LogSelectedItemNotifier, int>(
        (ref) => LogSelectedItemNotifier(ref));

class LogSelectedItemNotifier extends StateNotifier<int> {
  LogSelectedItemNotifier(this.ref) : super(0);
  final StateNotifierProviderRef ref;

  selectItem(int logEntryDateMs) {
    final index = ref.read(filteredByDateLog).indexWhere((element) {
      return element.date.millisecondsSinceEpoch == logEntryDateMs;
    });
    if (index != -1) {
      ref
          .read(logScrollControllerProvider)
          .scrollTo(index: index, duration: const Duration(milliseconds: 500));
      state = index;
    }
  }
}
