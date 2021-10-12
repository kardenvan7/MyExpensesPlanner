import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/routes/main/main_screen.dart';

void main() {
  runApp(MyExpensesPlanner());
}

class MyExpensesPlanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      routes: {
        MainScreen.routeName: (BuildContext context) => MainScreen(),
      },
    );
  }
}
