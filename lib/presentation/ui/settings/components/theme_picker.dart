part of '../settings_screen.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizationsFacade.of(context).app_dark_theme,
      ),
      trailing: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return CupertinoSwitch(
            onChanged: (bool value) {
              BlocProvider.of<AppSettingsCubit>(context).switchTheme();
            },
            value: state.isDarkTheme,
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
