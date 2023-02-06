import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydr_leak_tracker/data/csv_db_service.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'csv_db_service_test.mocks.dart';

@GenerateMocks([File])
main() {
  CsvDbService sut = CsvDbService();
  MockFile mockFile = MockFile();

  setUp(() {
    sut = CsvDbService();
    mockFile = MockFile();
  });

  test('add data with field names', () async {
    final newEntry = LogEntry.now(
        sounding: 1,
        volume: 2,
        remark: 'remark',
        operation: ShipOperation.loaded);
    when(mockFile.writeAsString(any))
        .thenAnswer((realInvocation) async => mockFile);
    sut.init(file: mockFile, hasHeaders: true);

    await sut.updateEntry(entry: newEntry.toMap(), table: 'log');

    final data = [
      newEntry.toMap().keys.toList(),
      newEntry.toMap().values.toList(),
    ];

    expect(sut.cache, isNotEmpty);
    verify(mockFile.writeAsString(
      const ListToCsvConverter().convert(data),
      mode: anyNamed('mode'),
      encoding: anyNamed('encoding'),
      flush: anyNamed('flush'),
    )).called(1);
  });

  test('add entry and update entry', () async {
    final data = List.generate(10, (i) => ['$i', i * 2]);

    when(mockFile.readAsString(encoding: anyNamed('encoding')))
        .thenAnswer((_) async => const ListToCsvConverter().convert(data));
    when(mockFile.writeAsString(any))
        .thenAnswer((realInvocation) async => mockFile);
    final newEntry = {"22": 25};
    sut.init(file: mockFile);

    expect(
        sut.getAllEntries(),
        emitsInOrder([
          emitsThrough({"9": 18})
        ]));
    await pumpEventQueue(times: 20);

    expect(sut.cache, isNotEmpty);
    await sut.updateEntry(entry: newEntry, table: 'sounding');
    await pumpEventQueue(times: 20);

    final correctData = const ListToCsvConverter().convert([
      ...data,
      [22, 25]
    ]);
    verify(mockFile.writeAsString(
      correctData,
      mode: anyNamed('mode'),
      encoding: anyNamed('encoding'),
      flush: anyNamed('flush'),
    )).called(1);

    final updateEntry = {'1': 100};
    final data2 = [
      data[0],
      ['1', 100],
      ...data.getRange(2, data.length)
    ];
    final correctDataUpdated = const ListToCsvConverter().convert([
      ...data2,
      [22, 25]
    ]);

    await sut.updateEntry(entry: updateEntry, table: 'sounding');
    verify(mockFile.writeAsString(
      correctDataUpdated,
      mode: anyNamed('mode'),
      encoding: anyNamed('encoding'),
      flush: anyNamed('flush'),
    )).called(1);
  });

  test('get all entries from file sounding table', () async {
    final data = List.generate(10, (i) => ['$i', i * 2]);
    when(mockFile.readAsString())
        .thenAnswer((_) async => const ListToCsvConverter().convert(data));

    sut.init(file: mockFile);

    List res = [];
    for (final i in data) {
      res.add({'${i[0]}': i[1]});
    }
    expect(sut.getAllEntries(), emitsInOrder(res));
    await pumpEventQueue();

    expect(sut.cache.entries.length, 10);
  });

  test('get all entries from file log', () async {
    final entry1 = LogEntry.now(
        sounding: 1,
        volume: 2,
        remark: 'remark',
        operation: ShipOperation.discharging);
    final entry2 = entry1.copyWith(sounding: 11, id: 'e2');
    final data = [
      entry1.toMap().keys.toList(),
      entry1.toMap().values.toList(),
      entry2.toMap().values.toList(),
    ];
    when(mockFile.readAsString())
        .thenAnswer((_) async => const ListToCsvConverter().convert(data));

    sut.init(file: mockFile, hasHeaders: true);

    expect(
        sut.getAllEntries(),
        emitsInOrder([
          entry1.toMap(),
          entry2.toMap(),
        ]));
    await pumpEventQueue();
    expect(sut.cache.entries.length, 2);
  });

  test('remove entry', () async {
    final entry1 = LogEntry.now(
        sounding: 1,
        volume: 2,
        remark: 'remark',
        operation: ShipOperation.discharging);
    final entry2 = entry1.copyWith(sounding: 11);
    final data = [
      entry1.toMap().keys.toList(),
      entry1.toMap().values.toList(),
      entry2.toMap().values.toList(),
    ];
    when(mockFile.readAsString())
        .thenAnswer((_) async => const ListToCsvConverter().convert(data));
    when(mockFile.writeAsString(any))
        .thenAnswer((realInvocation) async => mockFile);

    sut.init(file: mockFile, hasHeaders: true);

    expect(() => sut.removeEntry(id: entry1.id, table: 'sounding'),
        throwsException);

    expect(
        sut.getAllEntries(),
        emitsInOrder([
          entry1.toMap(),
          entry2.toMap(),
        ]));
    await pumpEventQueue();

    await sut.removeEntry(id: entry1.id, table: 'sounding');
  });
}
