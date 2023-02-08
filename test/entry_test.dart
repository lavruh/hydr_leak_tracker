import 'package:flutter_test/flutter_test.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';

main() {
  test('mapping entry', () {
    final entry = LogEntry.now(
        volume: 2,
        remark: 'remark',
        operation: ShipOperation.loaded);

    final map = entry.toMap();
    expect(map['id'], entry.id);
    expect(map['date'], entry.date.millisecondsSinceEpoch);
    expect(map['operation'], entry.operation.index);
    expect(map['remark'], entry.remark);
    expect(map['volume'], entry.volume);

    expect(LogEntry.fromMap(map), entry);
  });

}
