import 'dart:io';

String? intTypeValidator(String? value) {
  final string = stringValidator(value);
  if (string != null) {
    return string;
  }
  if (int.tryParse(value!) == null) {
    return 'Value should be int';
  }
  return null;
}

String? doubleTypeValidator(String? value) {
  final string = stringValidator(value);
  if (string != null) {
    return string;
  }
  if (double.tryParse(value!) == null) {
    return 'Value should be double';
  }
  return null;
}

String? filePathValidator(String? value) {
  final string = stringValidator(value);
  if (string != null) {
    return string;
  }
  if (File(value!).existsSync() == false) {
    return 'File does not exist!';
  }
  return null;
}

String? stringValidator(String? value) {
  if (value != null) {
    if (value.isEmpty) {
      return "Field should not be empty";
    }
  }
  return null;
}
