import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/categories_change_data.dart';
import 'package:my_expenses_planner/domain/models/fetch_failure.dart';
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

  bool initialized = false;

  Future<void> initialize() async {
    try {
      if (!initialized) {
        _categoriesCaseImpl.stream.listen((newData) {
          _refreshFromNewData(newData);
        });

        fetchCategories();

        initialized = true;
      }
    } catch (e) {
      print(e);
    }
  }

  final ICategoriesCase _categoriesCaseImpl;

  Future<void> fetchCategories() async {
    emit(
      CategoryListState(
        isLoading: true,
      ),
    );

    final _result = await _categoriesCaseImpl.getCategories();

    _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () {
          emit(
            CategoryListState(
              isLoading: false,
            ),
          );
        },
        notFound: () {
          emit(
            CategoryListState(
              isLoading: false,
            ),
          );
        },
      ),
      onSuccess: (categoriesList) {
        emit(
          CategoryListState(
            isLoading: false,
            categories: categoriesList,
          ),
        );
      },
    );
  }

  void refresh() {
    fetchCategories();
  }

  Future<void> addCategory(TransactionCategory category) async {
    await _categoriesCaseImpl.save(category);
  }

  Future<void> updateCategory(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    await _categoriesCaseImpl.update(uuid, newCategory);
  }

  Future<void> deleteCategory(
    String uuid,
  ) async {
    await _categoriesCaseImpl.delete(uuid);
  }

  void _refreshFromNewData(Result<FetchFailure, CategoriesChangeData> newData) {
    newData.fold(
      onFailure: (failure) => failure.when(
        unknown: () {},
        notFound: () {},
      ),
      onSuccess: (newData) {
        final List<TransactionCategory> _list = [...state.categories];

        _list.removeWhere(
          (currentListElement) =>
              newData.deletedCategoriesUuids
                  .contains(currentListElement.uuid) ||
              newData.editedCategories.firstWhereOrNull(
                    (element) => currentListElement.uuid == element.uuid,
                  ) !=
                  null,
        );

        _list.addAll(
            newData.addedCategories.followedBy(newData.editedCategories));

        final _uniqueList = _list.toSet().toList();

        emit(CategoryListState(categories: _uniqueList));
      },
    );
  }
}
