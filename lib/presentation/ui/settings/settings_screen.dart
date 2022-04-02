import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/assets/assets.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/flutter_icons/flutter_icons.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/export/export_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/import/import_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';

part './components/data_export_tile.dart';
part './components/data_import_tile.dart';
part './components/language_tile.dart';
part './components/settings_app_bar.dart';
part './components/theme_picker.dart';

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                LanguageTile(),
                Divider(height: 0),
                ThemePicker(),
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                DataExportTile(),
                Divider(height: 0),
                DataImportTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
