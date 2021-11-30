# Example

These are simple examples of a Counter class. They show how to use the plugin with the synchronous and asynchronous keys.

## Counter ([`counter.dart`](https://github.com/AndreBaltazar8/keeper/blob/master/packages/keeper/example/lib/counter.dart))

The example of a counter using sync keys.

```dart
import 'package:keeper/keeper.dart';

part 'counter.g.dart';

class Counter = _Counter with _$CounterKeeper;

KeepKey counterValue() => MemoryKeep().key('counter_value');

@kept
class _Counter {
  @At(counterValue)
  int value = 0;

  void increment() {
    value++;
  }
}
```

## Counter Async ([`counter_async.dart`](https://github.com/AndreBaltazar8/keeper/blob/master/packages/keeper/example/lib/counter_async.dart))

The example of a counter using async keys.

```dart
import 'package:keeper/keeper.dart';

part 'counter_async.g.dart';

class CounterAsync = _CounterAsync with _$CounterAsyncKeeper;

KeepAsyncKey<int> counterAsyncValue() => MemoryKeep().asyncKey('counter_async');

@kept
class _CounterAsync {
  @AtAsync(counterAsyncValue)
  KeepAsyncValue<int> value = KeepAsyncValue(0);

  Future increment() async {
    await value.set(await value.get() + 1);
  }
}
```
