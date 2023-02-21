import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/datetime_filtered_log_provider.dart';
import 'package:hydr_leak_tracker/domain/editor_provider.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/domain/log_utils.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_discharging_graphic.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_dredging_graphic.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_empty_graphic.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_loaded_graphic.dart';
import 'package:hydr_leak_tracker/ui/widgets/log_entry_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LogWidget extends ConsumerWidget {
  const LogWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(filteredByDateLog);
    final scrollController = ref.read(logScrollControllerProvider);
    return ScrollablePositionedList.builder(
      itemScrollController: scrollController,
      itemBuilder: (context, i) => LogEntryWidget(
        entry: log[i],
        onTap: () {
          ref.read(editorProvider.notifier).setState(log[i]);
        },
        selectedColor: _isSelected(i, ref)
            ? _getEntryColor(log[i].operation.index, ref)
            : null,
      ),
      itemCount: log.length,
    );
  }

  bool _isSelected(int i, WidgetRef ref) {
    return i == ref.watch(logSelectedItemProvider);
  }

  Color? _getEntryColor(int operation, WidgetRef ref) {
    if (operation == ShipOperation.loaded.index) {
      return Color(ref.watch(loadedEntriesColor));
    }
    if (operation == ShipOperation.empty.index) {
      return Color(ref.watch(emptyEntriesColor));
    }
    if (operation == ShipOperation.dredging.index) {
      return Color(ref.watch(dredgingEntriesColor));
    }
    if (operation == ShipOperation.discharging.index) {
      return Color(ref.watch(dischargingEntriesColor));
    }
    return null;
  }
}
