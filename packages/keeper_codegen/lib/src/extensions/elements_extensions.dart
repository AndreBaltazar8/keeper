import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:keeper_codegen/src/extensions/dart_type_extensions.dart';

extension FieldElementExtension on FieldElement {
  String get typeName {
    return type.toStringTypeName(library);
  }
}

extension ExecutableElementExtension on ExecutableElement {
  String getFullNameInLib(LibraryElement library) {
    final names = <String>[];

    // Matches the elements (either the enclosing or this element)
    bool isElement(MapEntry<String, Element> element) =>
        element.value == enclosingElement || element.value == this;

    // Matches the import with the element
    bool isImportWithElement(ImportElement import) =>
        import.namespace.definedNames.entries.any(isElement);

    // Add library import prefix
    final importName = library.imports.firstWhereOrNull(isImportWithElement);
    if (importName?.prefix != null) names.add(importName!.prefix!.name);

    // Add enclosing name
    final enclosingElementName = enclosingElement.name;
    if (enclosingElementName != null) names.add(enclosingElementName);

    // Add actual name
    names.add(name);

    return '${names.join('.')}';
  }
}
