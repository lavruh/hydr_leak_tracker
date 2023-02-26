import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_discharging_graphic.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_dredging_graphic.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_empty_graphic.dart';
import 'package:hydr_leak_tracker/domain/settings/settings_loaded_graphic.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';
import 'package:hydr_leak_tracker/ui/utils/input_data_validators.dart';
import 'package:hydr_leak_tracker/ui/widgets/setting_input_widget.dart';
import 'package:hydr_leak_tracker/ui/widgets/settings_graphic_line_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SettingInputWidget(
                          formKey: formKey,
                          value: ref.watch(soundingTableFilePath).toString(),
                          lableText: 'Sounding table file path',
                          alarmLevelValidator: filePathValidator,
                          onSubmited: (val) => ref
                              .read(soundingTableFilePath.notifier)
                              .setValue(val)),
                      SettingInputWidget(
                          formKey: formKey,
                          value: ref.watch(logFilePath).toString(),
                          lableText: 'Log file path',
                          alarmLevelValidator: filePathValidator,
                          onSubmited: (val) =>
                              ref.read(logFilePath.notifier).setValue(val)),
                      SettingInputWidget(
                          formKey: formKey,
                          value: ref.watch(ullageSensorOffset).toString(),
                          lableText: 'Ullage sensor offset [mm]',
                          alarmLevelValidator: intTypeValidator,
                          onSubmited: (val) {
                            final offset = int.tryParse(val);
                            if (offset != null) {
                              ref
                                  .read(ullageSensorOffset.notifier)
                                  .setValue(offset);
                            }
                          }),
                    ],
                  ),
                ),
              ),
              Wrap(
                children: [
                  SettingsGraphicLineWidget(
                    title: 'Empty',
                    colorValueProvider: emptyEntriesColor,
                    showTrendLineProvider: emptyShowTrend,
                    showLineProvider: emptyShowLine,
                  ),
                  SettingsGraphicLineWidget(
                    title: 'Loaded',
                    colorValueProvider: loadedEntriesColor,
                    showTrendLineProvider: loadedShowTrend,
                    showLineProvider: loadedShowLine,
                  ),
                  SettingsGraphicLineWidget(
                    title: 'Dredging',
                    colorValueProvider: dredgingEntriesColor,
                    showTrendLineProvider: dredgingShowTrend,
                    showLineProvider: dredgingShowLine,
                  ),
                  SettingsGraphicLineWidget(
                    title: 'Discharging',
                    colorValueProvider: dischargingEntriesColor,
                    showTrendLineProvider: dischargingShowTrend,
                    showLineProvider: dischargingShowLine,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
