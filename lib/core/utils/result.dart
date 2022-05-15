/// Class for wrapping result of a function so it can return 2 values.
///
/// Commonly used to get rid of try..catch clauses and return either failure
/// object or success object (or null if no object return needed)
///
/// In functions/methods where you need to return Result object use:
///
/// [Result.success] factory if function/method was successfully completed and
/// return value inside this constructor.
///
/// [Result.failure] factory if function/method has ended with failure. You can
/// pass failure object into this constructor to distinct error type in
/// outer functions/methods.
///
/// In functions/methods where you receive [Result] object use [fold] method
/// to define behaviours depending on the returned object (which might be
/// either [_Failure] or [Success])
///
/// If you don't need to return anything as a successful result, you can
/// specify second type parameter as [void] and return [Result.success(null)]
/// in the method
///
abstract class Result<F extends Object?, V extends Object?> extends Object {
  Result();

  factory Result.success(V value) => _Success(value);
  factory Result.failure(F failure) => _Failure(failure);

  bool get isFailure => this is F;
  bool get isSuccess => this is V;

  F get asFailure => this as F;
  V get asSuccess => this as V;

  TResult fold<TResult>({
    required TResult Function(F failure) onFailure,
    required TResult Function(V value) onSuccess,
  });
}

class _Success<F, V> extends Result<F, V> {
  _Success(this.value) : super();

  final V value;

  @override
  TResult fold<TResult>({
    required TResult Function(F failure) onFailure,
    required TResult Function(V value) onSuccess,
  }) {
    return onSuccess(value);
  }
}

class _Failure<F, V> extends Result<F, V> {
  _Failure(this.failure);

  final F failure;

  @override
  TResult fold<TResult>({
    required TResult Function(F failure) onFailure,
    required TResult Function(V value) onSuccess,
  }) {
    return onFailure(failure);
  }
}
