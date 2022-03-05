import 'package:hive_flutter/adapters.dart';

class HiveWrapper {
  HiveWrapper._();

  static final HiveWrapper _instance = HiveWrapper._();

  factory HiveWrapper() {
    return _instance;
  }

  late final Box _box;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Box get box {
    if (!isInitialized) {
      throw const FormatException('HiveWrapper was not initialized');
    }

    return _box;
  }

  Future<void> initHive() async {
    if (!isInitialized) {
      await Hive.initFlutter();
      _box = await Hive.openBox('storage');

      _setInitialized();
    }
  }

  void _setInitialized() {
    _initialized = true;
  }
}
