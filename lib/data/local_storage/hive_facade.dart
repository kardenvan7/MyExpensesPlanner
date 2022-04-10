import 'package:hive_flutter/adapters.dart';

class HiveFacade {
  HiveFacade._();

  static final HiveFacade _instance = HiveFacade._();

  factory HiveFacade() {
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
