import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:collection/collection.dart';
import 'package:keeper/keeper.dart';
import 'package:source_gen/source_gen.dart';

class KeptClassVisitor extends SimpleElementVisitor {
  KeptClassVisitor(
    this.privateName,
    this.publicName,
  );

  final String privateName;
  final String publicName;
  final List<KeptField> _keptFields = [];

  @override
  void visitClassElement(ClassElement element) {
    element.visitChildren(this);
  }

  @override
  void visitFieldElement(FieldElement element) {
    final atAnnotations = _atAnnotationChecker.annotationsOf(element);
    final atAsyncAnnotations = _atAsyncAnnotationChecker.annotationsOf(element);
    if (atAnnotations.isEmpty && atAsyncAnnotations.isEmpty) return;
    _keptFields.add(KeptField(
      field: element,
      atAnnotations: atAnnotations.toList(),
      atAsyncAnnotations: atAsyncAnnotations.toList(),
    ));
  }

  String _generateField(KeptField keptField) {
    final isAsync = keptField.atAsyncAnnotations.isNotEmpty;
    final typeName = keptField.field.typeName;
    final fieldName = keptField.field.name;
    final fieldIsNullable =
        keptField.field.type.nullabilitySuffix == NullabilitySuffix.question;

    final keysBuffer = StringBuffer();
    final keysInitBuffer = StringBuffer();
    final keysSetBuffer = StringBuffer();

    String? firstKeyName;
    String? firstValueCast;
    keptField.atAnnotations.forEachIndexed((index, annotation) {
      final keepKeyName = '_\$${fieldName}KeepKey\$$index';
      firstKeyName = firstKeyName ?? keepKeyName;
      keysBuffer.writeln('KeepKey? $keepKeyName;');
      final function = annotation.getField('key')?.toFunctionValue();
      // TODO: add support for function enclosing name, and import prefix
      keysInitBuffer.writeln('$keepKeyName = ${function!.displayName}();');
      keysSetBuffer.writeln('$keepKeyName!.value = value;');
    });
    keptField.atAsyncAnnotations.forEachIndexed((index, annotation) {
      final keepKeyName = '_\$${fieldName}KeepAsyncKey\$$index';
      firstKeyName = firstKeyName ?? keepKeyName;
      firstValueCast = firstValueCast ?? ' as $typeName';
      keysBuffer.writeln('KeepAsyncKey? $keepKeyName;');
      final function = annotation.getField('key')?.toFunctionValue();
      keysInitBuffer.writeln('$keepKeyName = ${function!.displayName}();');
      keysSetBuffer
          .writeln('value.get().then((value) => $keepKeyName!.set(value));');
    });

    final checkValueNull =
        fieldIsNullable || isAsync ? '' : ' && _keyValue != null';
    return '''
    $keysBuffer
    
    @override
    $typeName get $fieldName {
      if ($firstKeyName == null) {
        $keysInitBuffer
        final _keyValue = $firstKeyName!.value${firstValueCast ?? ''};
        if (_keyValue != super.$fieldName$checkValueNull) super.$fieldName = _keyValue;
      }
      return super.$fieldName;
    }
  
    @override
    set $fieldName($typeName value) {
      if ($firstKeyName == null) {
        $keysInitBuffer
      }
      $keysSetBuffer
      super.$fieldName = value;
    }
    ''';
  }

  String generateSource() {
    final buffer = StringBuffer();
    final genClassName = '_\$${publicName}Keeper';
    buffer.writeln('mixin $genClassName on $privateName {');
    for (var keptField in _keptFields) {
      buffer.writeln(_generateField(keptField));
    }
    buffer.writeln('}');
    return buffer.toString();
  }
}

class KeptField {
  KeptField({
    required this.field,
    required this.atAnnotations,
    required this.atAsyncAnnotations,
  });

  final FieldElement field;
  final List<DartObject> atAnnotations;
  final List<DartObject> atAsyncAnnotations;
}

final _atAnnotationChecker = const TypeChecker.fromRuntime(At);
final _atAsyncAnnotationChecker = const TypeChecker.fromRuntime(AtAsync);

extension _FieldElementExtension on FieldElement {
  String get typeName {
    return type.toStringTypeName(library);
  }
}

extension _DartTypeExtension on DartType {
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

extension _NullabilitySuffix on NullabilitySuffix {
  String get stringForTypeName => this == NullabilitySuffix.question ? '?' : '';
}
