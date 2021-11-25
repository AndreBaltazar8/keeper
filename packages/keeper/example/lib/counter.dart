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
