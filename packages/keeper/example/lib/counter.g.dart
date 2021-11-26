// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// KeeperGenerator
// **************************************************************************

mixin _$CounterKeeper on _Counter {
  KeepKey? _$valueKeepKey$0;

  @override
  int get value {
    if (_$valueKeepKey$0 == null) {
      _$valueKeepKey$0 = counterValue();

      final _keyValue = _$valueKeepKey$0!.value;
      if (_keyValue != super.value && _keyValue != null)
        super.value = _keyValue;
    }
    return super.value;
  }

  @override
  set value(int value) {
    if (_$valueKeepKey$0 == null) {
      _$valueKeepKey$0 = counterValue();
    }
    _$valueKeepKey$0!.value = value;

    super.value = value;
  }
}
