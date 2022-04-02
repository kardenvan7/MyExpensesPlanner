part of '../settings_screen.dart';

class DataExportTile extends StatelessWidget {
  const DataExportTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExportCubit>(
      create: (context) => getIt<ExportCubit>(),
      child: Builder(
        builder: (context) {
          final _cubit = BlocProvider.of<ExportCubit>(context);

          return BlocConsumer<ExportCubit, ExportState>(
            listener: (listenerContext, state) {
              if (state.showDialog) {
                showDialog(
                  context: listenerContext,
                  builder: (context) => ExportStatusDialog(
                    exportCubit: _cubit,
                  ),
                );
              }

              if (state.closeDialog) {
                getIt<AppRouter>().pop();
              }
            },
            builder: (context, state) {
              return ListTile(
                onTap: () {
                  _cubit.onExportTap();
                },
                title: Text(
                  AppLocalizationsWrapper.of(context).export_to_file,
                ),
                trailing: const Icon(
                  MaterialCommunityIcons.export,
                  size: 24,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ExportStatusDialog extends StatelessWidget {
  const ExportStatusDialog({
    required this.exportCubit,
    Key? key,
  }) : super(key: key);

  final ExportCubit exportCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExportCubit>.value(
      value: exportCubit,
      child: BlocBuilder<ExportCubit, ExportState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              if (state.isLoading) {
                return Future.value(false);
              }

              return Future.value(true);
            },
            child: AlertDialog(
              title: Text(
                _getTitle(context, state),
                style: const TextStyle(
                  fontSize: 19,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              content: state.isLoading
                  ? SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    )
                  : state.errorOccurred
                      ? Container(
                          height: 100,
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                            minHeight: 100,
                          ),
                          child: Center(
                            child: Text(
                              state.errorMessage!,
                            ),
                          ),
                        )
                      : null,
              actions: state.isFinished || state.errorOccurred
                  ? [
                      TextButton(
                        onPressed: () {
                          getIt<AppRouter>().pop();
                        },
                        child: Text(
                          AppLocalizationsWrapper.of(context).close,
                        ),
                      ),
                    ]
                  : null,
            ),
          );
        },
      ),
    );
  }

  String _getTitle(BuildContext context, ExportState state) {
    return state.isLoading
        ? AppLocalizationsWrapper.of(context).export_in_process
        : state.errorMessage != null
            ? AppLocalizationsWrapper.of(context).export_failure
            : state.isFinished
                ? AppLocalizationsWrapper.of(context)
                    .export_finished_successfully
                : '';
  }
}
