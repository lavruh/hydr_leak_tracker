import 'dart:io';

import 'package:csv/csv.dart';
import 'package:hydr_leak_tracker/data/IDbService.dart';

class CsvDbService implements IdbService {
  Map<String, dynamic> cache = {};
  late File file;
  bool _hasHeaders = false;

  @override
  Stream<Map<String, dynamic>> getAllEntries() async* {
    final csv = await file.readAsString();
    final data = const CsvToListConverter().convert(csv);
    List? headers;

    for (int i = 0; i < data.length; i++) {
      late Map<String, dynamic> out;
      final row = data[i];
      if (_hasHeaders) {
        if (i == 0) {
          headers = row;
          continue;
        } else {
          if (headers == null) {
            throw Exception('Wrong file format');
          }
          out = _convertCsvToMap(headers, row);
          cache.putIfAbsent(out.values.first, () => out);
        }
      } else {
        if (data[i].length >= 2) {
          final key = data[i][0];
          final value = data[i][1];
          out = {'$key': value};
          cache.putIfAbsent('$key', () => value);
        }
      }
      yield out;
    }
  }

  Map<String, dynamic> _convertCsvToMap(
      List<dynamic> headers, List<dynamic> row) {
    Map<String, dynamic> out = {};
    for (int i = 0; i < headers.length; i++) {
      final isFieldId = i == 0;
      final field = headers[i];
      if (isFieldId) {
        out[field] = '${row[i]}';
      } else {
        out[field] = row[i];
      }
    }
    return out;
  }

  @override
  init({required File file, bool hasHeaders = false}) {
    _hasHeaders = hasHeaders;
    this.file = file;
  }

  @override
  Future<void> removeEntry({required String id, required String table}) async {
    if (cache.containsKey(id)) {
      cache.remove(id);
      final out = _convertCacheToCsv();
      await _writeDataToFile(out);
    } else {
      throw Exception('No entry with id: $id found');
    }
  }

  @override
  Future<void> updateEntry(
      {required Map<String, dynamic> entry, required String table}) async {
    String key = '';
    if (_hasHeaders == false) {
      key = entry.keys.first;
      cache[key] = entry.values.first;
    } else {
      key = entry.values.first;
      cache[key] = entry;
    }
    final out = _convertCacheToCsv();
    await _writeDataToFile(out);
  }

  List<List<dynamic>> _convertCacheToCsv() {
    List<List<dynamic>> out = [];
    if(cache.isEmpty) return out;
    if (_hasHeaders) {
      out.add([...cache.values.first.keys]);
      cache.forEach((key, value) {
        out.add([...(value as Map<String, dynamic>).values]);
      });
    } else {
      cache.forEach((key, value) {
        out.add([key, value]);
      });
    }
    return out;
  }

  _writeDataToFile(List<List<dynamic>> out) async {
    final outData = const ListToCsvConverter().convert(out);
    await file.writeAsString(outData);
  }
}
