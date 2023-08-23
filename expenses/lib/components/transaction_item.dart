import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onRemoved,
  });

  final Transaction transaction;
  final void Function(String p1) onRemoved;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  static const colors = [
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.black,
  ];

  late Color _backgroundColor;

  @override
  void initState() {
    int i = Random().nextInt(5);
    _backgroundColor = colors[i];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _backgroundColor,
          foregroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('R\$${widget.transaction.value}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: theme.textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat('dd MMM y').format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? TextButton.icon(
                onPressed: () => widget.onRemoved(widget.transaction.id),
                icon: const Icon(Icons.delete),
                label: const Text('Excluir'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              )
            : IconButton(
                onPressed: () => widget.onRemoved(widget.transaction.id),
                icon: const Icon(Icons.delete),
                color: theme.colorScheme.error,
              ),
      ),
    );
  }
}
