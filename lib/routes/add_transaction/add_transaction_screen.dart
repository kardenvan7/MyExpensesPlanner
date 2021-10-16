import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  static const String routeName = '/add_transaction';
  static final _formKey = GlobalKey<FormState>();

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? _pickedDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add_transaction_title').tr(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(top: 10),
        child: Form(
          key: AddTransactionScreen._formKey,
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
                    return 'Field must be filled';
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
                    return 'Field must be filled';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Wrong format';
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
                      : 'No date chosen',
                ),
                trailing: ElevatedButton(
                  child: Text(
                    _pickedDate == null ? 'Choose a date' : 'Change date',
                  ),
                  onPressed: () async {
                    final DateTime? _date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                    if (AddTransactionScreen._formKey.currentState!
                            .validate() &&
                        _pickedDate != null) {
                      final TransactionsCubit transactionsCubit =
                          BlocProvider.of<TransactionsCubit>(context);

                      final Transaction newTransaction = Transaction(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        title: _titleController.text,
                        amount: double.parse(_amountController.text),
                        date: _pickedDate!,
                      );

                      await transactionsCubit.addTransaction(newTransaction);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
