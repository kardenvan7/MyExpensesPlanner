import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({required this.controller, Key? key}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
    );
  }
}
