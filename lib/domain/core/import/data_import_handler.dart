import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/import_failure.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:permission_handler/permission_handler.dart';

class DataImportHandler {
  DataImportHandler({
    required ITransactionsCase transactionsCase,
    required ICategoriesCase categoriesCase,
  })  : _transactionsCase = transactionsCase,
        _categoriesCase = categoriesCase;

  final ITransactionsCase _transactionsCase;
  final ICategoriesCase _categoriesCase;

  static const String importFileExtension = 'json';

  Future<Result<ImportFailure, File>> _getFile() async {
    try {
      final FilePickerResult? _pickerResult =
          await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (_pickerResult != null) {
        final PlatformFile _pickedFile = _pickerResult.files[0];

        if (_pickedFile.path != null) {
          if (_pickedFile.path!.endsWith('.$importFileExtension')) {
            return Result.success(File(_pickedFile.path!));
          } else {
            return Result.failure(ImportFailure.wrongFileFormat());
          }
        } else {
          return Result.failure(ImportFailure.cancelled());
        }
      } else {
        return Result.failure(ImportFailure.cancelled());
      }
    } catch (_) {
      return Result.failure(ImportFailure.unknown());
    }
  }

  Future<Result<ImportFailure, void>> import() async {
    final _permission = await requestPermission();

    if (_permission.isPermanentlyDenied || _permission.isDenied) {
      return Result.failure(ImportFailure.permissionDenied());
    }

    final _result = await _getFile();

    return _result.fold(
      onFailure: (failure) => Result.failure(failure),
      onSuccess: (file) async {
        try {
          final String _json = await file.readAsString();
          final _saveResult = await _saveDataFromString(_json);

          return _saveResult.fold(
            onFailure: (_) => Result.failure(ImportFailure.unknown()),
            onSuccess: (_) => Result.success(null),
          );
        } catch (_) {
          return Result.failure(ImportFailure.wrongFileFormat());
        }
      },
    );
  }

  Future<PermissionStatus> requestPermission() async {
    return Permission.storage.request();
  }

  Future<Result<FetchFailure, void>> _saveDataFromString(
    String dataString,
  ) async {
    try {
      final Map<String, dynamic> _dataMap = json.decode(dataString);

      final List<dynamic> _categoriesMap = _dataMap['categories'];
      final List<dynamic> _transactionsMap = _dataMap['transactions'];

      final List<TransactionCategory> _categories = List.generate(
        _categoriesMap.length,
        (index) => TransactionCategory.fromMap(_categoriesMap[index]),
      );

      final List<Transaction> _transactions = List.generate(
        _transactionsMap.length,
        (index) => Transaction.fromMap(_transactionsMap[index]),
      );

      final _saveResult = await _categoriesCase.saveMultiple(_categories);

      return _saveResult.fold(
        onFailure: (failure) => Result.failure(failure),
        onSuccess: (_) async {
          final _saveResult = await _transactionsCase.saveMultiple(
            transactions: _transactions,
          );

          return _saveResult.fold(
            onFailure: (failure) => Result.failure(failure),
            onSuccess: (_) => Result.success(null),
          );
        },
      );
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }
}
