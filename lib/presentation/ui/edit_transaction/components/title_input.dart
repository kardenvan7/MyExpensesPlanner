import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
            label: const Text('title_input_label').tr(),
            enabledBorder: isErrorState
                ? Theme.of(context).inputDecorationTheme.errorBorder
                : const OutlineInputBorder(),
          ),
          onChanged: onChanged,
          validator: (String? value) {
            if (value == null || value == '') {
              return 'Field must be filled'; // TODO: localization
            }
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
