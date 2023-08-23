import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final String label;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const AdaptativeTextField({
    this.onSubmitted,
    this.controller,
    required this.label,
    this.keyboardType,
    this.textInputAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTextField.borderless(
        onSubmitted: onSubmitted,
        controller: controller,
        placeholder: label,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
      );
    }

    return TextField(
      onSubmitted: onSubmitted,
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
    );
  }
}
