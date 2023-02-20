import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';

final dischargingShowTrend =
    StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'dischargingShowTrend',
    defaultVal: true,
  );
});

final dischargingShowLine =
    StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'dischargingShowLine',
    defaultVal: true,
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
