import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('main_appbar_title').tr(),
    );
  }
}
