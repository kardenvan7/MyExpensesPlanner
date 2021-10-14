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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      child: Column(
        children: [
          Text(title),
          Expanded(
            child: Container(
              width: 10,
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: maxAmount != 0 ? amount / maxAmount : 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          ),
          Text('$amount'),
        ],
      ),
    );
  }
}
