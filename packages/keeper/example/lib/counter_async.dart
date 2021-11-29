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

void main() {
  final counter = CounterAsync();
  counter
      .increment()
      .then((_) => counterAsyncValue().get())
      .then((value) => print(value));
}
