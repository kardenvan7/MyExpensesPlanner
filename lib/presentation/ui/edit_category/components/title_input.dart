import 'package:flutter/material.dart';

class CategoryTitleInput extends StatelessWidget {
  const CategoryTitleInput({
    required this.initialValue,
    required this.onChange,
    this.errorText,
    Key? key,
  }) : super(key: key);

  final String? initialValue;
  final void Function(String? string) onChange;
  final String? errorText;

  bool get isErrorState => errorText != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          onChanged: onChange,
          initialValue: initialValue,
          decoration: InputDecoration(
            label: const Text('Title'), // TODO: localization
            enabledBorder: isErrorState
                ? Theme.of(context).inputDecorationTheme.errorBorder
                : const OutlineInputBorder(),
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
