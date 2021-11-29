/// An exception that happens inside Keeper.
class KeeperException implements Exception {
  final String message;

  KeeperException(this.message);

  @override
  String toString() => 'KeeperException: $message';
}
