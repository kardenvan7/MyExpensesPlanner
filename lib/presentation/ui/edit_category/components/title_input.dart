import 'package:flutter/material.dart';

class CategoryTitleInput extends StatelessWidget {
  const CategoryTitleInput({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text('Title'), // TODO: localization
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Field must be filled';
        }
      },
    );
  }
}
