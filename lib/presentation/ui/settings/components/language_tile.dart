part of './../settings_screen.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizationsFacade.of(context).app_language),
      trailing: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlagButton(
                icon: Assets.svg.englishFlag.svg(
                  width: 35,
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  BlocProvider.of<AppSettingsCubit>(context).setLocale(
                    SupportedLocales.english,
                  );
                },
                isSelected: state.isEnglishLocale,
              ),
              const SizedBox(
                width: 20,
              ),
              FlagButton(
                icon: Assets.svg.russianFlag.svg(
                  width: 35,
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  BlocProvider.of<AppSettingsCubit>(context).setLocale(
                    SupportedLocales.russian,
                  );
                },
                isSelected: state.isRussianLocale,
              ),
            ],
          );
        },
      ),
    );
  }
}

class FlagButton extends StatelessWidget {
  const FlagButton({
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  final Widget icon;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
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
              if (!isSelected) {
                onPressed();
              }
            },
            icon: icon,
          );
        },
      ),
    );
  }
}
