import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({required this.controller, Key? key}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        label: const Text('title_input_label').tr(),
        border: const OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Field must be filled'; // TODO: localization
        }
      },
    );
  }
}
