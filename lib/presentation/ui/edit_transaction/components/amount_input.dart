import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/show_calculator.dart';

class AmountInput extends StatefulWidget {
  const AmountInput({
    required this.value,
    required this.onChanged,
    this.errorText,
    Key? key,
  }) : super(key: key);

  final String? value;
  final void Function(String? string) onChanged;
  final String? errorText;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  bool get isErrorState => widget.errorText != null;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text(
                    AppLocalizationsWrapper.of(context).amount_input_label,
                  ),
                  enabledBorder: isErrorState
                      ? Theme.of(context).inputDecorationTheme.errorBorder
                      : Theme.of(context).inputDecorationTheme.enabledBorder,
                ),
              ),
              if (isErrorState)
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 7),
                  child: Text(
                    widget.errorText!,
                    style: Theme.of(context).inputDecorationTheme.errorStyle,
                  ),
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();

              showCalculator(
                context: context,
                onChanged: (
                  String? lastSymbol,
                  double? value,
                  String? expression,
                ) {
                  _controller.text = value?.toString() ?? '';
                },
                initialValue: double.tryParse(_controller.text),
              );
            },
            icon: const Icon(
              Icons.calculate_outlined,
            ),
          ),
        ),
      ],
    );
  }
}
