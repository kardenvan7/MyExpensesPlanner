import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DataExportHandler {
  static const String exportFileExtension = 'json';
  static const String exportFilePrefix = 'my_expenses_planner_';

  String? directoryPath;
  String? fileContent;
  PermissionStatus? permissionStatus;

  bool get isPermissionGranted => permissionStatus == PermissionStatus.granted;
  bool get isPermissionSet => permissionStatus != null;

  bool get isDirectorySet => directoryPath != null;
  bool get isContentSet => fileContent != null;

  bool get isReadyForExport =>
      isDirectorySet && isContentSet && isPermissionGranted;

  Future<void> setDirectoryPath() async {
    try {
      directoryPath = await FilePicker.platform.getDirectoryPath();
    } catch (_, __) {}
  }

  void setContent(dynamic content) {
    fileContent = json.encode(content);
  }

  Future<void> export() async {
    if (!isReadyForExport) {
      throw FormatException(
        'File is not ready for export.\n'
        'Is directory set: $isDirectorySet\n'
        'Is content set: $isContentSet\n'
        'Permission status: $permissionStatus',
      );
    }

    final File _file = File(fileName);

    await _file.writeAsString(fileContent!);
  }

  Future<void> requestAndSetPermission() async {
    permissionStatus = await Permission.storage.request();
  }

  String get fileName => '$directoryPath/$exportFilePrefix'
      '${DateTime.now().millisecondsSinceEpoch}'
      '.$exportFileExtension';
}
