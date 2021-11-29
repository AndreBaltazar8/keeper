import 'package:analyzer/dart/element/nullability_suffix.dart';

extension NullabilitySuffixExtension on NullabilitySuffix {
  String get stringForTypeName => this == NullabilitySuffix.question ? '?' : '';
}
