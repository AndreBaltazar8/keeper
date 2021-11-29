import 'package:keeper/src/exceptions.dart';

abstract class KeepAsyncValue<T> {
  set value(T value);
  Future<void> set(T value);
  Future<T> get();
  R map<R>({
    required R Function(T value) data,
    required R Function() loading,
    required R Function(Object? error, StackTrace? stackTrace) error,
  });

  const factory KeepAsyncValue(T value) = DefaultKeepAsyncValue<T>;
}

class DefaultKeepAsyncValue<T> implements KeepAsyncValue<T> {
  final T defaultValue;
  const DefaultKeepAsyncValue(this.defaultValue);

  @override
  Future<T> get() => Future.value(defaultValue);

  @override
  R map<R>({
    required R Function(T value) data,
    required R Function() loading,
    required R Function(Object? error, StackTrace? stackTrace) error,
  }) {
    return data(defaultValue);
  }

  @override
  Future<void> set(T? value) async {
    throw KeeperException('Cannot set value on default async value.');
  }

  @override
  set value(T? value) {
    set(value).catchError((_, __) {});
  }
}
