import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/transaction_list_clear.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    required this.transactions,
    required this.onDeleteConfirmed,
    this.errorWhileInitializing = false,
    this.errorMessage,
    this.isLazyLoading = false,
    this.showLoadingIndicator = false,
    this.dateTimeRange,
    this.scrollController,
    this.scrollPhysics,
    Key? key,
  }) : super(key: key);

  final List<Transaction> transactions;
  final void Function(String uuid) onDeleteConfirmed;
  final bool showLoadingIndicator;
  final String? errorMessage;
  final DateTimeRange? dateTimeRange;
  final bool isLazyLoading;
  final bool errorWhileInitializing;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    if (errorWhileInitializing) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
            ],
          ),
        ),
      );
    }

    if (showLoadingIndicator) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    return transactions.isNotEmpty
        ? TransactionListClear(
            onTransactionDeleteTap: (String id) {
              _onTransactionDeleteTap(context: context, uuid: id);
            },
            onTransactionEditTap: _onTransactionEditTap,
            scrollController: scrollController,
            transactions: transactions,
            isLazyLoading: isLazyLoading,
            errorMessage: errorMessage,
            onDateChipTap: (DateTime date) {
              _onDateChipTap(
                date: date,
                pickedRange: dateTimeRange,
              );
            },
            showDateChips: !(dateTimeRange?.isWithinOneDay ?? false),
            scrollPhysics: scrollPhysics,
          )
        : Center(
            child: Text(
              AppLocalizationsFacade.of(context).no_statistics_for_period,
              textAlign: TextAlign.center,
            ),
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
            start: date.startOfDay,
            end: date.endOfDay,
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
            AppLocalizationsFacade.of(context)
                .delete_transaction_confirmation_question,
          ),
          actions: [
            TextButton(
              onPressed: _onDeleteDenied,
              child: Text(AppLocalizationsFacade.of(context).no),
            ),
            TextButton(
              onPressed: () {
                _onDeleteConfirmed(uuid: uuid);
              },
              child: Text(
                AppLocalizationsFacade.of(context).yes,
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
    required String uuid,
  }) {
    onDeleteConfirmed(uuid);
    getIt<AppRouter>().pop();
  }

  void _onDeleteDenied() {
    getIt<AppRouter>().pop();
  }
}
