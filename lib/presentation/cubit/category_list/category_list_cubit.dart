import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';

part './category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  CategoryListCubit({
    required ICategoriesCase categoriesCaseImpl,
  })  : _categoriesCaseImpl = categoriesCaseImpl,
        super(
          CategoryListState(
            isLoading: false,
            categories: [],
          ),
        );

  final ICategoriesCase _categoriesCaseImpl;

  List<TransactionCategory> _copyCurrentCategories() {
    return List.generate(
      state.categories.length,
      (index) => state.categories[index].copyWith(),
    );
  }

  Future<void> fetchCategories() async {
    emit(
      CategoryListState(
        isLoading: true,
      ),
    );

    final List<TransactionCategory> categoriesList =
        await _categoriesCaseImpl.getCategories();

    emit(
      CategoryListState(
        isLoading: false,
        categories: categoriesList,
      ),
    );
  }

  void refresh() {
    fetchCategories();
  }

  Future<void> addCategory(TransactionCategory category) async {
    await _categoriesCaseImpl.save(category);
    _add(category);
  }

  Future<void> updateCategory(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    await _categoriesCaseImpl.update(uuid, newCategory);
    _update(uuid, newCategory);
  }

  Future<void> deleteCategory(
    String uuid,
  ) async {
    await _categoriesCaseImpl.delete(uuid);
    _delete(uuid);
  }

  void _delete(String uuid) {
    final List<TransactionCategory> _categories = _copyCurrentCategories();
    _categories.removeWhere((element) => element.uuid == uuid);

    emit(
      CategoryListState(
        categories: _categories,
      ),
    );
  }

  void _update(String uuid, TransactionCategory newCategory) {
    final List<TransactionCategory> _categories = _copyCurrentCategories();
    final int index = _categories.indexWhere(
      (element) => element.uuid == uuid,
    );

    _categories[index] = newCategory;

    emit(
      CategoryListState(
        categories: _categories,
      ),
    );
  }

  void _add(TransactionCategory category) {
    final List<TransactionCategory> _categories = _copyCurrentCategories();
    _categories.add(category);

    emit(
      CategoryListState(
        categories: _categories,
      ),
    );
  }
}
