import 'package:code_builder/code_builder.dart';
import 'package:vector_graphics_generator/src/util/case_utils.dart';

class AssetsGenerator {
  AssetsGenerator({
    required this.assets,
  });

  final Map<String, String> assets;

  Library generate() {
    return Library(
      (LibraryBuilder b) => b
        ..body.addAll(
          <Spec>[
            Class(
              (ClassBuilder b) => b
                ..name = 'VectorGraphicsAssets'
                ..fields.addAll(
                  assets.entries.map(
                    (MapEntry<String, String> entry) => Field(
                      (FieldBuilder b) => b
                        ..name = CaseUtil(entry.key).camelCase
                        ..static = true
                        ..modifier = FieldModifier.constant
                        ..assignment = literalString(entry.value).code,
                    ),
                  ),
                ),
            ),
          ],
        ),
    );
  }
}
