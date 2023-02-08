import 'package:flutter/material.dart';
import 'package:hydr_leak_tracker/domain/log_entry.dart';

class ShipOperationSelectWidget extends StatelessWidget {
  const ShipOperationSelectWidget(
      {Key? key, required this.operation, required this.onChanged})
      : super(key: key);
  final ShipOperation operation;
  final Function(int val) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: operation.index,
      hint: const Text('Ships operation:'),
      items: ShipOperation.values
          .map((e) => DropdownMenuItem<int>(
                value: e.index,
                child: Text(e.name),
              ))
          .toList(),
      onChanged: (int? val) {
        if (val != null) {
          onChanged(val);
        }
      },
    );
  }

}
