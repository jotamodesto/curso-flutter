import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const AdaptativeButton({
    required this.onPressed,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        color: theme.colorScheme.primary,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
