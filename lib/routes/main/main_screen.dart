import 'package:flutter/material.dart';
import 'package:my_expenses_planner/routes/main/components/app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainScreenAppBar(),
      body: Center(
        child: Text('MainScreen!'),
      ),
    );
  }
}
