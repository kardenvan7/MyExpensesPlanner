import 'package:hive_flutter/adapters.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

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

  Future<Result<FetchFailure, String>> get(String key) async {
    final dynamic _value = _box.get(key);

    if (_value == null) {
      return Result.failure(FetchFailure.notFound());
    }

    if (_value! is String) {
      return Result.failure(FetchFailure.unknown());
    }

    return Result.success(_value);
  }

  Future<Result<FetchFailure, void>> put(
    String key,
    String value,
  ) async {
    try {
      await _box.put(key, value);
      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }
}
