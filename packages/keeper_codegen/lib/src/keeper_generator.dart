import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:keeper/keeper.dart';
import 'package:source_gen/source_gen.dart';

const _keptAnnotationName = '@kept';

class KeeperGenerator extends GeneratorForAnnotation<MakeKept> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element.kind != ElementKind.CLASS) {
      throw 'Only classes can have $_keptAnnotationName annotation.';
    }

    final classElement = await _findMainClass(element, buildStep);
    if (classElement == null) {
      throw '''
      Can\'t generate mixin for $_keptAnnotationName.
      The annotation must be placed in the private class.
      ''';
    }

    return 'mixin _\$${classElement.name}Keeper {}';
  }

  Future<ClassElement?> _findMainClass(
      Element element, BuildStep buildStep) async {
    final classElement = element as ClassElement;
    final library = await buildStep.inputLibrary;
    final libraryReader = LibraryReader(library);
    final typeSystem = library.typeSystem;
    return libraryReader.classes.firstWhereOrNull(_isSubTypeOf(
      classElement,
      typeSystem,
    ));
  }

  bool Function(ClassElement element) _isSubTypeOf(
    ClassElement classElement,
    TypeSystem typeSystem,
  ) {
    bool isSubType(ClassElement c) {
      // Same class is not considered subtype
      if (c == classElement) return false;

      // Type parameters must match
      if (classElement.typeParameters.length !=
          c.supertype?.typeArguments.length) return false;

      // Check if is subtype with the correct type arguments
      return typeSystem.isSubtypeOf(
        c.thisType,
        classElement.instantiate(
          typeArguments: c.supertype!.typeArguments,
          nullabilitySuffix: NullabilitySuffix.none,
        ),
      );
    }

    return isSubType;
  }
}
