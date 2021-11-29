import 'package:keeper/src/keys.dart';

/// Base class for a Keep that stores data synchonously.
abstract class Keep {
  const Keep._();

  /// Returns a key in the keep.
  KeepKey<T> key<T>(String key);
}

/// Base class for a Keep that stores data asynchonously.
abstract class AsyncKeep {
  const AsyncKeep._();

  /// Returns an async key in the keep.
  KeepAsyncKey<T> asyncKey<T>(String key);
}
