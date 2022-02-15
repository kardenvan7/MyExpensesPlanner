import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';

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
            label: Text(AppLocalizationsWrapper.of(context).amount_input_label),
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
