import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';

showCalculator({
  required BuildContext context,
  double? initialValue,
  void Function(
    String? lastSymbol,
    double? value,
    String? expression,
  )?
      onChanged,
}) async {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          final theme = Theme.of(context);

          return SimpleCalculator(
            numberFormat: NumberFormat.compact(),
            value: initialValue ?? 0,
            hideSurroundingBorder: true,
            onChanged: onChanged,
            theme: CalculatorThemeData(
              displayColor: theme.colorScheme.primary,
              borderWidth: 2,
              borderColor: state.isDarkTheme ? Colors.black : Colors.black54,
              operatorColor: state.isDarkTheme
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
              commandColor: theme.colorScheme.primary,
              expressionColor: theme.colorScheme.primary,
              numStyle: theme.textTheme.headlineLarge,
              expressionStyle: theme.textTheme.headlineLarge,
              commandStyle: theme.textTheme.headlineLarge,
            ),
          );
        },
      );
    },
  );
}
