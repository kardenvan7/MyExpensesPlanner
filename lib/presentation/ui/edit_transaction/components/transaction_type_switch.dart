import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';

class TransactionTypeSwitch extends StatelessWidget {
  const TransactionTypeSwitch({
    required this.type,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final TransactionType type;
  final void Function(TransactionType type) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 0, left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getTextByType(
              context: context,
              type: type,
            ),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          FlutterSwitch(
            value: _getValueByType(type: type),
            onToggle: (bool value) {
              onChanged(_getTypeByValue(value: value));
            },
            activeColor: Colors.green,
            inactiveColor: Colors.red,
          ),
        ],
      ),
    );
  }

  bool _getValueByType({required TransactionType type}) {
    switch (type) {
      case TransactionType.income:
        return true;

      case TransactionType.expense:
        return false;
    }
  }

  TransactionType _getTypeByValue({required bool value}) {
    return value ? TransactionType.income : TransactionType.expense;
  }

  String _getTextByType({
    required BuildContext context,
    required TransactionType type,
  }) {
    switch (type) {
      case TransactionType.income:
        return AppLocalizationsWrapper.of(context).income;

      case TransactionType.expense:
        return AppLocalizationsWrapper.of(context).expense;
    }
  }
}
