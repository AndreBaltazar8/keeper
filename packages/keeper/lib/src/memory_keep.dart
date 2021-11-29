import 'package:keeper/keeper.dart';
import 'package:keeper/src/keep_async_value.dart';

/// A Keep that is in memory. It is not persisted to disk.
class MemoryKeep {
  final Map<String, dynamic> _values = {};
  static final MemoryKeep _instance = MemoryKeep.create();

  /// Creates a new instance of the keep.
  MemoryKeep.create();

  /// Returns a singleton instance of the keep.
  factory MemoryKeep() => _instance;

  /// Returns a key in the keep.
  KeepKey<T> key<T>(String key) => _MemoryKeepKey<T>(this, key);

  /// Returns an async key in the keep.
  KeepAsyncKey<T> asyncKey<T>(String key) => _MemoryKeepAsyncKey<T>(this, key);

  dynamic _get<T>(String key) {
    return _values[key];
  }

  void _set<T>(String key, dynamic value) {
    _values[key] = value;
  }
}

class _MemoryKeepKey<T> extends KeepKey<T> {
  final MemoryKeep keep;
  final String key;

  _MemoryKeepKey(this.keep, this.key);

  @override
  T? get value => keep._get(key) as T?;

  @override
  set value(T? value) => keep._set(key, value);
}

class _MemoryKeepAsyncKey<T> extends KeepAsyncKey<T> {
  final MemoryKeep keep;
  final String key;

  _MemoryKeepAsyncKey(this.keep, this.key);

  @override
  Future<T?> get() {
    return Future.value(keep._get(key) as T?);
  }

  @override
  Future<void> set(T? value) {
    keep._set(key, value);
    return Future.value();
  }

  @override
  KeepAsyncValue<T> value({KeepAsyncValue<T>? defaultValue}) =>
      _MemoryKeepAsyncValue(
          this,
          defaultValue is DefaultKeepAsyncValue<T>
              ? defaultValue.defaultValue
              : null);
}

class _MemoryKeepAsyncValue<T> implements KeepAsyncValue<T> {
  final _MemoryKeepAsyncKey<T> asyncKey;
  final T? defaultValue;

  _MemoryKeepAsyncValue(this.asyncKey, this.defaultValue);

  @override
  Future<T> get() async {
    try {
      return await asyncKey.get() as T;
    } on TypeError {
      if (defaultValue == null) {
        throw KeeperException('No value for key ${asyncKey.key}.');
      }
      return defaultValue as T;
    }
  }

  @override
  Future<void> set(T value) => asyncKey.set(value);

  @override
  R map<R>(
      {required R Function(T value) data,
      required R Function() loading,
      required R Function(Object? error, StackTrace? stackTrace) error}) {
    final value = asyncKey.keep._get(asyncKey.key) as T?;
    if (value == null) error(null, null);
    return data(value as T);
  }

  @override
  set value(T value) {
    set(value);
  }
}
