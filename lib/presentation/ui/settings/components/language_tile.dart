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
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return IconButton(
              constraints: const BoxConstraints(
                minWidth: 35,
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                BlocProvider.of<AppCubit>(context).switchLanguage();
              },
              icon: _getIconByState(state),
            );
          },
        ),
      ),
    );
  }

  Widget _getIconByState(AppState state) {
    printWithBrackets(state.locale);

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
