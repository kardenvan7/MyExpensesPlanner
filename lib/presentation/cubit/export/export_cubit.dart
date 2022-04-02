import 'package:bloc/bloc.dart';
import 'package:my_expenses_planner/domain/core/export/file_export_handler.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  ExportCubit(
    this._transactionsCase,
    this._categoriesCase,
  ) : super(ExportState());

  static const String fileNamePrefix = 'my_expenses_planner_';

  final ITransactionsCase _transactionsCase;
  final ICategoriesCase _categoriesCase;

  Future<void> onExportTap() async {
    final FileExportHandler _exporter = FileExportHandler();
    await _exporter.requestAndSetPermission();

    if (_exporter.isPermissionGranted) {
      await _exporter.setDirectoryPath();

      if (_exporter.isDirectorySet) {
        emit(
          state.copyWith(
            showDialog: true,
            isLoading: true,
          ),
        );

        try {
          final Map<String, dynamic> _data = await _getDataMap();

          _exporter.setContent(_data);
          await _exporter.export();

          emit(
            state.copyWith(
              isLoading: false,
              isFinished: true,
            ),
          );
        } catch (e, st) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: e.toString(),
            ),
          );
        }
      }
    }
  }

  Future<Map<String, dynamic>> _getDataMap() async {
    final Map<String, dynamic> _map = {};

    final List<TransactionCategory> _categories =
        await _categoriesCase.getCategories();

    final List<Map<String, dynamic>> _categoriesMap = List.generate(
      _categories.length,
      (index) => _categories[index].toMap(),
    );

    final List<Transaction> _transactions =
        await _transactionsCase.getTransactions();

    final List<Map<String, dynamic>> _transactionsMap = List.generate(
      _transactions.length,
      (index) => _transactions[index].toMap(),
    );

    _map['categories'] = _categoriesMap;
    _map['transactions'] = _transactionsMap;

    return _map;
  }
}
