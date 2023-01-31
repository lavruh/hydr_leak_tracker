abstract class IdbService {
  Future<void> init({required String path});
  Stream<Map<String, dynamic>> getAllEntries();
  Future<void> updateEntry(
      {required Map<String, dynamic> entry, required String table});
  Future<void> removeEntry({required String id, required String table});
}
