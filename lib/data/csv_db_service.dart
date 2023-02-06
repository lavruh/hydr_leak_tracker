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
    final row = const CsvToListConverter().convert(csv);
    List? headers;
    for (int i = 0; i < row.length; i++) {
      if (_hasHeaders) {
        if (i == 0) {
          headers = row[i];
        } else {
          if (headers == null) {
            throw Exception('Wrong file format');
          }
          Map<String, dynamic> out = {};
          for (int key = 0; key < headers.length; key++) {
            if (key == 0) {
              out[headers[key]] = '${row[i][key]}';
            } else {
              out[headers[key]] = row[i][key];
            }
          }
          cache.putIfAbsent(out.values.first, () => out);
          yield out;
        }
      } else {
        if (row[i].length >= 2) {
          final key = row[i][0];
          final value = row[i][1];
          final map = {'$key': value};
          cache.putIfAbsent('$key', () => value);
          yield map;
        }
      }
    }
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
      List<List<dynamic>> out = [];
      cache.forEach((key, value) {
        out.add([key, value]);
      });
      await _writeDataToFile(out);
    } else {
      throw Exception('No entry with id: $id found');
    }
  }

  @override
  Future<void> updateEntry(
      {required Map<String, dynamic> entry, required String table}) async {
    String key = '';
    List<List<dynamic>> out = [];
    if (_hasHeaders == false) {
      key = entry.keys.first;
      cache[key] = entry.values.first;
      cache.forEach((key, value) {
        out.add([key, value]);
      });
    } else {
      print(entry);
      key = entry.values.first;
      cache[key] = entry;
      out.add([...entry.keys]);
      cache.forEach((key, value) {
        out.add([...(value as Map<String, dynamic>).values]);
      });
    }
    await _writeDataToFile(out);
  }

  _writeDataToFile(List<List<dynamic>> out) async {
    final outData = const ListToCsvConverter().convert(out);
    await file.writeAsString(outData);
  }
}
