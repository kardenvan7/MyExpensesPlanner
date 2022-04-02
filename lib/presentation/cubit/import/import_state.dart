part of 'import_cubit.dart';

class ImportState {
  ImportState({
    this.fileName,
    this.filePath,
    this.showDialog = false,
    this.closeDialog = false,
    this.isLoading = false,
    this.isFinished = false,
    this.errorMessage,
  });

  final String? filePath;
  final String? fileName;
  final bool showDialog;
  final bool isLoading;
  final bool isFinished;
  final bool closeDialog;
  final String? errorMessage;

  bool get errorOccurred => errorMessage != null;

  ImportState copyWith({
    String? filePath,
    String? fileName,
    bool? showDialog,
    bool? closeDialog,
    bool? isLoading,
    bool? isFinished,
    String? errorMessage,
  }) {
    return ImportState(
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      showDialog: showDialog ?? false,
      closeDialog: closeDialog ?? false,
      isLoading: isLoading ?? false,
      isFinished: isFinished ?? false,
      errorMessage: errorMessage,
    );
  }
}
