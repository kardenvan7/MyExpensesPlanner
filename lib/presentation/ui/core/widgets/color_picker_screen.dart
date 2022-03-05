import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';

class ColorPickerScreen extends StatelessWidget {
  ColorPickerScreen({
    Color? initialColor,
    Key? key,
  })  : initialColor = initialColor ?? Colors.white,
        super(key: key);

  static const String routeName = '/color_picker';

  final Color initialColor;
  final ColorController _controller = ColorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ColorPicker(
          pickerColor: initialColor,
          onColorChanged: (Color color) {
            _controller.setColor(color);
          },
          enableAlpha: false,
          paletteType: PaletteType.hsv,
          labelTypes: const [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onSavePressed(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void _onSavePressed(BuildContext context) {
    getIt<AppRouter>().pop(_controller.value);
  }
}

class ColorController {
  ColorController();

  Color? _color;

  void setColor(Color newColor) {
    _color = newColor;
  }

  Color? get value => _color;
}
