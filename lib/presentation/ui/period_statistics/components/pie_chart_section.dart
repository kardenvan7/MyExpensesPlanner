import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartSection extends StatelessWidget {
  const PieChartSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          if (state.showLoadingIndicator || !state.initialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.transactions.isEmpty) {
            return Center(
              child: Text(
                AppLocalizationsWrapper.of(context).no_data_to_show,
              ),
            );
          }

          final _amountsByCategory = state.amountsByCategory;
          final _categoryUuids = _amountsByCategory.keys.toList();

          return BlocBuilder<CategoryListCubit, CategoryListState>(
            builder: (context, categoriesState) {
              return PieChart(
                colorList: List.generate(
                  _categoryUuids.length,
                  (index) =>
                      categoriesState.categories
                          .firstWhereOrNull(
                            (element) => _categoryUuids[index] == element.uuid,
                          )
                          ?.color ??
                      Colors.grey,
                ),
                // ignore: prefer_for_elements_to_map_fromIterable
                dataMap: Map<String, double>.fromIterable(
                  _categoryUuids,
                  key: (_currentUuid) {
                    return categoriesState.categories
                            .firstWhereOrNull(
                                (element) => element.uuid == _currentUuid)
                            ?.name ??
                        AppLocalizationsWrapper.of(context).without_category;
                  },
                  value: (_currentUuid) {
                    return _amountsByCategory[_currentUuid]!;
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
