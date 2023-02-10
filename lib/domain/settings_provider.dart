import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = FutureProvider<SharedPreferences>(
        (ref) async => await SharedPreferences.getInstance());

final soundingTableFilePath =
StateNotifierProvider<SettingNotifier<String>, String>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'soundingTableFilePath',
    defaultVal: '',
  );
});

final logFilePath =
StateNotifierProvider<SettingNotifier<String>, String>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'logFilePath',
    defaultVal: '',
  );
});

final dredgingEntriesColor =
StateNotifierProvider<SettingNotifier<int>, int>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'dredgingEntriesColor',
    defaultVal: Colors.green.value,
  );
});

final emptyEntriesColor =
StateNotifierProvider<SettingNotifier<int>, int>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'emptyEntriesColor',
    defaultVal: Colors.blue.value,
  );
});

final loadedEntriesColor =
StateNotifierProvider<SettingNotifier<int>, int>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'loadedEntriesColor',
    defaultVal: Colors.yellow.value,
  );
});

final dischargingEntriesColor =
StateNotifierProvider<SettingNotifier<int>, int>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'dischargingEntriesColor',
    defaultVal: Colors.red.value,
  );
});

class SettingNotifier<T> extends StateNotifier<T> {
  final SharedPreferences? preferences;
  final String key;
  final T defaultVal;

  SettingNotifier({
    this.preferences,
    required this.key,
    required this.defaultVal,
  }) : super(preferences?.get(key) != null
      ? (preferences?.get(key) as T)
      : defaultVal);

  setValue(T value) {
    state = value;
    if (value.runtimeType == double) {
      preferences?.setDouble(key, value as double);
    }
    if (value.runtimeType == int) {
      preferences?.setInt(key, value as int);
    }
    if (value.runtimeType == String) {
      preferences?.setString(key, value as String);
    }
    if (value.runtimeType == bool) {
      preferences?.setBool(key, value as bool);
    }
  }
}
