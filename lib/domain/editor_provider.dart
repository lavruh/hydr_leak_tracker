import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/log.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/domain/sounding_table_provider.dart';

final editorProvider = StateNotifierProvider<EditorNotifier, LogEntry?>((ref) {
  return EditorNotifier(ref);
});

class EditorNotifier extends StateNotifier<LogEntry?> {
  EditorNotifier(this.ref) : super(null);
  final StateNotifierProviderRef ref;

  setState(LogEntry? val) {
    state = val;
  }

  updateState(LogEntry? val) {
    ref.read(editorHasToSaveProvider.notifier).update((state) => true);
    setState(val);
  }

  save() {
    if (state != null) {
      ref.read(logProvider.notifier).updateEntry(state!);
      ref.read(editorHasToSaveProvider.notifier).update((state) => false);
      state = null;
    }
  }

  int get getSounding {
    if (state != null) {
      return findSoundingByVolume(volume: state!.volume.toInt());
    }
    return 0;
  }

  int get getUllage {
    if (state != null) {
      final sounding = findSoundingByVolume(volume: state!.volume.toInt());
      return convertSoundingUllage(sounding);
    }
    return 0;
  }

  int findSoundingByVolume({required int volume}) {
    final values = ref.read(soundingTableProvider);
    try {
      if (values.isNotEmpty) {
        final tableEntry = values.entries.firstWhere((e) => e.value == volume);
        return tableEntry.key;
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  calculateVolume({required int sounding}) {
    final vol = (ref.read(soundingTableProvider)[sounding] ?? 0) * 1.0;
    updateState(state?.copyWith(volume: vol));
  }

  calculateVolumeByUllage({required int ullage}) {
    calculateVolume(sounding: convertSoundingUllage(ullage));
  }

  int convertSoundingUllage(int val) {
    final soundings = ref.read(soundingTableProvider).keys;
    if (soundings.isNotEmpty) {
      final maxSounding = soundings.last;
      if (val < maxSounding) {
        return maxSounding - val;
      }
    }
    return 0;
  }
}

final editorHasToSaveProvider = StateProvider<bool>((ref) => false);
