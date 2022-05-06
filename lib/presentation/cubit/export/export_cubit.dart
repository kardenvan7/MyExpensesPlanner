import 'package:bloc/bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/domain/core/export/data_export_handler.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  ExportCubit(
    this._exportHandler,
  ) : super(ExportState());

  final DataExportHandler _exportHandler;

  Future<void> onExportTap() async {
    final _exportResult = await _exportHandler.export();

    _exportResult.fold(
      onFailure: (failure) => failure.when(
        unknown: () {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage:
                  AppLocalizationsFacade.ofGlobalContext().export_failure,
            ),
          );
        },
        cancelled: () {},
        permissionDenied: () {},
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
