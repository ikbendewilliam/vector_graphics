import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:vector_graphics_generator/src/generators/vector_graphics_generator.dart';

/// A builder that generates a json file for one or more routes.
Builder vectorGraphicsBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const VectorGraphicsGenerator(),
    generatedExtension: '.vector_graphics_assets.dart',
    additionalOutputExtensions: <String>['.vec'],
  );
}
