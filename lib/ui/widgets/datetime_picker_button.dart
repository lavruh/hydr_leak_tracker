import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerButton extends StatelessWidget {
  const DateTimePickerButton({
    super.key,
    required this.date,
    required this.onChanged,
  });

  final DateTime date;
  final Function(DateTime val) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _pickupDateDialog(context),
      child: Text(DateFormat('y-MM-dd\nHH:mm').format(date)),
    );
  }

  void _pickupDateDialog(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(date.year - 3),
        lastDate: DateTime(date.year + 1));
    if (newDate != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
      );
      if (time != null) {
        onChanged(newDate.copyWith(
          hour: time.hour,
          minute: time.minute,
        ));
      }
    }
  }
}
