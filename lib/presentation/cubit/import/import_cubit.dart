import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/domain/core/import/data_import_handler.dart';

part 'import_state.dart';

class ImportCubit extends Cubit<ImportState> {
  ImportCubit(this._importHandler)
      : super(
          ImportState(),
        );

  final DataImportHandler _importHandler;

  Future<void> onImportButtonPressed() async {
    emit(state.copyWith(isLoading: true, showDialog: true));

    final _result = await _importHandler.import();

    _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () {
          emit(
            state.copyWith(
              errorMessage: AppLocalizationsFacade.ofGlobalContext()
                  .unknown_error_occurred,
            ),
          );
        },
        permissionDenied: () {},
        cancelled: () {},
        wrongFileFormat: () {
          emit(
            state.copyWith(
              errorMessage: AppLocalizationsFacade.ofGlobalContext()
                  .file_extension_unsupported,
            ),
          );
        },
      ),
      onSuccess: (_) {
        emit(
          state.copyWith(
            isLoading: false,
            isFinished: true,
          ),
        );
      },
    );
  }
}
