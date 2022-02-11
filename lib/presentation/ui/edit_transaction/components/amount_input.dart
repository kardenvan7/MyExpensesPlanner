import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String? value;
  final void Function(String? string) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: const Text('amount_input_label').tr(),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
