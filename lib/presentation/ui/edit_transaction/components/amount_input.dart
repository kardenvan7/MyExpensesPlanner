import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({
    required this.value,
    required this.onChanged,
    this.errorText,
    Key? key,
  }) : super(key: key);

  final String? value;
  final void Function(String? string) onChanged;
  final String? errorText;

  bool get isErrorState => errorText != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: value,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            label: const Text('amount_input_label').tr(),
            enabledBorder: isErrorState
                ? Theme.of(context).inputDecorationTheme.errorBorder
                : const OutlineInputBorder(),
            errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
          ),
          onChanged: onChanged,
        ),
        if (isErrorState)
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 7),
            child: Text(
              errorText!,
              style: Theme.of(context).inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }
}
