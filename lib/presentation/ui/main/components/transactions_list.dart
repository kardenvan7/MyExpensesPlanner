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
    required this.transactionsListState,
    Key? key,
  }) : super(key: key);

  final TransactionListState transactionsListState;

  @override
  Widget build(BuildContext context) {
    if (transactionsListState.errorWhileInitializing) {
      return Center(
        child: Text(transactionsListState.errorMessage!),
      );
    }

    if (transactionsListState.showLoadingIndicator) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    return transactionsListState.transactions.isNotEmpty
        ? TransactionListClear(
            scrollPhysics: const NeverScrollableScrollPhysics(),
            onTransactionDeleteTap: (String id) {
              _onTransactionDeleteTap(context: context, uuid: id);
            },
            onTransactionEditTap: _onTransactionEditTap,
            transactions: transactionsListState.transactions,
            isLazyLoading: transactionsListState.isLazyLoading,
            errorMessage: transactionsListState.errorMessage,
            onDateChipTap: (DateTime date) {
              _onDateChipTap(
                date: date,
                pickedRange: transactionsListState.dateTimeRange,
                context: context,
              );
            },
            showDateChips:
                !(transactionsListState.dateTimeRange?.isWithinOneDay ?? false),
          )
        : Container(
            margin: const EdgeInsets.only(top: 150),
            child: Center(
              child: Text(
                transactionsListState.transactions.isEmpty &&
                        transactionsListState.dateTimeRange == null
                    ? AppLocalizationsWrapper.of(context)
                        .empty_transaction_list_placeholder_text
                    : AppLocalizationsWrapper.of(context)
                        .no_statistics_for_period,
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  void _onDateChipTap({
    required DateTime date,
    required DateTimeRange? pickedRange,
    required BuildContext context,
  }) {
    if (!_isDayPicked(date: date, pickedRange: pickedRange)) {
      BlocProvider.of<TransactionListCubit>(context).onDateTimeRangeChange(
        DateTimeRange(
          start: date.startOfDay,
          end: date.endOfDay,
        ),
      );
      // getIt<AppRouter>().push(
      //   PeriodStatisticsRoute(
      //     dateTimeRange: DateTimeRange(
      //       start: date.startOfDay,
      //       end: date.endOfDay,
      //     ),
      //   ),
      // );
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
