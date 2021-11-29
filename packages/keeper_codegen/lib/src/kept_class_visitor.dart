import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:collection/collection.dart';
import 'package:keeper/keeper.dart';
import 'package:keeper_codegen/src/extensions/elements_extensions.dart';
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
    final fieldLibrary = keptField.field.library;

    String? firstKeyName;
    String? firstValueCast;
    keptField.atAnnotations.forEachIndexed((index, annotation) {
      final keepKeyName = '_\$${fieldName}KeepKey\$$index';
      firstKeyName = firstKeyName ?? keepKeyName;
      keysBuffer.writeln('KeepKey? $keepKeyName;');
      final function = _ensureKeyFunction(annotation);
      final functionName = function.getFullNameInLib(fieldLibrary);
      keysInitBuffer.writeln('$keepKeyName = ${functionName}();');
      keysSetBuffer.writeln('$keepKeyName!.value = value;');
    });
    keptField.atAsyncAnnotations.forEachIndexed((index, annotation) {
      final keepKeyName = '_\$${fieldName}KeepAsyncKey\$$index';
      firstKeyName = firstKeyName ?? keepKeyName;
      firstValueCast = firstValueCast ?? ' as $typeName';
      keysBuffer.writeln('KeepAsyncKey? $keepKeyName;');
      final function = _ensureKeyFunction(annotation);
      final functionName = function.getFullNameInLib(fieldLibrary);
      keysInitBuffer.writeln('$keepKeyName = ${functionName}();');
      keysSetBuffer
          .writeln('value.get().then((value) => $keepKeyName!.set(value));');
    });

    final checkValueNull =
        fieldIsNullable || isAsync ? '' : ' && _keyValue != null';

    final valueInit = '''
        final _keyValue = $firstKeyName!.value${firstValueCast ?? ''};
        if (_keyValue != super.$fieldName$checkValueNull) super.$fieldName = _keyValue;
    ''';

    return '''
    $keysBuffer
    
    @override
    $typeName get $fieldName {
      if ($firstKeyName == null) {
        $keysInitBuffer
        $valueInit
      }
      return super.$fieldName;
    }
  
    @override
    set $fieldName($typeName value) {
      if ($firstKeyName == null) {
        $keysInitBuffer
        ${isAsync ? valueInit : ''}
      }
      $keysSetBuffer
      ${isAsync ? '' : 'super.$fieldName = value;'}
    }
    ''';
  }

  ExecutableElement _ensureKeyFunction(DartObject annotation) {
    final function = annotation.getField('key')?.toFunctionValue();
    if (function == null)
      throw KeeperException('Parameter \'key\' must be a function.');
    return function;
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
