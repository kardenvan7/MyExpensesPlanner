import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_failure.freezed.dart';

@freezed
abstract class ExportFailure with _$ExportFailure {
  factory ExportFailure.unknown() = _$UnknownExportFailure;
  factory ExportFailure.cancelled() = _$TargetDirectoryNotPickedExportFailure;
  factory ExportFailure.permissionDenied() = _$PermissionDeniedExportFailure;
}
