import 'package:flutter_test/flutter_test.dart';
import 'package:keeper/src/keep_async_value.dart';

void main() {
  test('default async value returns the value', () {
    KeepAsyncValue value = KeepAsyncValue('Hello world!');
    expect(value.get(), completion('Hello world!'));
  });

  test('default async value returns the value', () {
    KeepAsyncValue value = KeepAsyncValue('Hello world!');
    expect(value.set('test'), throwsA(isA<Error>()));
    // the value remains unchanged
    expect(value.get(), completion('Hello world!'));
  });
}
