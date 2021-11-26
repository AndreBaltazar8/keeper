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
    if (atAnnotations.isEmpty) return;
    _keptFields.add(KeptField(
      field: element,
      atAnnotations: atAnnotations.toList(),
    ));
  }

  String _generateField(KeptField keptField) {
    final typeName = keptField.field.typeName;
    final fieldName = keptField.field.name;
    final fieldIsNullable =
        keptField.field.type.nullabilitySuffix == NullabilitySuffix.question;
    final keysBuffer = StringBuffer();
    final keysInitBuffer = StringBuffer();
    final keysSetBuffer = StringBuffer();
    String? firstKeyName;
    keptField.atAnnotations.forEachIndexed((index, annotation) {
      final keepKeyName = '_\$${fieldName}KeepKey\$$index';
      firstKeyName = firstKeyName ?? keepKeyName;
      keysBuffer.writeln('KeepKey? $keepKeyName;');
      final function = annotation.getField('key')?.toFunctionValue();
      // TODO: add support for function enclosing name, and import prefix
      keysInitBuffer.writeln('$keepKeyName = ${function!.displayName}();');
      keysSetBuffer.writeln('$keepKeyName!.value = value;');
    });

    return '''
    $keysBuffer
    
    @override
    $typeName get $fieldName {
      if ($firstKeyName == null) {
        $keysInitBuffer
        final _keyValue = $firstKeyName!.value;
        if (_keyValue != super.$fieldName${fieldIsNullable ? '' : ' && _keyValue != null'}) super.$fieldName = _keyValue;
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
  });

  final FieldElement field;
  final List<DartObject> atAnnotations;
}

final _atAnnotationChecker = const TypeChecker.fromRuntime(At);

extension _FieldElementExtension on FieldElement {
  String get typeName {
    final type = this.type;
    final typeElement = type.element;
    if (type is FunctionType) {
      throw 'Field type not supported for $name';
    } else if (typeElement == null || type is TypeParameterType) {
      throw 'Field type not supported for $name';
    }

    return _getElementTypeName(type, typeElement, library) +
        type.nullabilitySuffix.stringForTypeName;
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
}

extension _NullabilitySuffix on NullabilitySuffix {
  String get stringForTypeName => this == NullabilitySuffix.question ? '?' : '';
}
