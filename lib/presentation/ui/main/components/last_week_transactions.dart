import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';

import 'one_day_transactions_column.dart';

class LastWeekTransactions extends StatelessWidget {
  const LastWeekTransactions({
    required this.lastWeekTransactions,
    Key? key,
  }) : super(key: key);

  final List<Transaction> lastWeekTransactions;

  double get max {
    double max = 0;

    for (var transaction in lastWeekTransactions) {
      if (max < transaction.amount) {
        max = transaction.amount;
      }
    }

    return max;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      clipBehavior: Clip.hardEdge,
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(
          7,
          (int index) {
            final DateTime date = DateTime.now().subtract(
              Duration(
                days: index,
              ),
            );

            return OneDayTransactionsColumn(
              transactions: lastWeekTransactions
                  .where((element) => element.date.day == date.day)
                  .toList(),
              title: DateFormat('EEE').format(date),
              maxAmount: max,
            );
          },
        ).reversed.toList(),
      ),
    );
  }
}
