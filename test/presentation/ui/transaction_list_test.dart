import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/transactions/transaction.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/fake_categories_case_impl.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/fake_transactions_case_impl.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/transactions_list.dart';

import 'tester_widget_wrapper.dart';

void main() {
  testWidgets(
    'Transactions list with item',
    (WidgetTester tester) async {
      await tester.runAsync(
        () async {
          final _cubit = TransactionListCubit(
            transactionsCaseImpl: FakeTransactionsCaseImpl(),
          );

          final _transaction = Transaction(
            uuid: '1',
            amount: 1,
            title: 'Transaction 1',
            date: DateTime.now(),
            type: TransactionType.expense,
            categoryUuid: TransactionCategory.empty().uuid,
          );

          await _cubit.initialize();
          await _cubit.addTransaction(_transaction);
          await Future.delayed(const Duration(milliseconds: 500));

          await tester.pumpWidget(
            TesterWidgetWrapper(
              child: BlocProvider<CategoryListCubit>(
                create: (context) => CategoryListCubit(
                  categoriesCaseImpl: FakeCategoriesCaseImpl(),
                ),
                child: TransactionsList(
                  transactionsListState: _cubit.state,
                ),
              ),
            ),
          );

          await tester.pump(const Duration(seconds: 3));

          final Finder titleFinder = find.text('Transaction 1');

          expectSync(titleFinder, findsOneWidget);
        },
      );
    },
  );
}
