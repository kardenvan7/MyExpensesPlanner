import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';

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
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 12,
      ),
      title: Text(
        DateFormat(
          'dd.MM.yyyy',
          Localizations.localeOf(context).toLanguageTag(),
        ).format(_pickedDate),
      ),
      trailing: ElevatedButton(
        child: Text(
          AppLocalizationsWrapper.of(context).change_date,
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
