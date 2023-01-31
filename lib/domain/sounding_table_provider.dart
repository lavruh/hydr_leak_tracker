import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/sounding_table_db_provider.dart';

final soundingTableProvider = StateProvider<Map<int, int>>((ref) {
  Map<int, int> table = {};
  ref.watch(soundingTableDbProvider).whenData((db) async {
    await for (final data in db.getAllEntries()) {
      table.addAll(data.map(
        (key, value) {
          assert(value is int);
          return MapEntry(int.parse(key), value);
        },
      ));
    }
  });
  return table;
});
