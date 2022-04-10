import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/mock_transactions_case_impl.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';

void main() {
  _transactionListCubitTest();
}

void _transactionListCubitTest() {
  group('Transactions list cubit', () {
    final _cubit = TransactionListCubit(
      transactionsCaseImpl: MockTransactionsCaseImpl(),
    );

    final _transaction = Transaction(
      uuid: '1',
      amount: 1,
      title: 'Transaction 1',
      date: DateTime.now(),
      type: TransactionType.expense,
    );

    test('initial state', () async {
      await _cubit.initialize();

      expect(_cubit.state.transactions.length, 0);
    });

    test(
      'transaction adding',
      () async {
        await _cubit.addTransaction(_transaction);

        await Future.delayed(const Duration(milliseconds: 250));

        expect(_cubit.state.transactions.length, 1);
      },
    );

    test(
      'transaction edit',
      () async {
        await _cubit.editTransaction(
          txId: _transaction.uuid,
          newTransaction: _transaction.copyWith(
            amount: 10,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 250));

        expect(
          _cubit.state.transactions
              .firstWhereOrNull((element) => element.uuid == _transaction.uuid)
              ?.amount,
          10,
        );
      },
    );

    test(
      'transaction delete',
      () async {
        await _cubit.deleteTransaction(_transaction.uuid);

        await Future.delayed(const Duration(milliseconds: 250));

        expect(_cubit.state.transactions.length, 0);
      },
    );
  });
}
