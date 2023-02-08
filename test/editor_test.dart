import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydr_leak_tracker/domain/editor_provider.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/domain/sounding_table_provider.dart';

main() {
  ProviderContainer ref = ProviderContainer();
  final table = {0: 0, 1: 3, 2: 6, 3: 9};

  setUp(() {
    ref = ProviderContainer(
        overrides: [soundingTableProvider.overrideWith((ref) => table)]);
    ref.listen(soundingTableProvider, (_, __) {}, fireImmediately: true);
  });

  test('calculate volume by sounding', () {
    final sut = ref.read(editorProvider.notifier);
    final entry = LogEntry.now(
        volume: 0,
        remark: 'remark',
        operation: ShipOperation.discharging);
    const soundingIndex = 2;
    sut.setState(entry);
    expect(ref.read(editorProvider), isNotNull);

    sut.calculateVolume(sounding: table.keys.elementAt(soundingIndex));
    expect(ref.read(editorProvider)?.volume, table[soundingIndex]);

    sut.calculateVolume(sounding: table.length + 1);
    expect(ref.read(editorProvider)?.volume, 0);
  });

  test('calculate volume by ullage', () {
    final sut = ref.read(editorProvider.notifier);
    final entry = LogEntry.now(
        volume: 0,
        remark: 'remark',
        operation: ShipOperation.discharging);
    const ullage = 1;
    final sounding = table.keys.last - ullage;
    sut.setState(entry);
    expect(ref.read(editorProvider), isNotNull);

    sut.calculateVolumeByUllage(ullage: ullage);
    expect(ref.read(editorProvider)?.volume, table[sounding]);
  });

  test('sounding ullage converting', () {
    final sut = ref.read(editorProvider.notifier);
    const ullage = 1;
    final res = sut.convertSoundingUllage(ullage);
    expect(res, table.keys.last - ullage);
  });

  test('find sounding by volume', () {
    final sut = ref.read(editorProvider.notifier);
    final entry = table.entries.elementAt(2);
    final res = sut.findSoundingByVolume(volume: entry.value);
    expect(res, entry.key);
  });
}
