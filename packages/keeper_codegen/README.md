# Keeper Codegen

The Keeper Codegen is the package that provides the code generation for [Keeper](https://pub.dev/packages/keeper).

## Features

- ✅ Support for common classes
- ❌ MobX store support

## Getting started

This package is used with Keeper to provide an easy setup for storing class fields in different storage containers.

It is important to have you project setup to use Keeper, and then running the command below to generate the files that will perform all the magic. ✨

## Usage

In `pubspec.yaml`:

```yaml
dev_dependencies:
  build_runner: ^2.1.5 # check for recent version on pub.dev
  keeper_codegen: ^0.0.1
```

To generate the `.g.dart` files for your classes run:

```bash
flutter pub run build_runner build
```

## Additional information

Keeper project can be found at [https://github.com/AndreBaltazar8/keeper](https://github.com/AndreBaltazar8/keeper)

Contributions and bug reports are welcomed! Please include relevant information to help solve the bugs.

This project is licensed under The MIT License (MIT) available at [LICENSE](https://github.com/AndreBaltazar8/keeper/blob/master/packages/keeper_codegen/LICENSE).
