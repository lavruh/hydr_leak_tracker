import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/data/IDbService.dart';
import 'package:hydr_leak_tracker/data/csv_db_service.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';

final soundingTableDbProvider = FutureProvider<IdbService>((ref) async {
  final path = ref.watch(soundingTableFilePath);
  if (path.isNotEmpty && File(path).existsSync()) {
    final db = CsvDbService();
    db.init(file: File(path));
    return db;
  }
  throw Exception('Sounding table file $path does not exist. Check settings');
});
