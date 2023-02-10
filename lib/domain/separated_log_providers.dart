import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/log.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';

final filteredByOperationLogProvider = StateProviderFamily<List<LogEntry>, ShipOperation >((ref, arg){
  return ref
      .watch(logProvider)
      .where((e) => e.operation == arg)
      .toList();
});
