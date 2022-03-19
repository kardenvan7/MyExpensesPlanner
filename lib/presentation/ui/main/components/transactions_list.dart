import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/transaction_list_clear.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListCubit, TransactionListState>(
      buildWhen: (oldState, newState) {
        return newState.triggerBuilder;
      },
      builder: (context, state) {
        if (state.errorWhileInitializing) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage!),
                ],
              ),
            ),
          );
        }

        if (state.showLoadingIndicator) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }

        return state.transactions.isNotEmpty
            ? TransactionListClear(
                onTransactionDeleteTap: (String id) {
                  _onTransactionDeleteTap(context: context, uuid: id);
                },
                onTransactionEditTap: _onTransactionEditTap,
                scrollController: BlocProvider.of<TransactionListCubit>(context)
                    .scrollController,
                transactions: state.transactions,
                isLazyLoading: state.isLoading,
                errorMessage: state.errorMessage,
                onDateChipTap: (DateTime date) {
                  _onDateChipTap(
                    date: date,
                    pickedRange: state.dateTimeRange,
                  );
                },
                showDateChips: !(state.dateTimeRange?.isWithinOneDay ?? false),
              )
            : Container(
                margin: const EdgeInsets.only(bottom: kToolbarHeight),
                child: Center(
                  child: Text(
                    AppLocalizationsWrapper
                        .keys.empty_transaction_list_placeholder_text,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
      },
    );
  }

  void _onDateChipTap({
    required DateTime date,
    required DateTimeRange? pickedRange,
  }) {
    if (!_isDayPicked(date: date, pickedRange: pickedRange)) {
      getIt<AppRouter>().push(
        PeriodStatisticsRoute(
          dateTimeRange: DateTimeRange(
            start: date,
            end: date.add(const Duration(days: 1)).subtract(
                  const Duration(milliseconds: 1),
                ),
          ),
        ),
      );
    }
  }

  bool _isDayPicked({
    required DateTime date,
    required DateTimeRange? pickedRange,
  }) {
    if (pickedRange == null) {
      return false;
    }

    return date.isSameDayWith(pickedRange.start) &&
        date.isSameDayWith(pickedRange.end);
  }

  Future<bool?> _onTransactionDeleteTap({
    required BuildContext context,
    required String uuid,
  }) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizationsWrapper.of(context)
                .delete_transaction_confirmation_question,
          ),
          actions: [
            TextButton(
              onPressed: _onDeleteDenied,
              child: Text(AppLocalizationsWrapper.of(context).no),
            ),
            TextButton(
              onPressed: () {
                _onDeleteConfirmed(contextWithCubit: context, uuid: uuid);
              },
              child: Text(
                AppLocalizationsWrapper.of(context).yes,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onTransactionEditTap(Transaction transaction) {
    getIt<AppRouter>().push(
      EditTransactionRoute(transaction: transaction),
    );
  }

  void _onDeleteConfirmed({
    required BuildContext contextWithCubit,
    required String uuid,
  }) {
    BlocProvider.of<TransactionListCubit>(contextWithCubit)
        .deleteTransaction(uuid);

    getIt<AppRouter>().pop();
  }

  void _onDeleteDenied() {
    getIt<AppRouter>().pop();
  }
}
