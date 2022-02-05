part of './category_list_cubit.dart';

class CategoryListState {
  final CategoriesStateType type;
  final List<TransactionCategory>? categories;

  CategoryListState({
    required this.type,
    this.categories,
  }) : assert(
          type != CategoriesStateType.loaded || categories != null,
          'Categories can not be null in loaded state',
        );
}

enum CategoriesStateType { loading, loaded }
