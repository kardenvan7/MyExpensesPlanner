import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/export/export_failure.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class DataExportHandler {
  DataExportHandler({
    required ITransactionsRepository transactionsRepository,
    required ICategoriesRepository categoriesRepository,
  })  : _transactionsRepository = transactionsRepository,
        _categoriesRepository = categoriesRepository;

  final ITransactionsRepository _transactionsRepository;
  final ICategoriesRepository _categoriesRepository;

  static const String exportFileExtension = 'json';
  static const String exportFilePrefix = 'my_expenses_planner_';

  Future<Result<FetchFailure, String>> _getDirectoryPath() async {
    try {
      final String? _dirPath = await FilePicker.platform.getDirectoryPath();

      if (_dirPath == null) {
        return Result.failure(FetchFailure.notFound());
      }

      return Result.success(_dirPath);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  Future<Result<ExportFailure, void>> export() async {
    final _permission = await _requestPermission();

    if (_permission.isDenied || _permission.isPermanentlyDenied) {
      return Result.failure(ExportFailure.permissionDenied());
    }

    final _dirPathFetchResult = await _getDirectoryPath();

    return _dirPathFetchResult.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(ExportFailure.unknown()),
        notFound: () => Result.failure(ExportFailure.cancelled()),
      ),
      onSuccess: (String dirPath) async {
        final _fetchResult = await _getAndPrepareData();

        return _fetchResult.fold(
          onFailure: (failure) => Result.failure(ExportFailure.unknown()),
          onSuccess: (_data) async {
            try {
              final File _file = File(_getFileName(dirPath));

              await _file.writeAsString(json.encode(_data));

              return Result.success(null);
            } catch (_) {
              return Result.failure(ExportFailure.unknown());
            }
          },
        );
      },
    );
  }

  String _getFileName(String directoryPath) {
    return '$directoryPath/$exportFilePrefix'
        '${DateTime.now().millisecondsSinceEpoch}'
        '.$exportFileExtension';
  }

  Future<PermissionStatus> _requestPermission() async {
    final _permission = await Permission.storage.request();

    return _permission;
  }

  Future<Result<FetchFailure, Map<String, dynamic>>>
      _getAndPrepareData() async {
    final _result = await _categoriesRepository.getCategories();

    return _result.fold(
      onFailure: (failure) => Result.failure(failure),
      onSuccess: (_categories) async {
        final List<Map<String, dynamic>> _categoriesMap = List.generate(
          _categories.length,
          (index) => _categories[index].toMap(),
        );

        final _fetchResult = await _transactionsRepository.getTransactions();

        return _fetchResult.fold(
          onFailure: (failure) => Result.failure(failure),
          onSuccess: (transactions) {
            final Map<String, dynamic> _map = {};

            final List<Map<String, dynamic>> _transactionsMap = List.generate(
              transactions.length,
              (index) => transactions[index].toMap(),
            );

            _map['categories'] = _categoriesMap;
            _map['transactions'] = _transactionsMap;

            return Result.success(_map);
          },
        );
      },
    );
  }
}
