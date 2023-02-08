import 'package:flutter/material.dart';

class DataInputField extends StatelessWidget {
  const DataInputField({
    Key? key,
    required this.initValue,
    this.keyboardType,
    required this.labelText,
    this.onConfirmedInt,
    this.onConfirmedString,
  }) : super(key: key);
  final String initValue;
  final TextInputType? keyboardType;
  final String labelText;
  final Function(int val)? onConfirmedInt;
  final Function(String val)? onConfirmedString;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(initValue),
      initialValue: initValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: labelText),
      onFieldSubmitted: (v) {
        if (onConfirmedString != null) {
          onConfirmedString!(v);
        }
        try {
          final digit = int.parse(v);
          onConfirmedInt!(digit);
        } catch (e) {}
      },
    );
  }
}
