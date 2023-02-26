import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('generate table', () {
    // final soundings = [
    //   0,
    //   324,
    //   648,
    //   972,
    //   1060,
    //   1145,
    //   1232,
    //   1316,
    //   1402,
    //   1489,
    //   1574,
    //   1659,
    //   1749,
    //   1859,
    //   1903,
    //   1600
    // ];
    // final volumes = [
    //   0,
    //   1000,
    //   2000,
    //   3000,
    //   4000,
    //   5000,
    //   6000,
    //   7000,
    //   8000,
    //   9000,
    //   10000,
    //   11000,
    //   12000,
    //   13000,
    //   14000,
    //   15000
    // ];
    final soundings = [
      0,
      75,
      301,
      411,
      501,
      586,
      671,
      757,
      843,
      930,
      1015,
      1100,
      1190,
      1300,
      1500,
      1600
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
    int lastIdx = 0;
    int lastVol = 0;
    expect(res.any((element) {
      var sounding = element[0];
      var volume = element[1];
      if (sounding < lastIdx || volume < lastVol) {
        print('$lastIdx -  $sounding     $lastVol - $volume');
        return true;
      } else {
        lastIdx = sounding;
        lastVol = volume;
        return false;
      }
    }), false);
    final str = const ListToCsvConverter().convert(res);
    File('/home/lavruh/AndroidStudioProjects/hydr_leak_tracker/test/testdata/sounding_table_v2.csv')
        .writeAsString(str);
  });

  test('gen by formula', () {
    final res = generateSoundingTableByFormula(
        maxSounding: 1600, L: 7800, precision: 1);
    print(res);
    final str = const ListToCsvConverter().convert(res);
    File('/home/lavruh/AndroidStudioProjects/hydr_leak_tracker/test/testdata/sounding_table_by_formula.csv')
        .writeAsString(str);
  });
}

List<List<int>> generateSoundingTableByFormula({
  required int maxSounding, //mm
  required int L, //mm
  required int precision,
}) {
  List<List<int>> res = [];
  const mm3toL = 1e-6;
  final r = maxSounding / 2;
  final circleArea = pi * pow(r, 2); // mm2
  final maxVolume = circleArea * L * mm3toL;
  double area = 0;
  for (int i = 0; i <= r; i += precision) {
    double alfa = 0;
    if (i <= r) {
      alfa = 2 * asin(i / r);
      area = 0.5 * pow(r, 2) * alfa - 0.5 * pow(r, 2) * sin(alfa);
    }
    res.add([i, (area * L * mm3toL).toInt()]);
  }
  for (int i = r.toInt(); i > 1; i -= precision) {
    final index = i ~/ precision - 1;
    final volume = res[index][1];
    final sounding = maxSounding - (index * precision);
    res.add([sounding, (maxVolume - volume).toInt()]);
  }
  return res;
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
        (((soundings[e + 1] - soundings[e]) / precision) as double);
    final volumeStep = (((volumes[e + 1] - volumes[e]) / precision) as double);
    assert(soundingStep != 0);
    assert(volumeStep != 0);
    for (int i = 0; i < precision; i++) {
      out.add([
        (soundings[e] + soundingStep * i).floor(),
        (volumes[e] + volumeStep * i).floor(),
      ]);
    }
  }
  return out;
}
