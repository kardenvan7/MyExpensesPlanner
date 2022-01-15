import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    required this.items,
    required this.onValueChanged,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  final T initialValue;
  final void Function(T value) onValueChanged;
  final List<CustomDropdownItem<T>> items;

  @override
  _CustomDropdownState createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isOpened = false;

  late final void Function(T value) _onValueChanged = widget.onValueChanged;
  late T _pickedValue = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final CustomDropdownItem<T> _pickedItem =
        _getItemByValue(widget.initialValue);

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 65,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black38,
              width: 1,
            ),
            borderRadius: !_isOpened
                ? BorderRadius.circular(5)
                : const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_pickedItem.leading != null) _pickedItem.leading!,
              const SizedBox(
                width: 15,
              ),
              _pickedItem.title,
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      _isOpened
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isOpened = !_isOpened;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isOpened)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black38,
                ),
                right: BorderSide(
                  color: Colors.black38,
                ),
                left: BorderSide(
                  color: Colors.black38,
                ),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: widget.items[index],
                  onTap: () {
                    setState(() {
                      _pickedValue = widget.items[index].value;
                      _isOpened = false;
                      _onValueChanged(_pickedValue);
                    });
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 0,
                );
              },
              itemCount: widget.items.length,
            ),
          )
      ],
    );
  }

  CustomDropdownItem<T> _getItemByValue(T value) {
    return widget.items.firstWhere((element) => element.value == value);
  }
}

class CustomDropdownItem<T> extends StatelessWidget {
  const CustomDropdownItem({
    required this.value,
    required this.title,
    this.trailing,
    this.leading,
    Key? key,
  }) : super(key: key);

  final T value;
  final Widget title;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: title,
    );
  }
}
