import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';
import 'package:hydr_leak_tracker/ui/widgets/setting_checkbox_widget.dart';
import 'package:hydr_leak_tracker/ui/widgets/settings_color_picker_widget.dart';

class SettingsGraphicLineWidget extends ConsumerWidget {
  const SettingsGraphicLineWidget({
    super.key,
    required this.title,
    required this.colorValueProvider,
    required this.showTrendLineProvider,
    required this.showLineProvider,
  });

  final String title;
  final StateNotifierProvider<SettingNotifier<int>, int> colorValueProvider;
  final StateNotifierProvider<SettingNotifier<bool>, bool>
      showTrendLineProvider;
  final StateNotifierProvider<SettingNotifier<bool>, bool> showLineProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 70,
      child: Card(
          elevation: 3,
          child: ListTile(
            title: Text(title),
            subtitle: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: SettingCheckboxWidget(
                    title: 'Show line',
                    provider: showLineProvider,
                  ),
                ),
                SettingsColorPickerWidget(
                  colorValueProvider: colorValueProvider,
                  title: 'Line color',
                ),
                SizedBox(
                  width: 150,
                  child: SettingCheckboxWidget(
                    title: 'Show trend',
                    provider: showTrendLineProvider,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
