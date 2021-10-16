import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/models/transaction.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({this.transaction, Key? key}) : super(key: key);

  static const String routeName = '/edit_transaction';
  static final _formKey = GlobalKey<FormState>();

  final Transaction? transaction;

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  bool get isAdding => widget.transaction == null;

  late final TextEditingController _titleController =
      TextEditingController(text: widget.transaction?.title ?? '');
  late final TextEditingController _amountController =
      TextEditingController(text: widget.transaction?.amount.toString() ?? '');
  late DateTime? _pickedDate = widget.transaction?.date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAdding ? 'add_transaction_title' : 'edit_transaction_title',
        ).tr(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(top: 10),
        child: Form(
          key: EditTransactionScreen._formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  label: const Text('title_input_label').tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value == '') {
                    return 'Field must be filled'; // TODO: localization
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _amountController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: const Text('amount_input_label').tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value == '') {
                    return 'Field must be filled'; // TODO: localization
                  }

                  if (double.tryParse(value) == null) {
                    return 'Wrong format'; // TODO: localization
                  }
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                title: Text(
                  _pickedDate != null
                      ? DateFormat('dd.MM.yyyy').format(_pickedDate!)
                      : 'No date chosen', // TODO: localization
                ),
                trailing: ElevatedButton(
                  child: Text(
                    _pickedDate == null
                        ? 'Choose a date'
                        : 'Change date', // TODO: localization
                  ),
                  onPressed: () async {
                    final DateTime? _date = await showDatePicker(
                      context: context,
                      initialDate: widget.transaction?.date ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(
                          days: 365,
                        ),
                      ),
                      lastDate: DateTime.now(),
                    );

                    if (_date != null) {
                      setState(() {
                        _pickedDate = _date;
                      });
                    }
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed: () async {
                    if (EditTransactionScreen._formKey.currentState!
                            .validate() &&
                        _pickedDate != null) {
                      final String title = _titleController.text;
                      final double amount =
                          double.parse(_amountController.text);

                      if (isAdding) {
                        final TransactionsCubit transactionsCubit =
                            BlocProvider.of<TransactionsCubit>(context);

                        final Transaction newTransaction = Transaction(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          title: title,
                          amount: amount,
                          date: _pickedDate!,
                        );

                        await transactionsCubit.addTransaction(newTransaction);
                      } else {
                        await BlocProvider.of<TransactionsCubit>(context)
                            .editTransaction(
                          id: widget.transaction!.id,
                          newDateTime: _pickedDate,
                          newTitle: title,
                          newAmount: amount,
                        );
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'), // TODO: localization
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
