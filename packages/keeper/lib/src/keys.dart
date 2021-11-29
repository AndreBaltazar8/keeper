import 'package:keeper/keeper.dart';

/// Represents a key in a Keep.
abstract class KeepKey<T> {
  /// The value of the key.
  T? get value;

  /// Sets the value of the key.
  set value(T? value);
}

/// Represents an async key in a Keep.
abstract class KeepAsyncKey<T> {
  /// Gets the value of the key.
  Future<T?> get();

  /// Sets the value of the key.
  Future<void> set(T? value);

  /// Returns a wrapped value for the key.
  KeepAsyncValue<T> value({required KeepAsyncValue<T>? defaultValue});
}
