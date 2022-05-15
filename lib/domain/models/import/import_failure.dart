import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_failure.freezed.dart';

@freezed
abstract class ImportFailure with _$ImportFailure {
  factory ImportFailure.unknown() = _$UnknownImportFailure;
  factory ImportFailure.permissionDenied() = _$PermissionDeniedImportFailure;
  factory ImportFailure.cancelled() = _$CancelledImportFailure;
  factory ImportFailure.wrongFileFormat() = _$WrongFileFormatImportFailure;
}
