# vector_graphics_generator

This package provides a tool to generate vector graphics from svg files and creates a dart file with the vector graphics locations.

For example if you have the following structure:

```bash
- assets
  - images
    - subfolder
      - squares.svg
    - flutter.svg
  - different_folder
    - green_rectangle.svg
```

And the following annotation:
```dart 
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
```

The generator will create .vec files for each svg and create a dart file with the following content:
```dart
class VectorGraphicsAssets {
  static const greenRectangle = 'assets/different_folder/green_rectangle.vec';

  static const squares = 'assets/images/subfolder/squares.vec';

  static const flutter = 'assets/images/flutter.vec';
}
```
