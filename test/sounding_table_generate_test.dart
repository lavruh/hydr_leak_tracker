import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('generate table', () {
    final soundings = [
      0,
      324,
      648,
      972,
      1060,
      1145,
      1232,
      1316,
      1402,
      1489,
      1574,
      1659,
      1749,
      1859,
      1903,
      1946
    ];
    final volumes = [
      0,
      1000,
      2000,
      3000,
      4000,
      5000,
      6000,
      7000,
      8000,
      9000,
      10000,
      11000,
      12000,
      13000,
      14000,
      15000
    ];
    const precision = 100;

    final res = generateSoundingTable(
        soundings: soundings, volumes: volumes, precision: precision);

    expect(res.length, precision * (soundings.length - 1));
    final str = const ListToCsvConverter().convert(res);
    File('/home/lavruh/AndroidStudioProjects/hydr_leak_tracker/test/testdata/sounding_table.csv').writeAsString(str);
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
