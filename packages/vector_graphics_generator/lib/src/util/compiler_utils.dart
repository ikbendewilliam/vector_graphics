import 'dart:io' hide ProcessResult;

import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';
import 'package:vector_graphics_generator_annotations/vector_graphics_generator_annotations.dart';

SvgTheme _parseTheme(VectorGraphicsSource source) {
  Color? currentColor = namedColors[source.currentColor];
  if (currentColor == null) {
    final int? argbValue = int.tryParse(source.currentColor);
    currentColor = Color(argbValue ?? 0xFF000000);
  }
  return SvgTheme(
    currentColor: currentColor,
    fontSize: source.fontSize,
    xHeight: source.xHeight,
  );
}

/// A function that compiles a VectorGraphicsSource to vector graphics.
Future<List<String>> compileSvgSource(VectorGraphicsSource source) async {
  final List<Pair> pairs = <Pair>[];
  if (source.inputDir != null) {
    final Directory directory = Directory(source.inputDir!);
    if (!directory.existsSync()) {
      throw Exception('input-dir ${directory.path} does not exist.');
    }
    for (final File file in directory.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.svg')) {
        continue;
      }
      final String outputPath = '${file.path.substring(0, file.path.length - 4)}.vec';
      pairs.add(Pair(file.path, outputPath));
    }
  } else {
    if (source.input == null) {
      throw Exception('One of input or inputDir must be specified. $source');
    }
    final String inputFilePath = source.input!;
    final String outputFilePath = source.output ?? '${inputFilePath.substring(0, inputFilePath.length - 4)}.vec';
    pairs.add(Pair(inputFilePath, outputFilePath));
  }

  final bool maskingOptimizerEnabled = source.optimizeMasks;
  final bool clippingOptimizerEnabled = source.optimizeClips;
  final bool overdrawOptimizerEnabled = source.optimizeOverdraw;
  final int concurrency = source.concurrency ?? Platform.numberOfProcessors;

  final IsolateProcessor processor = IsolateProcessor(
    source.libpathops,
    source.libtessellator,
    concurrency,
  );
  if (!await processor.process(
    pairs,
    theme: _parseTheme(source),
    maskingOptimizerEnabled: maskingOptimizerEnabled,
    clippingOptimizerEnabled: clippingOptimizerEnabled,
    overdrawOptimizerEnabled: overdrawOptimizerEnabled,
    tessellate: source.tessellate,
    dumpDebug: source.dumpDebug,
  )) {
    throw Exception('Failed to process SVG file(s).');
  }
  return pairs.map((Pair e) => e.outputPath).toList();
}
