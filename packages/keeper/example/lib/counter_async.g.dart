// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_async.dart';

// **************************************************************************
// KeeperGenerator
// **************************************************************************

mixin _$CounterAsyncKeeper on _CounterAsync {
  KeepAsyncKey? _$valueKeepAsyncKey$0;

  @override
  KeepAsyncValue<int> get value {
    if (_$valueKeepAsyncKey$0 == null) {
      _$valueKeepAsyncKey$0 = counterAsyncValue();

      final _keyValue = _$valueKeepAsyncKey$0!.value as KeepAsyncValue<int>;
      if (_keyValue != super.value && _keyValue != null)
        super.value = _keyValue;
    }
    return super.value;
  }

  @override
  set value(KeepAsyncValue<int> value) {
    if (_$valueKeepAsyncKey$0 == null) {
      _$valueKeepAsyncKey$0 = counterAsyncValue();
    }

    super.value = value;
  }
}
