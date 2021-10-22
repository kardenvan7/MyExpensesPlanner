import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/models/transaction_category.dart';
import 'package:my_expenses_planner/providers/categories/categories_provider.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({required this.provider})
      : super(CategoriesState(type: CategoriesStateType.loading));

  final ICategoriesProvider provider;
  List<TransactionCategory> categoriesList = [];

  Future<void> fetchCategories() async {
    categoriesList = await provider.getCategories();

    emit(
      CategoriesState(
        type: CategoriesStateType.loaded,
        categories: categoriesList,
      ),
    );
  }

  Future<void> addCategory(TransactionCategory category) async {
    await provider.save(category);
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
