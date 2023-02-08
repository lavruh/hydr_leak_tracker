import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:hydr_leak_tracker/ui/widgets/data_input_field.dart';
import 'package:hydr_leak_tracker/ui/widgets/ship_operation_select_widget.dart';
import 'package:hydr_leak_tracker/domain/editor_provider.dart';

import 'datetime_picker_button.dart';

class LogEditorWidget extends ConsumerWidget {
  const LogEditorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(editorProvider);
    final editor = ref.read(editorProvider.notifier);
    if (entry == null) {
      return Container();
    }
    return Card(
      elevation: 5,
      color: Colors.white60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Flexible(
              child: DateTimePickerButton(
            date: entry.date,
            onChanged: (DateTime newDate) =>
                editor.updateState(entry.copyWith(date: newDate)),
          )),
          Flexible(
              flex: 1,
              child: DataInputField(
                initValue: '${editor.getSounding}',
                labelText: 'Sounding [mm]',
                onConfirmedInt: (sounding) =>
                    editor.calculateVolume(sounding: sounding),
              )),
          Flexible(
              flex: 1,
              child: DataInputField(
                initValue: '${editor.getUllage}',
                labelText: 'Ullage [mm]',
                onConfirmedInt: (ullage) =>
                    editor.calculateVolumeByUllage(ullage: ullage),
              )),
          Flexible(child: Text("${entry.volume} L")),
          Flexible(
              flex: 1,
              child: ShipOperationSelectWidget(
                operation: entry.operation,
                onChanged: (int val) => editor.updateState(entry.copyWith(
                  operation: ShipOperation.values[val],
                )),
              )),
          Flexible(
              flex: 3,
              child: DataInputField(
                initValue: entry.remark,
                labelText: 'Remark',
                onConfirmedString: (String val) =>
                    editor.updateState(entry.copyWith(remark: val)),
              )),
          ref.watch(editorHasToSaveProvider)
              ? Flexible(
                  child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _saveEntry(ref),
                ))
              : Container(),
        ]),
      ),
    );
  }

  void _saveEntry(WidgetRef ref) {
    ref.read(editorProvider.notifier).save();
  }
}
