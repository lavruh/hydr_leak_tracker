import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';

final loadedShowTrend =
    StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'loadedShowTrend',
    defaultVal: true,
  );
});

final loadedShowLine =
    StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'loadedShowLine',
    defaultVal: true,
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
