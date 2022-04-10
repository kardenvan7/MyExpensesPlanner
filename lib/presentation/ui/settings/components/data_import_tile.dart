part of '../settings_screen.dart';

class DataImportTile extends StatelessWidget {
  const DataImportTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImportCubit>(
      create: (context) => getIt<ImportCubit>(),
      child: Builder(builder: (context) {
        final _cubit = BlocProvider.of<ImportCubit>(context);

        return BlocConsumer<ImportCubit, ImportState>(
          listener: (listenerContext, state) {
            if (state.showDialog) {
              showDialog(
                context: listenerContext,
                builder: (context) => ImportStatusDialog(
                  importCubit: _cubit,
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
                _cubit.onImportButtonPressed();
              },
              title: Text(
                AppLocalizationsFacade.of(context).import_from_file,
              ),
              trailing: const Icon(
                MaterialCommunityIcons.import,
                size: 24,
              ),
            );
          },
        );
      }),
    );
  }
}

class ImportStatusDialog extends StatelessWidget {
  const ImportStatusDialog({
    required this.importCubit,
    Key? key,
  }) : super(key: key);

  final ImportCubit importCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImportCubit>.value(
      value: importCubit,
      child: BlocBuilder<ImportCubit, ImportState>(
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
                          AppLocalizationsFacade.of(context).close,
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

  String _getTitle(BuildContext context, ImportState state) {
    return state.isLoading
        ? AppLocalizationsFacade.of(context).import_in_process
        : state.errorMessage != null
            ? AppLocalizationsFacade.of(context).import_failure
            : state.isFinished
                ? AppLocalizationsFacade.of(context)
                    .import_finished_successfully
                : '';
  }
}
