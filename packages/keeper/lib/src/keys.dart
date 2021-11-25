abstract class KeepKey<T> {
  T? get value;
  set value(T? value);
}

abstract class KeepAsyncKey<T> {
  Future<T?> get();
  Future<void> set(T? value);
}
