import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('MainScreen!'),
      ),
    );
  }
}
