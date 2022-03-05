part of '../settings_screen.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizationsWrapper.of(context).app_dark_theme,
      ),
      trailing: BlocBuilder<AppSettingsCubit, AppState>(
        builder: (context, state) {
          return CupertinoSwitch(
            onChanged: (bool value) {
              BlocProvider.of<AppSettingsCubit>(context).switchTheme();
            },
            value: !state.isLightTheme,
          );
        },
      ),
      contentPadding: const EdgeInsets.only(
        right: 10,
        left: 16,
      ),
    );
  }
}
