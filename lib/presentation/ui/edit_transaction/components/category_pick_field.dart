part of '../edit_transaction_screen.dart';

class CategoryPickField extends StatefulWidget {
  const CategoryPickField({
    required this.pickedCategoryUuid,
    required this.onCategoryPicked,
    Key? key,
  }) : super(key: key);

  final String? pickedCategoryUuid;
  final void Function(String? uuid) onCategoryPicked;

  @override
  State<CategoryPickField> createState() => _CategoryPickFieldState();
}

class _CategoryPickFieldState extends State<CategoryPickField> {
  late String? _pickedCategoryUuid = widget.pickedCategoryUuid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      builder: (context, state) {
        final TransactionCategory? _pickedCategory =
            state.categories.firstWhereOrNull(
          (element) => element.uuid == _pickedCategoryUuid,
        );

        return InkWell(
          onTap: _onCategoryPick,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                        .inputDecorationTheme
                        .enabledBorder
                        ?.borderSide
                        .color ??
                    Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                if (_pickedCategory != null)
                  Container(
                    width: 25,
                    height: 25,
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _pickedCategory.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                Expanded(
                  child: Text(
                    _pickedCategory?.name ??
                        AppLocalizationsWrapper.of(context).without_category,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onCategoryPick() async {
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: context,
      builder: (builderContext) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: EdgeInsets.zero,
        content: PickCategoryModalSheet(
          pickedCategoryUuid: _pickedCategoryUuid,
          onCategoryUuidPicked: (ValueWrapper<String> _newCategoryUuid) {
            setState(() {
              _pickedCategoryUuid = _newCategoryUuid.value;
              widget.onCategoryPicked(_newCategoryUuid.value);
            });
          },
        ),
      ),
    );
  }
}

class PickCategoryModalSheet extends StatelessWidget {
  const PickCategoryModalSheet({
    required this.pickedCategoryUuid,
    required this.onCategoryUuidPicked,
    Key? key,
  }) : super(key: key);

  final String? pickedCategoryUuid;
  final void Function(ValueWrapper<String> categoryUuid) onCategoryUuidPicked;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      builder: (context, state) {
        final List<TransactionCategory> _categoryList = state.categories;

        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: Text(
                    AppLocalizationsWrapper.of(context).add_category,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditCategoryScreen.routeName,
                    );
                  },
                ),
              ),
              const Divider(
                height: 0,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final _index = index - 1;

                    if (_index == -1) {
                      return InkWell(
                        child: ListTile(
                          title: Text(
                            AppLocalizationsWrapper.of(context)
                                .without_category,
                          ),
                          onTap: () {
                            _onCategoryTap(context, null);
                          },
                        ),
                      );
                    }

                    return InkWell(
                      child: ListTile(
                        horizontalTitleGap: 0,
                        title: Text(
                          _categoryList[_index].name,
                        ),
                        leading: Container(
                          width: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _categoryList[_index].color,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _onCategoryEditTap(
                                  context: context,
                                  category: _categoryList[_index],
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _onCategoryDeleteTap(
                                  context,
                                  _categoryList[_index].uuid,
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        onTap: () {
                          _onCategoryTap(
                            context,
                            _categoryList[_index].uuid,
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 0,
                    );
                  },
                  itemCount: _categoryList.length + 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCategoryTap(BuildContext context, String? categoryUuid) {
    onCategoryUuidPicked(ValueWrapper(value: categoryUuid));
    Navigator.pop(context);
  }

  void _onCategoryEditTap({
    required BuildContext context,
    TransactionCategory? category,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (editTransactionContext) {
          return EditCategoryScreen(
            category: category,
          );
        },
      ),
    );
  }

  void _onCategoryDeleteTap(BuildContext context, String categoryUuid) {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text(
            AppLocalizationsWrapper.of(context)
                .delete_category_confirmation_question,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(alertContext);
              },
              child: Text(AppLocalizationsWrapper.of(context).no),
            ),
            TextButton(
              onPressed: () async {
                await BlocProvider.of<CategoryListCubit>(context)
                    .deleteCategory(categoryUuid);

                if (pickedCategoryUuid == categoryUuid) {
                  onCategoryUuidPicked(ValueWrapper(value: null));
                }

                Navigator.pop(alertContext);
              },
              child: Text(AppLocalizationsWrapper.of(context).yes),
            ),
          ],
        );
      },
    );
  }
}
