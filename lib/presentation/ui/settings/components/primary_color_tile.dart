part of './../settings_screen.dart';

class PrimaryColorTile extends StatelessWidget {
  const PrimaryColorTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return ListTile(
          title: Text(
            AppLocalizationsWrapper.of(context).app_primary_color,
          ),
          trailing: IconButton(
            onPressed: () async {
              await _onPressed(
                context,
                state.primaryColor,
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 35,
            ),
            icon: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: state.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onPressed(BuildContext context, Color color) async {
    final Color? _pickedColor = await getIt<AppRouter>().push<Color?>(
      ColorPickerRoute(initialColor: color),
    );
    // Navigator.push<Color?>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => ColorPickerScreen(
    //       initialColor: color,
    //     ),
    //   ),
    // );

    if (_pickedColor != null) {
      BlocProvider.of<AppCubit>(context).setPrimaryColor(
        _pickedColor,
      );
    }
  }
}
