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
          onTap: () async {
            final ValueWrapper<String>? _newCategoryUuid =
                await showDialog<ValueWrapper<String>?>(
              context: context,
              builder: (builderContext) => AlertDialog(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: EdgeInsets.zero,
                content: PickCategoryModalSheet(
                  pickedCategoryUuid: _pickedCategoryUuid,
                ),
              ),
            );

            if (_newCategoryUuid != null) {
              setState(() {
                _pickedCategoryUuid = _newCategoryUuid.value;
                widget.onCategoryPicked(_newCategoryUuid.value);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                if (_pickedCategory != null)
                  Container(
                    width: 50,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _pickedCategory.color,
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
}

class PickCategoryModalSheet extends StatelessWidget {
  const PickCategoryModalSheet({
    required this.pickedCategoryUuid,
    Key? key,
  }) : super(key: key);

  final String? pickedCategoryUuid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      builder: (context, state) {
        final List<TransactionCategory> _categoryList = state.categories;

        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                alignment: Alignment.centerRight,
                child: TextButton(
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
                        title: Text(
                          _categoryList[_index].name,
                        ),
                        leading: Container(
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _categoryList[_index].color,
                          ),
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
    Navigator.pop(context, ValueWrapper(value: categoryUuid));
  }
}
