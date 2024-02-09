import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputBox extends StatelessWidget {
  final int maxLength;
  final TextEditingController controller;
  final TextInputAction? action;
  final String label;
  final bool? activeValidator;
  final String? validatorLabel;
  final List<TextInputFormatter>? inputFormatter;

  const InputBox({
    super.key,
    required this.maxLength,
    required this.controller,
    this.action,
    required this.label,
    this.activeValidator,
    this.validatorLabel,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      textInputAction: action ?? TextInputAction.next,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
      ),
      validator: (value) {
        if ((value == null || value.isEmpty) && (activeValidator ?? true)) {
          return 'Please enter ${validatorLabel ?? label.toLowerCase()}';
        }
        return null;
      },
      inputFormatters: inputFormatter,
    );
  }
}
