import 'dart:async';

import 'package:my_expenses_planner/core/utils/print.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart'
    as data;
import 'package:my_expenses_planner/data/repositories/categories/i_categories_repository.dart';
import 'package:my_expenses_planner/domain/models/categories_change_data.dart';

import '../../models/transaction_category.dart';
import '../../use_cases/categories/i_categories_case.dart';

class CategoriesCaseImpl implements ICategoriesCase {
  CategoriesCaseImpl({
    required ICategoriesRepository categoriesRepository,
  }) : _categoriesRepository = categoriesRepository;

  final ICategoriesRepository _categoriesRepository;

  final StreamController<CategoriesChangeData> _streamController =
      StreamController<CategoriesChangeData>.broadcast();

  @override
  Stream<CategoriesChangeData> get stream => _streamController.stream;

  @override
  Future<List<TransactionCategory>> getCategories() async {
    final List<data.TransactionCategory> _categories =
        await _categoriesRepository.getCategories();

    return List.generate(
      _categories.length,
      (index) => TransactionCategory.fromDataTransactionCategory(
        _categories[index],
      ),
    );
  }

  @override
  Future<void> save(TransactionCategory category) async {
    await _categoriesRepository.save(
      category.toDataTransactionCategory(),
    );

    _streamController.add(
      CategoriesChangeData(
        addedCategories: [category],
      ),
    );
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) async {
    printWithBrackets('updating');
    try {
      await _categoriesRepository.update(
        uuid,
        newCategory.toDataTransactionCategory(),
      );

      _streamController.add(
        CategoriesChangeData(
          editedCategories: [newCategory],
        ),
      );
    } catch (e, st) {
      print(e);
    }
  }

  @override
  Future<void> delete(String uuid) async {
    await _categoriesRepository.delete(uuid);

    _streamController.add(
      CategoriesChangeData(
        deletedCategoriesUuids: [uuid],
      ),
    );
  }
}
