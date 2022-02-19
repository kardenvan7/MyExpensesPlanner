import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';

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

  double get amountForDay {
    return transactions.fold(
      0,
      (previousValue, element) => element.amount + previousValue,
    );
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
                heightFactor: maxAmount != 0 ? amountForDay / maxAmount : 0,
                child: BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        color: state.secondaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(8),
                          bottomRight: const Radius.circular(8),
                          topLeft: Radius.circular(
                              amountForDay == maxAmount ? 8 : 0),
                          topRight: Radius.circular(
                              amountForDay == maxAmount ? 8 : 0),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5.0),
              child: AutoSizeText(
                amountForDay.toInt().toString(),
                minFontSize: 8,
                maxFontSize: 14,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
