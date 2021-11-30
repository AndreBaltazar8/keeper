# Example

All the examples require Hive initialization first, with either `Hive.init` or `Hive.initFlutter` depending on your target.

## Counter ([`counter.dart`](https://github.com/AndreBaltazar8/keeper/blob/master/packages/keeper_hive/example/lib/counter.dart))

The example of a counter using Keeper and Hive.

```dart
import 'package:keeper/keeper.dart';
import 'package:keeper_hive/keeper_hive.dart';

part 'counter.g.dart';

class Counter = _Counter with _$CounterKeeper;

KeepAsyncKey<int> counterAsyncValue() => HiveKeep('user').asyncKey('counter');

@kept
class _Counter {
  @AtAsync(counterAsyncValue)
  KeepAsyncValue<int> value = KeepAsyncValue(0);

  Future increment() async {
    await value.set(await value.get() + 1);
  }
}
```

## Authentication Service ([`authentication_service.dart`](https://github.com/AndreBaltazar8/keeper/blob/master/packages/keeper_hive/example/lib/authentication_service.dart))

A simple example of how to store a login boolean value for authentication.

```dart
import 'package:keeper/keeper.dart';
import 'package:keeper_hive/keeper_hive.dart';

part 'authentication_service.g.dart';

KeepAsyncKey<bool> userLoggedIn() => HiveKeep('user').asyncKey('loggedIn');

class AuthenticationService = _AuthenticationService
    with _$AuthenticationServiceKeeper;

@kept
class _AuthenticationService {
  @AtAsync(userLoggedIn)
  KeepAsyncValue<bool> loggedIn = KeepAsyncValue(false);

  Future<void> login() async {
    await loggedIn.set(true);
    print('Logged in!');
  }

  Future<void> logout() async {
    await loggedIn.set(false);
    print('Logged out!');
  }
}
```
