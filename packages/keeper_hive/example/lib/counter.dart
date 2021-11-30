import 'package:hive/hive.dart';
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

void main() {
  // Initialize Hive
  Hive.init('.keeper'); // for Flutter use Hive.initFlutter()

  final counter = Counter();
  counter
      .increment()
      .then((_) => counterAsyncValue().get())
      .then((value) => print(value));
}
