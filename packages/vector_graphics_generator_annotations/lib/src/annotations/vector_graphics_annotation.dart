/// An annotation that can be used to generate a
/// VectorGraphicsAssets class which contains the
/// vector_graphics files converted from the svg
/// files and/or folders specified in the [svgSources]
class VectorGraphics {
  /// Creates a VectorGraphics annotation.
  const VectorGraphics({
    required this.svgSources,
  });

  /// The files and/or folders to be converted and
  /// added to the VectorGraphicsAssets class.
  final List<VectorGraphicsSource> svgSources;
}

/// A class that contains the information about
/// the svg file and/or folders to be converted
class VectorGraphicsSource {
  /// A class that contains the information about
  /// the svg file and/or folders to be converted
  const VectorGraphicsSource({
    this.currentColor = '0xFF000000',
    this.fontSize = 14,
    this.optimizeMasks = true,
    this.optimizeClips = true,
    this.optimizeOverdraw = true,
    this.concurrency,
    this.xHeight,
    this.inputDir,
    this.input,
    this.output,
    this.tessellate = false,
    this.libpathops,
    this.libtessellator,
    this.dumpDebug = false,
  }) : assert(
          (inputDir == null && input != null) || (inputDir != null && input == null && output == null),
          'One of inputDir or input/output must be specified.',
        );

  /// The value (in ARGB format or a named SVG color) of the
  /// "currentColor" attribute, defaults to 0xFF000000 (black).
  final String currentColor;

  /// The basis for font size based values (i.e. em, ex). Defaults to 14.
  final double fontSize;

  /// The x-height or corpus size of the font. If unspecified, defaults
  /// to half of font-size.
  final double? xHeight;

  /// Allows for masking optimizer to be enabled or disabled
  final bool optimizeMasks;

  /// Allows for clipping optimizer to be enabled or disabled
  final bool optimizeClips;

  /// Allows for overdraw optimizer to be enabled or disabled
  final bool optimizeOverdraw;

  /// The path to a directory containing one or more SVGs.
  /// Only includes files that end with .svg.
  /// Cannot be combined with --input or --output.
  final String? inputDir;

  /// The path to a file containing a single SVG
  final String? input;

  /// The path to a file where the resulting vector_graphic will be written.
  /// If not provided, defaults to <input-file>.vec
  final String? output;

  /// The maximum number of SVG processing isolates to spawn at once.
  /// If not provided, defaults to the number of cores.
  final int? concurrency;

  /// The path to a libpathops dynamic library.
  final String? libpathops;

  /// The path to a libtessellator dynamic library.
  final String? libtessellator;

  /// Convert path fills into a tessellated shape. This will improve
  /// raster times at the cost of slightly larger file sizes.
  final bool tessellate;

  /// Dump a human readable debugging format alongside the compiled asset
  final bool dumpDebug;

  @override
  String toString() {
    return 'VectorGraphicsSource(currentColor: $currentColor, fontSize: $fontSize, xHeight: $xHeight, optimizeMasks: $optimizeMasks, optimizeClips: $optimizeClips, optimizeOverdraw: $optimizeOverdraw, inputDir: $inputDir, input: $input, output: $output, concurrency: $concurrency, libpathops: $libpathops, libtessellator: $libtessellator, tessellate: $tessellate, dumpDebug: $dumpDebug)';
  }
}
