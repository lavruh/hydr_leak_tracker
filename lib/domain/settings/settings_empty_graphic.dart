import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';

final emptyShowTrend =
StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'emptyShowTrend',
    defaultVal: true,
  );
});


final emptyShowLine =
StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'emptyShowLine',
    defaultVal: true,
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
