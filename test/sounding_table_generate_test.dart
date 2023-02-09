import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('generate table', () {
    final soundings = [0, 343, 654];
    final volumes = [0, 1000, 2000];
    const precision = 100;

    final res = generateSoundingTable(
        soundings: soundings, volumes: volumes, precision: precision);

    expect(res.length, precision * (soundings.length - 1));
    final str = const ListToCsvConverter().convert(res);
    File('path').writeAsString(str);
  });
}

List<List<int>> generateSoundingTable({
  required List soundings,
  required List volumes,
  required int precision,
}) {
  if (soundings.length != volumes.length) {
    throw Exception('lists are not same length');
  }
  List<List<int>> out = [];
  for (int e = 0; e < soundings.length - 1; e++) {
    final soundingStep =
        (((soundings[e + 1] - soundings[e]) / precision) as double).round();
    final volumeStep =
        (((volumes[e + 1] - volumes[e]) / precision) as double).round();
    for (int i = 0; i < precision; i++) {
      out.add([soundings[e] + soundingStep * i, volumes[e] + volumeStep * i]);
    }
  }
  return out;
}
