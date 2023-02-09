import 'package:flutter/material.dart';

class SettingInputWidget extends StatelessWidget {
  const SettingInputWidget(
      {Key? key,
      required this.formKey,
      required this.value,
      required this.lableText,
      required this.alarmLevelValidator,
      required this.onSubmited})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final String value;
  final String lableText;
  final String? Function(String?) alarmLevelValidator;
  final Function(String) onSubmited;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(labelText: lableText),
      keyboardType: TextInputType.number,
      validator: alarmLevelValidator,
      onFieldSubmitted: (val) {
        if (formKey.currentState!.validate()) {
          onSubmited(val);
        }
      },
    );
  }
}
