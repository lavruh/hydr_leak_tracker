import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/data/IDbService.dart';
import 'package:hydr_leak_tracker/domain/log_db_provider.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';

final logProvider = StateNotifierProvider<LogNotifier, List<LogEntry>>((ref) {
  LogNotifier notifier = LogNotifier();
  ref.watch(logDbProvider).whenData((value) => notifier.setDb(value));
  return notifier;
});

class LogNotifier extends StateNotifier<List<LogEntry>> {
  LogNotifier() : super([]);
  IdbService? _db;
  final table = 'log';

  setDb(IdbService value) {
    _db = value;
    getAllEntries();
  }

  getAllEntries() async {
    if (_db != null) {
      await for (final map in _db!.getAllEntries()) {
        state = [...state, LogEntry.fromMap(map)];
      }
    }
    _sortState();
  }

  updateEntry(LogEntry entry) async {
    final index = state.indexWhere((element) => element.id == entry.id);
    if (-1 == index) {
      state = [entry, ...state];
    } else {
      state.removeAt(index);
      state.insert(index, entry);
      _sortState();
    }
    await _db?.updateEntry(entry: entry.toMap(), table: table);
  }

  removeEntry(String id) async {
    state.removeWhere((e) => e.id == id);
    await _db?.removeEntry(id: id, table: table);
  }

  int getEntryIndex(int id) {
    return state.indexWhere((element) {
      return element.date.millisecondsSinceEpoch == id;
    });
  }

  void _sortState() {
    List<LogEntry> tmp = state;
    tmp.sort((a, b) {
      return b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch;
    });
    state = [...tmp];
  }
}
