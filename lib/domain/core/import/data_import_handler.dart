import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:my_expenses_planner/core/exceptions.dart';
import 'package:permission_handler/permission_handler.dart';

class DataImportHandler {
  static const String importFileExtension = 'json';

  PermissionStatus? permissionStatus;
  File? file;

  bool get isPermissionGranted => permissionStatus == PermissionStatus.granted;
  bool get isPermissionSet => permissionStatus != null;

  bool get isFilePicked => file != null;

  bool get isReadyForImport => isPermissionGranted && isFilePicked;

  Future<void> pickAndSetFile() async {
    final FilePickerResult? _pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: [
      //   importFileExtension,
      // ],
    );

    if (_pickerResult != null) {
      final PlatformFile _pickedFile = _pickerResult.files[0];

      if (_pickedFile.path != null) {
        if (_pickedFile.path!.endsWith('.$importFileExtension')) {
          file = File(_pickedFile.path!);
        } else {
          throw UnsupportedFileExtension();
        }
      }
    }
  }

  Future<String> readFile() async {
    if (!isReadyForImport) {
      throw FormatException(
        'Importer not ready for import:\n'
        'Permission status: $permissionStatus\n'
        'Is file picked: $isFilePicked',
      );
    }

    return file!.readAsString();
  }

  Future<void> requestAndSetPermission() async {
    permissionStatus = await Permission.storage.request();
  }
}
