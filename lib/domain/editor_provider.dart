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

  save() {
    if (state != null) {
      ref.read(logProvider.notifier).updateEntry(state!);
    }
  }

  calculateVolume({required int sounding}) {
    final vol = (ref.read(soundingTableProvider)[sounding] ?? 0) * 1.0;
    state = state?.copyWith(volume: vol);
  }

  calculateVolumeByUllage({required int ullage}) {
    final maxSounding = ref.read(soundingTableProvider).keys.last;
    if(ullage < maxSounding){
      calculateVolume(sounding: maxSounding - ullage);
    }
    else{
      calculateVolume(sounding: 0);
    }
  }
}
