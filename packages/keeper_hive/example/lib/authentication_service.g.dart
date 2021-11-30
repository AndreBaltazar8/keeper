// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_service.dart';

// **************************************************************************
// KeeperGenerator
// **************************************************************************

mixin _$AuthenticationServiceKeeper on _AuthenticationService {
  KeepAsyncKey? _$loggedInKeepAsyncKey$0;

  @override
  KeepAsyncValue<bool> get loggedIn {
    if (_$loggedInKeepAsyncKey$0 == null) {
      _$loggedInKeepAsyncKey$0 = userLoggedIn();

      final _keyValue = _$loggedInKeepAsyncKey$0!
          .value(defaultValue: super.loggedIn) as KeepAsyncValue<bool>;
      if (_keyValue != super.loggedIn) super.loggedIn = _keyValue;
    }
    return super.loggedIn;
  }

  @override
  set loggedIn(KeepAsyncValue<bool> value) {
    if (_$loggedInKeepAsyncKey$0 == null) {
      _$loggedInKeepAsyncKey$0 = userLoggedIn();

      final _keyValue = _$loggedInKeepAsyncKey$0!
          .value(defaultValue: super.loggedIn) as KeepAsyncValue<bool>;
      if (_keyValue != super.loggedIn) super.loggedIn = _keyValue;
    }
    value.get().then((value) => _$loggedInKeepAsyncKey$0!.set(value));
  }
}
