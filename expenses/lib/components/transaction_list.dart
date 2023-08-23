import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemoved;

  TransactionList(
    this.transactions, {
    required this.onRemoved,
    super.key,
  }) {
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Nenhuma Transação Cadastrada!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: constraints.maxHeight * .6,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
              )
            ],
          );
        },
      );
    }

    return GroupedListView(
      elements: transactions,
      groupBy: (tr) => DateUtils.dateOnly(tr.date),
      itemComparator: (tr1, tr2) => tr1.date.compareTo(tr2.date),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: true,
      groupSeparatorBuilder: (value) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat("EEEE, dd 'de' MMMM", 'pt_BR')
                .format(value)
                .capitalize(),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
        );
      },
      itemBuilder: (ctx, tr) {
        return TransactionItem(
          key: GlobalObjectKey(tr),
          transaction: tr,
          onRemoved: onRemoved,
        );
      },
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;

    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
