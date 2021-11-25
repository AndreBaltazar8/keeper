library keeper_codegen;

import 'package:build/build.dart';
import 'package:keeper_codegen/src/keeper_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder getBuilder(BuilderOptions options) =>
    SharedPartBuilder([KeeperGenerator()], 'keeper_codegen');
