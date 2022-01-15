import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({required this.categoriesCaseImpl})
      : super(CategoriesState(type: CategoriesStateType.loading));

  final ICategoriesCase categoriesCaseImpl;
  List<TransactionCategory> categoriesList = [];

  Future<void> fetchCategories() async {
    categoriesList = await categoriesCaseImpl.getCategories();

    emit(
      CategoriesState(
        type: CategoriesStateType.loaded,
        categories: categoriesList,
      ),
    );
  }

  void refresh() {
    emit(
      CategoriesState(
        type: CategoriesStateType.loaded,
        categories: categoriesList,
      ),
    );
  }

  Future<void> addCategory(TransactionCategory category) async {
    await categoriesCaseImpl.save(category);
    _add(category);
  }

  Future<void> editCategory(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    await categoriesCaseImpl.update(uuid, newCategory);
    _update(uuid, newCategory);
  }

  Future<void> deleteCategory(
    String uuid,
  ) async {
    await categoriesCaseImpl.delete(uuid);
    _delete(uuid);
  }

  void _delete(String uuid) {
    categoriesList.removeWhere((element) => element.uuid == uuid);

    emit(
      CategoriesState(
        type: CategoriesStateType.loaded,
        categories: categoriesList,
      ),
    );
  }

  void _update(String uuid, TransactionCategory newCategory) {
    final int index = categoriesList.indexWhere(
      (element) => element.uuid == uuid,
    );

    categoriesList[index] = newCategory;

    emit(
      CategoriesState(
        type: CategoriesStateType.loaded,
        categories: categoriesList,
      ),
    );
  }

  void _add(TransactionCategory category) {
    categoriesList.add(category);

    emit(
      CategoriesState(
        type: CategoriesStateType.loaded,
        categories: categoriesList,
      ),
    );
  }
}

class CategoriesState {
  final CategoriesStateType type;
  final List<TransactionCategory>? categories;

  CategoriesState({
    required this.type,
    this.categories,
  }) : assert(
          type != CategoriesStateType.loaded || categories != null,
          'Categories can not be null in loaded state',
        );
}

enum CategoriesStateType { loading, loaded }
