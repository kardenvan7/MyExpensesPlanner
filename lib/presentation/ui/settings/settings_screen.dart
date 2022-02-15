import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/assets/assets.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';

part './components/settings_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  title: Text(AppLocalizationsWrapper.of(context).app_language),
                  trailing: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: BlocBuilder<AppCubit, AppState>(
                      builder: (context, state) {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            BlocProvider.of<AppCubit>(context).switchLanguage();
                          },
                          icon: state.isEnglishLocale
                              ? Assets.svg.englishFlag.svg(
                                  width: 35,
                                  fit: BoxFit.fill,
                                )
                              : Assets.svg.russianFlag.svg(
                                  width: 35,
                                  fit: BoxFit.fill,
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
