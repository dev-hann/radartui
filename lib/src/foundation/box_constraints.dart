import '../rendering.dart';
import 'edge_insets.dart';
import 'size.dart';

/// Immutable layout constraints with min/max width and height.
///
/// Follows Flutter's BoxConstraints API: [BoxConstraints.tight],
/// [BoxConstraints.loose], [BoxConstraints.expand], [BoxConstraints.tightFor].
/// Use [deflate] to subtract padding, [enforce] to clamp to another constraint.
class BoxConstraints extends Constraints {
  /// Creates [BoxConstraints] with the given min/max width and height.
  const BoxConstraints({
    this.minWidth = 0,
    this.maxWidth = Constraints.infinity,
    this.minHeight = 0,
    this.maxHeight = Constraints.infinity,
  });

  /// Creates tight constraints that force the given exact [size].
  BoxConstraints.tight(Size size)
      : minWidth = size.width,
        maxWidth = size.width,
        minHeight = size.height,
        maxHeight = size.height;

  /// Creates loose constraints that allow sizes from zero up to the given [size].
  BoxConstraints.loose(Size size)
      : minWidth = 0,
        maxWidth = size.width,
        minHeight = 0,
        maxHeight = size.height;

  /// Creates constraints that force expansion to fill available space.
  ///
  /// If [width] or [height] is null, that dimension is unconstrained.
  const BoxConstraints.expand({int? width, int? height})
      : minWidth = width ?? Constraints.infinity,
        maxWidth = width ?? Constraints.infinity,
        minHeight = height ?? Constraints.infinity,
        maxHeight = height ?? Constraints.infinity;

  /// Creates constraints that are tight for the given dimensions.
  ///
  /// If [width] or [height] is null, that dimension is unconstrained (0 to infinity).
  const BoxConstraints.tightFor({int? width, int? height})
      : minWidth = width ?? 0,
        maxWidth = width ?? Constraints.infinity,
        minHeight = height ?? 0,
        maxHeight = height ?? Constraints.infinity;

  /// The minimum width constraint.
  final int minWidth;

  /// The maximum width constraint.
  final int maxWidth;

  /// The minimum height constraint.
  final int minHeight;

  /// The maximum height constraint.
  final int maxHeight;

  /// Whether these constraints force an exact size in both dimensions.
  bool get isTight => minWidth == maxWidth && minHeight == maxHeight;

  /// Whether these constraints satisfy the invariant: 0 <= min <= max.
  bool get isNormalized =>
      minWidth >= 0.0 &&
      minWidth <= maxWidth &&
      minHeight >= 0.0 &&
      minHeight <= maxHeight;

  /// Returns new constraints with the minimum width and height set to zero.
  BoxConstraints loosen() {
    return BoxConstraints(
      minWidth: 0,
      maxWidth: maxWidth,
      minHeight: 0,
      maxHeight: maxHeight,
    );
  }

  /// Returns new constraints that are clamped within the given [constraints].
  BoxConstraints enforce(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: minWidth.clamp(constraints.minWidth, constraints.maxWidth),
      maxWidth: maxWidth.clamp(constraints.minWidth, constraints.maxWidth),
      minHeight: minHeight.clamp(constraints.minHeight, constraints.maxHeight),
      maxHeight: maxHeight.clamp(constraints.minHeight, constraints.maxHeight),
    );
  }

  /// Returns a [Size] that satisfies these constraints given the proposed [size].
  Size constrain(Size size) {
    final safeMaxWidth = maxWidth.clamp(0, Constraints.infinity);
    final safeMaxHeight = maxHeight.clamp(0, Constraints.infinity);
    final safeMinWidth = minWidth.clamp(0, safeMaxWidth);
    final safeMinHeight = minHeight.clamp(0, safeMaxHeight);

    final constrainedWidth = size.width.clamp(safeMinWidth, safeMaxWidth);
    final constrainedHeight = size.height.clamp(safeMinHeight, safeMaxHeight);
    return Size(constrainedWidth, constrainedHeight);
  }

  /// Returns new constraints reduced by the given [edge] insets (e.g. padding).
  BoxConstraints deflate(EdgeInsets edge) {
    final horizontal = edge.horizontal;
    final vertical = edge.vertical;

    final deflatedMaxWidth = (maxWidth - horizontal).clamp(
      0,
      Constraints.infinity,
    );
    final deflatedMaxHeight = (maxHeight - vertical).clamp(
      0,
      Constraints.infinity,
    );
    final deflatedMinWidth = (minWidth - horizontal).clamp(
      0,
      Constraints.infinity,
    );
    final deflatedMinHeight = (minHeight - vertical).clamp(
      0,
      Constraints.infinity,
    );

    return BoxConstraints(
      minWidth: deflatedMinWidth.clamp(0, deflatedMaxWidth),
      maxWidth: deflatedMaxWidth,
      minHeight: deflatedMinHeight.clamp(0, deflatedMaxHeight),
      maxHeight: deflatedMaxHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoxConstraints &&
        minWidth == other.minWidth &&
        maxWidth == other.maxWidth &&
        minHeight == other.minHeight &&
        maxHeight == other.maxHeight;
  }

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, minHeight, maxHeight);

  @override
  String toString() =>
      'BoxConstraints(w: $minWidth-$maxWidth, h: $minHeight-$maxHeight)';
}
