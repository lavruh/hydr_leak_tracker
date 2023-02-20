import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';

class SettingCheckboxWidget extends ConsumerWidget {
  const SettingCheckboxWidget(
      {required this.title, required this.provider, Key? key})
      : super(key: key);

  final String title;
  final StateNotifierProvider<SettingNotifier<bool>, bool> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CheckboxListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        value: ref.watch(provider),
        onChanged: (val) => ref.read(provider.notifier).setValue(val ?? false));
  }
}
