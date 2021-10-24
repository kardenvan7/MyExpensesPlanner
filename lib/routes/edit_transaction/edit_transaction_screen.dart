import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/models/transaction_category.dart';
import 'package:my_expenses_planner/routes/edit_transaction/components/amount_input.dart';
import 'package:my_expenses_planner/routes/edit_transaction/components/categories_dropdown_field.dart';
import 'package:my_expenses_planner/routes/edit_transaction/components/date_input.dart';
import 'package:my_expenses_planner/routes/edit_transaction/components/title_input.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({this.transaction, Key? key}) : super(key: key);

  static const String routeName = '/edit_transaction';
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Transaction? transaction;

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.transaction?.title ?? '');
  late final TextEditingController _amountController =
      TextEditingController(text: widget.transaction?.amount.toString() ?? '');
  late DateTime _pickedDate = widget.transaction?.date ?? DateTime.now();
  late TransactionCategory? _pickedCategory = widget.transaction?.category;

  bool get _isFormValid =>
      EditTransactionScreen._formKey.currentState!.validate();
  bool get isAdding => widget.transaction == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAdding ? 'add_transaction_title' : 'edit_transaction_title',
        ).tr(),
        actions: [
          IconButton(
            onPressed: _onSubmit,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(top: 10),
        child: Form(
          key: EditTransactionScreen._formKey,
          child: Column(
            children: [
              TitleInput(controller: _titleController),
              const SizedBox(
                height: 10,
              ),
              AmountInput(controller: _amountController),
              DateInput(
                initialDate: widget.transaction?.date,
                onDatePicked: (DateTime date) {
                  _pickedDate = date;
                },
              ),
              CategoriesDropdownField(
                onCategoryPick: _onCategoryPick,
                initialCategory: _pickedCategory,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCategoryPick(TransactionCategory? category) {
    setState(() {
      _pickedCategory = category;
    });
  }

  void _onSubmit() {
    if (_isFormValid) {
      final String title = _titleController.text;
      final double amount = double.parse(_amountController.text);

      final Transaction newTransaction = Transaction(
        uuid: isAdding
            ? DateTime.now().microsecondsSinceEpoch.toString()
            : widget.transaction!.uuid,
        title: title,
        amount: amount,
        date: _pickedDate,
        category: _pickedCategory,
      );

      if (isAdding) {
        _addTransaction(
          transaction: newTransaction,
        );
      } else {
        _editTransaction(
          id: widget.transaction!.uuid,
          newTransaction: newTransaction,
        );
      }
    }
  }

  Future<void> _addTransaction({
    required Transaction transaction,
  }) async {
    try {
      final TransactionsCubit transactionsCubit =
          BlocProvider.of<TransactionsCubit>(context);

      await transactionsCubit.addTransaction(
        transaction,
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has occurred during adding transaction', // TODO: localization
          ),
        ),
      );
    }
  }

  Future<void> _editTransaction({
    required String id,
    required Transaction newTransaction,
  }) async {
    try {
      final TransactionsCubit transactionsCubit =
          BlocProvider.of<TransactionsCubit>(context);

      await transactionsCubit.editTransaction(
        txId: widget.transaction!.uuid,
        newTransaction: newTransaction,
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has occurred during editing transaction', // TODO: localization
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
