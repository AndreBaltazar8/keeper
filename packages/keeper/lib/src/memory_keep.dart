import 'package:keeper/keeper.dart';

class MemoryKeep {
  final Map<String, dynamic> _values = {};
  static final MemoryKeep _instance = MemoryKeep.create();
  MemoryKeep.create();
  factory MemoryKeep() => _instance;
  KeepKey<T> key<T>(String key) => _MemoryKeepKey<T>(this, key);
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
