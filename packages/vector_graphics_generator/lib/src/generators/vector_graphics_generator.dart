import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:vector_graphics_generator/src/code_builder/assets_generator.dart';
import 'package:vector_graphics_generator/src/util/compiler_utils.dart';
import 'package:vector_graphics_generator_annotations/vector_graphics_generator_annotations.dart';

class VectorGraphicsGenerator extends GeneratorForAnnotation<VectorGraphics> {
  const VectorGraphicsGenerator();

  @override
  dynamic generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    final List<VectorGraphicsSource> svgSources = (annotation.peek('svgSources')?.listValue ?? <DartObject>[])
        .map((DartObject source) => VectorGraphicsSource(
              currentColor: source.getField('currentColor')?.toStringValue() ?? '0xFF000000',
              fontSize: source.getField('fontSize')?.toDoubleValue() ?? 14,
              optimizeMasks: source.getField('optimizeMasks')?.toBoolValue() ?? true,
              optimizeClips: source.getField('optimizeClips')?.toBoolValue() ?? true,
              optimizeOverdraw: source.getField('optimizeOverdraw')?.toBoolValue() ?? true,
              concurrency: source.getField('concurrency')?.toIntValue(),
              xHeight: source.getField('xHeight')?.toDoubleValue(),
              inputDir: source.getField('inputDir')?.toStringValue(),
              input: source.getField('input')?.toStringValue(),
              output: source.getField('output')?.toStringValue(),
              tessellate: source.getField('tessellate')?.toBoolValue() ?? false,
              libpathops: source.getField('libpathops')?.toStringValue(),
              libtessellator: source.getField('libtessellator')?.toStringValue(),
              dumpDebug: source.getField('dumpDebug')?.toBoolValue() ?? false,
            ))
        .toList();
    final Map<String, String> assets = <String, String>{};
    for (final VectorGraphicsSource source in svgSources) {
      final List<String> generatedFiles = await compileSvgSource(source);
      for (final String generatedFile in generatedFiles) {
        final String assetKey = generatedFile.substring(generatedFile.lastIndexOf('/') + 1, generatedFile.lastIndexOf('.'));
        assets[assetKey] = generatedFile;
      }
    }

    final AssetsGenerator generator = AssetsGenerator(
      assets: assets,
    );

    final Library generatedClass = generator.generate();

    final DartEmitter emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      orderDirectives: true,
    );

    return DartFormatter().format(generatedClass.accept(emitter).toString());
  }
}
