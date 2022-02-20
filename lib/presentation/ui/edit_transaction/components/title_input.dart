import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({
    required this.value,
    required this.onChanged,
    this.errorText,
    Key? key,
  }) : super(key: key);

  final String? value;
  final void Function(String? value) onChanged;
  final String? errorText;

  bool get isErrorState => errorText != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          initialValue: value,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(
              AppLocalizationsWrapper.of(context).title_input_label,
            ),
            enabledBorder: isErrorState
                ? Theme.of(context).inputDecorationTheme.errorBorder
                : Theme.of(context).inputDecorationTheme.enabledBorder,
          ),
          onChanged: onChanged,
          validator: (String? value) {
            if (value == null || value == '') {
              return 'Field must be filled'; // TODO: localization
            }

            return null;
          },
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
