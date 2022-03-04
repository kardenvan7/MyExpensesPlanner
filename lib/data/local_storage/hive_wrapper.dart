import 'package:hive_flutter/adapters.dart';

class HiveWrapper {
  late final Box box;

  Future<void> initialize() async {
    await Hive.initFlutter();
    box = await Hive.openBox('storage');
  }
}
