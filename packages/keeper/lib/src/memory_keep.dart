import 'package:keeper/keeper.dart';

class MemoryKeep {
  final Map<String, dynamic> _values = {};
  static final MemoryKeep _instance = MemoryKeep.create();
  MemoryKeep.create();
  factory MemoryKeep() => _instance;
  KeepKey<T> key<T>(String key) => _MemoryKeepKey<T>(this, key);
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
  KeepAsyncValue<T> get value => _MemoryKeepAsyncValue(this);
}

class _MemoryKeepAsyncValue<T> implements KeepAsyncValue<T> {
  final _MemoryKeepAsyncKey<T> asyncKey;
  _MemoryKeepAsyncValue(this.asyncKey);

  @override
  Future<T> get() async {
    final value = await asyncKey.get();
    if (value == null) throw 'Unknown value';
    return value;
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
