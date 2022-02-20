import 'dart:async';

import '../../models/categories_change_data.dart';
import '../../models/transaction_category.dart';
import '../../repositories_interfaces/i_categories_repository.dart';
import '../categories/i_categories_case.dart';

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
    return _categoriesRepository.getCategories();
  }

  @override
  Future<TransactionCategory?> getCategoryByUuid(String uuid) async {
    return _categoriesRepository.getCategoryByUuid(uuid);
  }

  @override
  Future<void> save(TransactionCategory category) async {
    await _categoriesRepository.save(
      category,
    );

    _streamController.add(
      CategoriesChangeData(
        addedCategories: [category],
      ),
    );
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) async {
    try {
      await _categoriesRepository.update(
        uuid,
        newCategory,
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
