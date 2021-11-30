import 'package:keeper/keeper.dart';
import 'package:keeper/src/keep_async_value.dart';
import 'package:test/test.dart';

void main() {
  test('default async value returns the value', () {
    KeepAsyncValue value = KeepAsyncValue('Hello world!');
    expect(value.get(), completion('Hello world!'));
  });

  test('default async value returns the value', () {
    KeepAsyncValue value = KeepAsyncValue('Hello world!');
    expect(value.set('test'), throwsA(isA<KeeperException>()));
    // the value remains unchanged
    expect(value.get(), completion('Hello world!'));
  });
}
