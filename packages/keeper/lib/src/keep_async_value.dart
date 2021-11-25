abstract class KeepAsyncValue<T> {
  set value(T value);
  Future<void> set(T value);
  Future<T> get();
  R map<R>({
    required R Function(T value) data,
    required R Function() loading,
    required R Function(Object? error, StackTrace? stackTrace) error,
  });

  const factory KeepAsyncValue(T value) = _DefaultKeepAsyncValue<T>;
}

class _DefaultKeepAsyncValue<T> implements KeepAsyncValue<T> {
  final T _value;
  const _DefaultKeepAsyncValue(T value) : this._value = value;

  @override
  Future<T> get() => Future.value(_value);

  @override
  R map<R>({
    required R Function(T value) data,
    required R Function() loading,
    required R Function(Object? error, StackTrace? stackTrace) error,
  }) {
    return data(_value);
  }

  @override
  Future<void> set(T value) async {
    throw UnsupportedError('Cannot set value on default async value.');
  }

  @override
  set value(T value) {
    set(value).catchError((_, __) {});
  }
}
