import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/models/transaction.dart';

class LastWeekTransactions extends StatelessWidget {
  const LastWeekTransactions({
    required this.lastWeekTransactions,
    Key? key,
  }) : super(key: key);

  final List<Transaction> lastWeekTransactions;
  double get maxAmount {
    return lastWeekTransactions.fold(
      0,
      (previousValue, element) => element.amount + previousValue,
    );
  }

  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

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
                maxAmount: maxAmount,
              );
            },
          ).reversed.toList(),
        ));
  }
}

class OneDayTransactionsColumn extends StatelessWidget {
  const OneDayTransactionsColumn({
    required this.transactions,
    required this.title,
    required this.maxAmount,
    Key? key,
  }) : super(key: key);

  final List<Transaction> transactions;
  final String title;
  final double maxAmount;

  int get amount {
    return transactions
        .fold(0, (previousValue, element) => element.amount)
        .toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 15) / 8,
      child: Column(
        children: [
          Text(title),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.hardEdge,
              width: 16,
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: maxAmount != 0 ? amount / maxAmount : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '$amount 12313',
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
