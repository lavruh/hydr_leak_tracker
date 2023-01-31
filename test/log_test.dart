import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydr_leak_tracker/data/IDbService.dart';
import 'package:hydr_leak_tracker/domain/log.dart';
import 'package:hydr_leak_tracker/domain/log_db_provider.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'log_test.mocks.dart';

class Listener extends Mock {
  void call(List<LogEntry>? previous, List<LogEntry> value);
}

@GenerateMocks([IdbService])
main() {
  MockIdbService db = MockIdbService();
  ProviderContainer ref = ProviderContainer();

  setUp(() {
    db = MockIdbService();
    ref =
        ProviderContainer(overrides: [logDbProvider.overrideWith((ref) => db)]);
    ref.listen(logProvider, Listener(), fireImmediately: true);
  });

  test('add log entry', () async {
    final entry = LogEntry.now(
        sounding: 1,
        volume: 0,
        remark: 'remark',
        operation: ShipOperation.loaded);

    await ref.read(logProvider.notifier).updateEntry(entry);

    expect(ref.read(logProvider).length, 1);
    expect(ref.read(logProvider), contains(entry));
    verify(db.updateEntry(entry: entry.toMap(), table: 'log')).called(1);
  });

  test('update entry in log', () async {
    final entry = LogEntry.now(
        sounding: 1,
        volume: 0,
        remark: 'remark',
        operation: ShipOperation.loaded);
    await ref.read(logProvider.notifier).updateEntry(entry);
    expect(ref.read(logProvider).length, 1);
    final entryUpdated = entry.copyWith(sounding: 30);
    await ref.read(logProvider.notifier).updateEntry(entryUpdated);
    expect(ref.read(logProvider).length, 1);
    expect(ref.read(logProvider), contains(entryUpdated));
    verify(db.updateEntry(entry: entry.toMap(), table: 'log')).called(1);
    verify(db.updateEntry(entry: entryUpdated.toMap(), table: 'log')).called(1);
  });

  test('remove entry', () async {
    final sut = ref.read(logProvider.notifier);
    final entry = LogEntry.now(
        sounding: 1,
        volume: 0,
        remark: 'remark',
        operation: ShipOperation.loaded);
    await sut.updateEntry(entry);
    expect(ref.read(logProvider).length, 1);
    await sut.removeEntry(entry.id);
    expect(ref.read(logProvider).length, 0);
    verify(db.removeEntry(id: entry.id, table: 'log')).called(1);
  });

  test('getAll entries from db', () async {
    final sut = ref.read(logProvider.notifier);
    final entry = LogEntry.now(
        sounding: 1,
        volume: 0,
        remark: 'remark',
        operation: ShipOperation.loaded);
    final entries = [entry, entry.copyWith(id: '2')];
    when(db.getAllEntries())
        .thenAnswer((_) => Stream.fromIterable(entries.map((e) => e.toMap())));
    await sut.getAllEntries();
    expect(ref.read(logProvider).length, 2);
  });
}
