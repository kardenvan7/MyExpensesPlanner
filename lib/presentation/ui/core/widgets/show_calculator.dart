import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
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
          return SimpleCalculator(
            value: initialValue ?? 0,
            hideSurroundingBorder: true,
            onChanged: onChanged,
            theme: CalculatorThemeData(
              displayColor: Theme.of(context).colorScheme.primary,
              borderColor: state.isDarkTheme ? Colors.black38 : Colors.black54,
              operatorColor: state.isDarkTheme
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              commandColor: Theme.of(context).colorScheme.primary,
              expressionColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      );
    },
  );
}
