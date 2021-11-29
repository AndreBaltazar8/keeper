library keeper_hive;

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:keeper/keeper.dart';

class HiveKeep implements AsyncKeep {
  static final Map<String, HiveKeep> _instances = {};

  factory HiveKeep(String boxName) =>
      _instances[boxName] ??= HiveKeep._(boxName);

  HiveKeep._(this.boxName);

  final String boxName;

  @override
  KeepAsyncKey<T> asyncKey<T>(String key) {
    return _HiveKeepAsyncKey<T>(this, key);
  }

  Future<Box<dynamic>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) return Hive.box(boxName);
    return await Hive.openBox(boxName);
  }
}

class _HiveKeepAsyncKey<T> implements KeepAsyncKey<T> {
  final HiveKeep keep;
  final String key;

  _HiveKeepAsyncKey(this.keep, this.key);

  @override
  Future<T?> get() async {
    final box = await keep._getBox();
    return box.get(key) as T?;
  }

  @override
  Future<void> set(T? value) async {
    final box = await keep._getBox();
    box.put(key, value);
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
  final _HiveKeepAsyncKey<T> asyncKey;
  final T? defaultValue;
  bool _isLoaded = false;
  T? _value;

  _MemoryKeepAsyncValue(this.asyncKey, this.defaultValue) {
    _load();
  }

  void _load() async {
    _value = await asyncKey.get();
    _isLoaded = true;
  }

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
    try {
      if (_isLoaded)
        return data(_value as T);
      else
        return loading();
    } on TypeError {
      if (defaultValue == null) {
        throw KeeperException('No value for key ${asyncKey.key}.');
      }
      return data(defaultValue as T);
    }
  }

  @override
  set value(T value) {
    set(value);
  }
}
