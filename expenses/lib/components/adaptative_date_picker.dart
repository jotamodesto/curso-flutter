import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const AdaptativeDatePicker({
    required this.onDateChanged,
    required this.selectedDate,
    super.key,
  });

  _showDatePicker(BuildContext context) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    onDateChanged(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SizedBox(
        height: 150,
        child: CupertinoDatePicker(
          onDateTimeChanged: onDateChanged,
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          minimumDate: DateTime(2019),
          maximumDate: DateTime.now(),
        ),
      );
    }

    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Data selecionada: ${DateFormat('dd/MM/y').format(selectedDate)}',
            ),
          ),
          TextButton(
            onPressed: () => _showDatePicker(context),
            child: const Text('Selecionar data'),
          )
        ],
      ),
    );
  }
}
