import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/settings/settings_screen.dart';

class MainScreenDrawer extends StatelessWidget {
  const MainScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                //   margin: const EdgeInsets.only(top: 50),
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       ListView(
                //         shrinkWrap: true,
                //         physics: const NeverScrollableScrollPhysics(),
                //         children: [
                //           ListTile(
                //             leading: const Icon(Icons.stacked_bar_chart),
                //             title: Text(
                //               AppLocalizationsWrapper.of(context).statistics,
                //             ),
                //             onTap: () {
                //               DI.instance<AppRouter>().push(
                //                 PeriodStatisticsRoute(),
                //               );
                //             },
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(AppLocalizationsFacade.of(context).settings),
                    onTap: () {
                      DI.instance<AppRouter>().pushNamed(SettingsScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
