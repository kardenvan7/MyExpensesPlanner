import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/localization/locale_keys.dart';

class DateInput extends StatefulWidget {
  const DateInput({required this.onDatePicked, this.initialDate, Key? key})
      : super(key: key);

  final DateTime? initialDate;
  final void Function(DateTime date) onDatePicked;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  late DateTime _pickedDate = widget.initialDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 12,
      ),
      title: Text(
        DateFormat(
          'dd.MM.yyyy',
          context.locale.toStringWithSeparator(),
        ).format(_pickedDate),
      ),
      trailing: ElevatedButton(
        child: Text(
          LocaleKeys.changeDate.tr(),
        ),
        onPressed: _onPickDate,
      ),
    );
  }

  void _onPickDate() {
    FocusManager.instance.primaryFocus?.unfocus();

    showDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime.now().subtract(
        const Duration(
          days: 365,
        ),
      ),
      lastDate: DateTime.now(),
    ).then((DateTime? _chosenDate) {
      if (_chosenDate != null) {
        setState(() {
          _pickedDate = _chosenDate;
        });
        widget.onDatePicked(_chosenDate);
      }
    });
  }
}
