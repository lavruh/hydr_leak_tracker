import 'dart:io';

abstract class IdbService {
  init({required File file, bool hasHeaders});
  Stream<Map<String, dynamic>> getAllEntries();
  Future<void> updateEntry(
      {required Map<String, dynamic> entry, required String table});
  Future<void> removeEntry({required String id, required String table});
}
