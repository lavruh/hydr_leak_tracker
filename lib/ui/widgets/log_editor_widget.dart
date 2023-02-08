import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';
import 'package:intl/intl.dart';
import 'package:hydr_leak_tracker/domain/editor_provider.dart';

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
              child: TextButton(
            onPressed: () => _pickupDateDialog(context, ref, entry),
            child: Text(DateFormat('y-MM-dd\nHH:mm').format(entry.date)),
          )),
          Flexible(
              flex: 1,
              child: TextFormField(
                key: Key(entry.id + entry.volume.toString()),
                initialValue: editor.getSounding.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Sounding [mm]'),
                onFieldSubmitted: (v) => _calculateVolume(v, ref),
              )),
          Flexible(
              flex: 1,
              child: TextFormField(
                key: Key(entry.id + entry.volume.toString()),
                initialValue: editor.getUllage.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ullage [mm]'),
                onFieldSubmitted: (v) =>
                    _calculateVolume(v, ref, isUllage: true),
              )),
          Flexible(child: Text("${entry.volume} L")),
          Flexible(
              flex: 1,
              child: DropdownButtonFormField<int>(
                value: entry.operation.index,
                hint: const Text('Ships operation:'),
                items: ShipOperation.values
                    .map((e) => DropdownMenuItem<int>(
                          value: e.index,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (int? val) {
                  if (val != null) {
                    _updateEntry(
                        entry.copyWith(
                          operation: ShipOperation.values[val],
                        ),
                        ref);
                  }
                },
              )),
          Flexible(
              flex: 3,
              child: TextFormField(
                key: Key(entry.id),
                initialValue: entry.remark,
                decoration: const InputDecoration(labelText: 'Remark'),
                onChanged: (String val) =>
                    _updateEntry(entry.copyWith(remark: val), ref),
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

  void _pickupDateDialog(
      BuildContext context, WidgetRef ref, LogEntry entry) async {
    final initDate = entry.date;
    final date = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(initDate.year - 3),
        lastDate: DateTime(initDate.year + 1));
    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initDate.hour, minute: initDate.minute),
      );
      if (time != null) {
        ref.read(editorProvider.notifier).updateState(entry.copyWith(
                date: date.copyWith(
              hour: time.hour,
              minute: time.minute,
            )));
      }
    }
  }

  void _calculateVolume(String value, WidgetRef ref, {bool isUllage = false}) {
    try {
      final int val = int.parse(value);
      if (isUllage) {
        ref.read(editorProvider.notifier).calculateVolumeByUllage(ullage: val);
      } else {
        ref.read(editorProvider.notifier).calculateVolume(sounding: val);
      }
    } on FormatException catch (e) {
      print(e);
    }
  }

  void _saveEntry(WidgetRef ref) {
    ref.read(editorProvider.notifier).save();
  }

  _updateEntry(LogEntry val, WidgetRef ref) {
    ref.read(editorProvider.notifier).updateState(val);
  }
}
