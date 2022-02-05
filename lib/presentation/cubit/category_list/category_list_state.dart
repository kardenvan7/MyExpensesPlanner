part of './category_list_cubit.dart';

class CategoryListState {
  final bool isLoading;
  final List<TransactionCategory> categories;

  CategoryListState({
    this.isLoading = false,
    List<TransactionCategory>? categories,
  }) : categories = categories ?? [];
}
