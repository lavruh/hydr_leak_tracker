import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/data/IDbService.dart';
import 'package:hydr_leak_tracker/data/csv_db_service.dart';

final soundingTableDbProvider = FutureProvider<IdbService>((ref) async {
  final db = CsvDbService();
  db.init(
      file: File(
          '/home/lavruh/AndroidStudioProjects/hydr_leak_tracker/test/testdata/test_sounding_table.csv'));
  return db;
});
