import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';
import 'package:hydr_leak_tracker/ui/utils/input_data_validators.dart';
import 'package:hydr_leak_tracker/ui/widgets/setting_input_widget.dart';
import 'package:hydr_leak_tracker/ui/widgets/settings_color_picker_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SettingInputWidget(
                  formKey: formKey,
                  value: ref.watch(soundingTableFilePath).toString(),
                  lableText: 'Sounding table file path',
                  alarmLevelValidator: filePathValidator,
                  onSubmited: (val) =>
                      ref.read(soundingTableFilePath.notifier).setValue(val)),
              SettingInputWidget(
                  formKey: formKey,
                  value: ref.watch(logFilePath).toString(),
                  lableText: 'Log file path',
                  alarmLevelValidator: filePathValidator,
                  onSubmited: (val) =>
                      ref.read(logFilePath.notifier).setValue(val)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SettingsColorPickerWidget(
                      colorValueProvider: emptyEntriesColor,
                      title: 'Empty',
                    ),
                    SettingsColorPickerWidget(
                      colorValueProvider: loadedEntriesColor,
                      title: 'Loaded',
                    ),
                    SettingsColorPickerWidget(
                      colorValueProvider: dredgingEntriesColor,
                      title: 'Dredging',
                    ),
                    SettingsColorPickerWidget(
                      colorValueProvider: dischargingEntriesColor,
                      title: 'Discharging',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
