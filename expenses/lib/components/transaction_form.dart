import 'package:flutter/material.dart';
import 'adaptative_button.dart';
import 'adaptative_text_field.dart';
import 'adaptative_date_picker.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm(this.onSubmit, {super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titlecontroller = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitForm() {
    final title = _titlecontroller.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  AdaptativeTextField(
                    controller: _titlecontroller,
                    textInputAction: TextInputAction.next,
                    label: 'Título',
                  ),
                  AdaptativeTextField(
                    onSubmitted: (_) => _submitForm(),
                    controller: _valueController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    label: 'Valor (R\$)',
                  ),
                  AdaptativeDatePicker(
                    onDateChanged: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                    selectedDate: _selectedDate,
                  ),
                  AdaptativeButton(
                    onPressed: _submitForm,
                    label: 'Nova transação',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
