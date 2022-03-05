part of './../settings_screen.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizationsWrapper.of(context).app_language),
      trailing: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
          builder: (context, state) {
            return IconButton(
              constraints: const BoxConstraints(
                minWidth: 35,
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                BlocProvider.of<AppSettingsCubit>(context).switchLanguage();
              },
              icon: _getIconByState(state),
            );
          },
        ),
      ),
    );
  }

  Widget _getIconByState(AppSettingsState state) {
    if (state.isEnglishLocale) {
      return Assets.svg.englishFlag.svg(
        width: 35,
        fit: BoxFit.fill,
      );
    } else {
      return Assets.svg.russianFlag.svg(
        width: 35,
        fit: BoxFit.fill,
      );
    }
  }
}
