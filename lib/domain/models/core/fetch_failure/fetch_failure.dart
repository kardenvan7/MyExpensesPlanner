import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_failure.freezed.dart';

@freezed
abstract class FetchFailure with _$FetchFailure {
  factory FetchFailure.unknown() = _$UnknownFetchFailure;
  factory FetchFailure.notFound() = _$NotFoundFetchFailure;
}
