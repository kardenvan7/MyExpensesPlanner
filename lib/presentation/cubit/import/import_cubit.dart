import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/exceptions.dart';
import 'package:my_expenses_planner/domain/core/import/data_import_handler.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

part 'import_state.dart';

class ImportCubit extends Cubit<ImportState> {
  ImportCubit(
    this._transactionsCase,
    this._categoriesCase,
  ) : super(
          ImportState(),
        );

  final ITransactionsCase _transactionsCase;
  final ICategoriesCase _categoriesCase;

  Future<void> onImportButtonPressed() async {
    final DataImportHandler _importer = DataImportHandler();

    await _importer.requestAndSetPermission();

    if (_importer.isPermissionGranted) {
      try {
        await _importer.pickAndSetFile();

        if (_importer.isFilePicked) {
          emit(state.copyWith(isLoading: true, showDialog: true));

          final String _dataString = await _importer.readFile();

          await _saveDataFromString(_dataString);

          emit(
            state.copyWith(
              isLoading: false,
              isFinished: true,
            ),
          );
        }
      } on UnsupportedFileExtension catch (_) {
        emit(
          state.copyWith(
            errorMessage: AppLocalizationsWrapper.ofGlobalContext()
                .file_extension_unsupported,
          ),
        );
      } catch (e, _) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

  Future<void> _saveDataFromString(String dataString) async {
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

    await _categoriesCase.saveMultiple(_categories);
    await _transactionsCase.saveMultiple(transactions: _transactions);
  }
}
