import 'package:vector_graphics_generator_annotations/vector_graphics_generator_annotations.dart';

@VectorGraphics(
  svgSources: [
    VectorGraphicsSource(
      input: 'assets/different_folder/green_rectangle.svg',
    ),
    VectorGraphicsSource(
      inputDir: 'assets/images',
    ),
  ],
)
class VectorGraphicsAssets {}
