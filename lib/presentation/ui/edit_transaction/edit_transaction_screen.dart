import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/edit_transaction/edit_transaction_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/components/amount_input.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/components/categories_dropdown_field.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/components/date_input.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/components/title_input.dart';

class EditTransactionScreen extends StatelessWidget {
  const EditTransactionScreen({this.transaction, Key? key}) : super(key: key);

  static const String routeName = '/edit_transaction';

  final Transaction? transaction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditTransactionCubit>(
      create: (context) => EditTransactionCubit(
        transaction: transaction,
        transactionsCase: getIt<ITransactionsCase>(),
      ),
      child: BlocConsumer<EditTransactionCubit, EditTransactionState>(
        listener: (context, state) {
          if (state.showSnackBar) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.snackBarText!,
                ),
              ),
            );
          }

          if (state.popScreen) {
            Navigator.of(context).pop();
          }
        },
        buildWhen: (oldState, newState) {
          return newState.triggerBuilder;
        },
        builder: (context, state) {
          final EditTransactionCubit _cubit =
              BlocProvider.of<EditTransactionCubit>(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                _cubit.isAdding
                    ? AppLocalizationsWrapper.of(context).add_transaction_title
                    : AppLocalizationsWrapper.of(context)
                        .edit_transaction_title,
              ),
              actions: [
                IconButton(
                  onPressed: _cubit.submit,
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  TitleInput(
                    value: state.title,
                    onChanged: _cubit.setTitle,
                    errorText: state.formState.titleErrorText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AmountInput(
                    value: state.amount,
                    onChanged: _cubit.setAmount,
                    errorText: state.formState.amountErrorText,
                  ),
                  DateInput(
                    initialDate: state.date,
                    onDatePicked: _cubit.setDate,
                  ),
                  CategoriesDropdownField(
                    initialCategoryUuid: state.categoryUuid,
                    onCategoryPick: _cubit.setCategoryUuid,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
