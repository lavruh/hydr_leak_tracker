import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';

final dredgingShowTrend =
    StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'dredgingShowTrend',
    defaultVal: true,
  );
});

final dredgingShowLine =
    StateNotifierProvider<SettingNotifier<bool>, bool>((ref) {
  final preferences = ref.watch(settingsProvider);
  return SettingNotifier(
    preferences: preferences.value,
    key: 'dredgingShowLine',
    defaultVal: true,
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
