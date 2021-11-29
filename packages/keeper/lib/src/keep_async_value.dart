import 'package:keeper/src/exceptions.dart';

/// A async value that is stored in Keeper.
///
/// This represents one or multiple keys that are accessed through the Keeper.
abstract class KeepAsyncValue<T> {
  /// Sets the value contained in the [KeepAsyncValue].
  set value(T value);

  /// Sets the value contained in the [KeepAsyncValue].
  ///
  /// The future is complete upon saving the value.
  Future<void> set(T value);

  /// Gets the value contained in the [KeepAsyncValue].
  Future<T> get();

  /// Maps the value contained in the [KeepAsyncValue].
  R map<R>({
    required R Function(T value) data,
    required R Function() loading,
    required R Function(Object? error, StackTrace? stackTrace) error,
  });

  // Creates a default value for a [KeepAsyncValue].
  const factory KeepAsyncValue(T value) = DefaultKeepAsyncValue<T>;
}

/// Represents a default value for [KeepAsyncValue].
class DefaultKeepAsyncValue<T> implements KeepAsyncValue<T> {
  /// The default value.
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
