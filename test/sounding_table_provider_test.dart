import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydr_leak_tracker/domain/sounding_table_db_provider.dart';
import 'package:hydr_leak_tracker/domain/sounding_table_provider.dart';
import 'package:mockito/mockito.dart';

import 'log_test.mocks.dart';

main() {
  MockIdbService db = MockIdbService();
  ProviderContainer ref = ProviderContainer();

  setUp(() {});

  test('load sounding table', () async {
    db = MockIdbService();
    const length = 10;
    final table = List.generate(length, (index) => {'$index': index * 3});
    final stream = Stream.fromIterable(table.map((e) => e)).asBroadcastStream();
    when(db.getAllEntries())
        .thenAnswer((_) => Stream.fromIterable(table.map((e) => e)));

    ref = ProviderContainer(
        overrides: [soundingTableDbProvider.overrideWith((ref) => db)]);
    ref.listen(soundingTableProvider, (_, __) {}, fireImmediately: true);

    await for (final i in stream) {
      if (i == length) {
        expect(ref.read(soundingTableProvider).length, length);
      }
    }
  });
}
