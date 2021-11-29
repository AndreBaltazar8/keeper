import 'package:analyzer/dart/element/element.dart';
import 'package:keeper_codegen/src/extensions/dart_type_extensions.dart';

extension FieldElementExtension on FieldElement {
  String get typeName {
    return type.toStringTypeName(library);
  }
}

extension ExecutableElementExtension on ExecutableElement {
  String get fullName {
    // TODO: add support for function enclosing name, and import prefix
    return name;
  }
}
