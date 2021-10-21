import 'package:flutter/material.dart';
import 'package:my_expenses_planner/models/transaction.dart';

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

  double get amount {
    return transactions.fold(
        0, (previousValue, element) => element.amount + previousValue);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 15) / 8,
      child: Column(
        children: [
          Text(title),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.hardEdge,
              width: 16,
              margin: const EdgeInsets.symmetric(vertical: 8),
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
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                      topLeft: Radius.circular(amount == maxAmount ? 8 : 0),
                      topRight: Radius.circular(amount == maxAmount ? 8 : 0),
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
                amount.toStringAsFixed(1),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
