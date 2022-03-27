import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';

class CategoryTitleInput extends StatelessWidget {
  const CategoryTitleInput({
    required this.initialValue,
    required this.onChange,
    this.autofocus = false,
    this.errorText,
    Key? key,
  }) : super(key: key);

  final String? initialValue;
  final void Function(String? string) onChange;
  final bool autofocus;
  final String? errorText;

  bool get isErrorState => errorText != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          autofocus: autofocus,
          onChanged: onChange,
          initialValue: initialValue,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            label: Text(
              AppLocalizationsWrapper.of(context).title_input_label,
            ),
            enabledBorder: isErrorState
                ? Theme.of(context).inputDecorationTheme.errorBorder
                : Theme.of(context).inputDecorationTheme.enabledBorder,
          ),
        ),
        if (isErrorState)
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              errorText!,
              style: Theme.of(context).inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }
}
