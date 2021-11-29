import 'package:keeper/src/keys.dart';

/// Declares that a class contains keys that should be kept.
class MakeKept {
  const MakeKept._();
}

const kept = MakeKept._();

/// Declares a class field as kept at [key]. For sync storage.
///
/// For async storage use [AtAsync].
class At {
  final KeepKey Function() key;
  const At(this.key);
}

/// Declares a class field as kept at [key]. For async storage.
///
/// For sync storage use [At].
class AtAsync {
  final KeepAsyncKey Function() key;
  const AtAsync(this.key);
}
