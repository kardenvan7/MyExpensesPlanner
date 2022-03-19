import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/transactions_list_item.dart';

class TransactionListClear extends StatefulWidget {
  const TransactionListClear({
    required this.transactions,
    required this.onTransactionEditTap,
    required this.onTransactionDeleteTap,
    this.errorMessage,
    this.onDateChipTap,
    this.showDateChips = true,
    this.showLoadingIndicator = false,
    this.isLazyLoading = false,
    this.scrollController,
    Key? key,
  }) : super(key: key);

  final List<Transaction> transactions;
  final void Function(Transaction transaction) onTransactionEditTap;
  final void Function(String id) onTransactionDeleteTap;
  final bool showLoadingIndicator;
  final bool isLazyLoading;
  final bool showDateChips;
  final void Function(DateTime date)? onDateChipTap;
  final String? errorMessage;
  final ScrollController? scrollController;

  @override
  State<TransactionListClear> createState() => _TransactionListClearState();
}

class _TransactionListClearState extends State<TransactionListClear> {
  List<DateTime> sortedDates = [];
  Map<DateTime, List<Transaction>> transactionsByDates = {};
  String? errorMessage;

  bool showLoadingIndicator = true;

  @override
  void initState() {
    super.initState();
    final _transactionsByDates = _getTransactionsByDates(widget.transactions);
    final _sortedDates = _getSortedDates(_transactionsByDates);

    setState(() {
      transactionsByDates = _transactionsByDates;
      sortedDates = _sortedDates;
      showLoadingIndicator = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TransactionListClear oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      showLoadingIndicator = true;
    });

    final _transactionsByDates = _getTransactionsByDates(widget.transactions);
    final _sortedDates = _getSortedDates(_transactionsByDates);

    setState(() {
      transactionsByDates = _transactionsByDates;
      sortedDates = _sortedDates;
      showLoadingIndicator = false;
      errorMessage = widget.errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showLoadingIndicator) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    return widget.transactions.isNotEmpty
        ? ListView.separated(
            controller: widget.scrollController,
            padding: EdgeInsets.only(
              bottom: Platform.isIOS ? 30 : 10,
            ),
            shrinkWrap: true,
            itemCount: sortedDates.length + 1,
            separatorBuilder: (_, __) {
              return const SizedBox(height: 15);
            },
            itemBuilder: (context, index) {
              if (index == sortedDates.length) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    if (errorMessage != null) Text(widget.errorMessage!),
                    if (widget.isLazyLoading)
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  ],
                );
              }
              final DateTime _currentDate = sortedDates[index];
              final List<Transaction> _currentDateTransactions =
                  transactionsByDates[_currentDate]!;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showDateChips)
                    InkWell(
                      onTap: () {
                        widget.onDateChipTap?.call(_currentDate);
                      },
                      child: Chip(
                        label: Text(
                          _currentDate.isToday
                              ? AppLocalizationsWrapper.of(context).today
                              : _currentDate.isYesterday
                                  ? AppLocalizationsWrapper.of(context)
                                      .yesterday
                                  : DateFormat.yMMMMd(
                                      Localizations.localeOf(context)
                                          .toLanguageTag(),
                                    ).format(_currentDate),
                        ),
                      ),
                    ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _currentDateTransactions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TransactionsListItem(
                        transaction: _currentDateTransactions[index],
                        onDeleteTap: widget.onTransactionDeleteTap,
                        onEditTap: widget.onTransactionEditTap,
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                ],
              );
            },
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
  }

  Map<DateTime, List<Transaction>> _getTransactionsByDates(
    List<Transaction> transactions,
  ) {
    final Map<DateTime, List<Transaction>> _transactionsByDate = {};

    for (final Transaction _transaction in transactions) {
      final DateTime _date = DateTime(
        _transaction.date.year,
        _transaction.date.month,
        _transaction.date.day,
      );

      if (_transactionsByDate.containsKey(_date)) {
        _transactionsByDate[_date]!.add(_transaction);
      } else {
        _transactionsByDate[_date] = [_transaction];
      }
    }

    _transactionsByDate.forEach((key, value) {
      value.sort((a, b) => b.date.compareTo(a.date));
    });

    return _transactionsByDate;
  }

  List<DateTime> _getSortedDates(
      Map<DateTime, List<Transaction>> transactionsByDates) {
    return transactionsByDates.keys.toList()
      ..sort(
        (curDateTime, newDateTime) => newDateTime.compareTo(
          curDateTime,
        ),
      );
  }
}
