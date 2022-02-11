import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({required this.value, required this.onChanged, Key? key})
      : super(key: key);

  final String? value;
  final void Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        label: const Text('title_input_label').tr(),
        border: const OutlineInputBorder(),
      ),
      onChanged: (String? value) {},
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Field must be filled'; // TODO: localization
        }
      },
    );
  }
}
