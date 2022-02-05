import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_expenses_planner/config/localization/locale_keys.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/edit_category/components/title_input.dart';

class EditCategoryScreen extends StatefulWidget {
  static const String routeName = '/edit_category';
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  const EditCategoryScreen({
    this.category,
    Key? key,
  }) : super(key: key);

  final TransactionCategory? category;

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  bool get isCreating => widget.category == null;

  late final Color _pickedColor = widget.category?.color ?? Colors.white;

  late final TextEditingController _titleController =
      TextEditingController(text: widget.category?.name ?? '');

  late final TextEditingController _colorController =
      TextEditingController(text: _pickedColor.toHexString());

  bool get isFormValid => EditCategoryScreen._formKey.currentState!.validate();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _colorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCreating
              ? 'Create category'
              : 'Edit category', // TODO: localization
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: EditCategoryScreen._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryTitleInput(controller: _titleController),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ColorPicker(
                    hexInputController: _colorController,
                    pickerColor: _pickedColor,
                    onColorChanged: (Color _chosenColor) {},
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _onSubmit(context);
                      },
                      child: Text(
                        LocaleKeys.submit.tr(),
                      ),
                    ),
                  ],
                ) // TODO: localization
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (isFormValid) {
      final TransactionCategory newCategory = TransactionCategory(
        uuid: widget.category?.uuid ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        color: HexColor.fromHex(_colorController.text) ?? Colors.white,
        name: _titleController.text,
      );

      final CategoryListCubit cubit =
          BlocProvider.of<CategoryListCubit>(context);

      if (widget.category == null) {
        cubit.addCategory(newCategory);
      } else {
        await cubit.editCategory(widget.category!.uuid, newCategory);
        BlocProvider.of<TransactionListCubit>(context).refresh();
      }

      Navigator.pop(context, newCategory);
    }
  }
}
