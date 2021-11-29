import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:keeper_codegen/src/extensions/nullability_suffix_extensions.dart';

extension DartTypeExtension on DartType {
  String toStringTypeName(LibraryElement library) {
    final typeElement = element;
    if (this is FunctionType) {
      throw 'Field type not supported for ${getDisplayString(withNullability: true)}';
    } else if (typeElement == null || this is TypeParameterType) {
      throw 'Field type not supported for ${getDisplayString(withNullability: true)}';
    }

    return _getElementTypeName(this, typeElement, library) +
        _buildStringForGenericTypes(this, library) +
        nullabilitySuffix.stringForTypeName;
  }

  static _getElementTypeName(
    DartType type,
    Element typeElement,
    LibraryElement library,
  ) {
    // Search for the element in this library
    final elementDefinition = library.topLevelElements
        .whereType<TypeDefiningElement>()
        .firstWhereOrNull((element) => element == typeElement);

    if (elementDefinition != null) return elementDefinition.name;

    // Get the name from imports
    final importName = library.imports
        .expand((import) => import.namespace.definedNames.entries)
        .firstWhereOrNull((nameEntry) => nameEntry.value == typeElement);

    if (importName != null) return importName.key;
    throw 'Cannot find type name for $typeElement';
  }

  static _buildStringForGenericTypes(
    DartType type,
    LibraryElement library,
  ) {
    List<DartType>? genericTypes;
    if (type is ParameterizedType) {
      genericTypes = type.typeArguments;
    } else if (type is FunctionType) {
      genericTypes = type.alias?.typeArguments;
    }

    if (genericTypes != null && genericTypes.isNotEmpty) {
      String getTypeName(DartType e) => e.toStringTypeName(library);
      return '<${genericTypes.map(getTypeName).join(',')}>';
    }

    return '';
  }
}
