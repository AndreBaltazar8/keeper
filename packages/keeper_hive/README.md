# Keeper Hive

[![pub package](https://img.shields.io/pub/v/keeper_hive.svg)](https://pub.dev/packages/keeper_hive)

Keeper Hive integrates [Keeper](https://pub.dev/packages/keeper) with [hive](https://pub.dev/packages/hive) allowing to save fields easily into Hive boxes.

## 📜 Features

- ✅ Load/Save from Hive boxes

## Getting started

This plugin requires having both `keeper` and `hive` installed. Take a look at the [Keeper's page](https://pub.dev/packages/keeper) for instructions on how to get started with Keeper.

The application is required to initialize `hive` in the desired path, with either `Hive.init` or `Hive.initFlutter` depending on the platform and preference.

## Usage

In `pubspec.yaml`:

```yaml
dependencies:
  keeper_hive: ^0.0.1
```

(it is also required to have the base Keeper package installed)

In your dart file:

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


## Additional information

Keeper project can be found at [https://github.com/AndreBaltazar8/keeper](https://github.com/AndreBaltazar8/keeper)

Contributions and bug reports are welcomed! Please include relevant information to help solve the bugs.

This project is licensed under The MIT License (MIT) available at [LICENSE](https://github.com/AndreBaltazar8/keeper/blob/master/LICENSE).