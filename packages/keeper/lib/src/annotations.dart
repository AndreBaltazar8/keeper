import 'package:keeper/src/keys.dart';

/// Declares that a class contains keys that should be kept.
class MakeKept {
  const MakeKept._();
}

/// Declares that a class contains keys that should be kept.
const kept = MakeKept._();

/// Declares a class field as kept at [key]. For sync storage.
///
/// For async storage use [AtAsync].
class At {
  /// A function that provides the key to be used for storage.
  final KeepKey Function() key;

  /// Declares a class field as kept at [key]. For sync storage.
  ///
  /// For async storage use [AtAsync].
  const At(this.key);
}

/// Declares a class field as kept at [key]. For async storage.
///
/// For sync storage use [At].
class AtAsync {
  /// A function that provides the key to be used for async storage.
  final KeepAsyncKey Function() key;

  /// Declares a class field as kept at [key]. For async storage.
  ///
  /// For sync storage use [At].
  const AtAsync(this.key);
}
