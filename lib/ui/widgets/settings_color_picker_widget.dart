import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/settings_provider.dart';

class SettingsColorPickerWidget extends ConsumerWidget {
  const SettingsColorPickerWidget({
    Key? key,
    required this.title,
    required this.colorValueProvider,
  }) : super(key: key);
  final String title;
  final StateNotifierProvider<SettingNotifier<int>, int> colorValueProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return Center(
                  child: SizedBox(
                      height: 300,
                      width: 600,
                      child: Card(
                        child: MaterialPicker(
                          pickerColor: Color(ref.watch(colorValueProvider)),
                          onColorChanged: (Color val) {
                            ref
                                .read(colorValueProvider.notifier)
                                .setValue(val.value);
                          },
                        ),
                      )),
                );
              });
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Icon(
              Icons.circle,
              color: Color(ref.watch(colorValueProvider)),
            ),
          ],
        ));
  }
}
