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

void main() {
  final counter = Counter();
  print(counterValue().value); // prints null
  counter.increment();
  print(counterValue().value); // prints 1
  counter.increment();
  print(counterValue().value); // prints 2
  final counter2 = Counter();
  counter2.increment();
  print(counterValue().value); // prints 3
  counter2.increment();
  print(counterValue().value); // prints 4
}
