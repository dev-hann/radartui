import '../rendering.dart';
import 'edge_insets.dart';
import 'size.dart';

/// Immutable layout constraints with min/max width and height.
///
/// Follows Flutter's BoxConstraints API: [BoxConstraints.tight],
/// [BoxConstraints.loose], [BoxConstraints.expand], [BoxConstraints.tightFor].
/// Use [deflate] to subtract padding, [enforce] to clamp to another constraint.
class BoxConstraints extends Constraints {
  const BoxConstraints({
    this.minWidth = 0,
    this.maxWidth = Constraints.infinity,
    this.minHeight = 0,
    this.maxHeight = Constraints.infinity,
  });

  BoxConstraints.tight(Size size)
      : minWidth = size.width,
        maxWidth = size.width,
        minHeight = size.height,
        maxHeight = size.height;

  BoxConstraints.loose(Size size)
      : minWidth = 0,
        maxWidth = size.width,
        minHeight = 0,
        maxHeight = size.height;

  const BoxConstraints.expand({int? width, int? height})
      : minWidth = width ?? Constraints.infinity,
        maxWidth = width ?? Constraints.infinity,
        minHeight = height ?? Constraints.infinity,
        maxHeight = height ?? Constraints.infinity;

  const BoxConstraints.tightFor({int? width, int? height})
      : minWidth = width ?? 0,
        maxWidth = width ?? Constraints.infinity,
        minHeight = height ?? 0,
        maxHeight = height ?? Constraints.infinity;
  final int minWidth;
  final int maxWidth;
  final int minHeight;
  final int maxHeight;

  bool get isTight => minWidth == maxWidth && minHeight == maxHeight;

  bool get isNormalized =>
      minWidth >= 0.0 &&
      minWidth <= maxWidth &&
      minHeight >= 0.0 &&
      minHeight <= maxHeight;

  BoxConstraints loosen() {
    return BoxConstraints(
      minWidth: 0,
      maxWidth: maxWidth,
      minHeight: 0,
      maxHeight: maxHeight,
    );
  }

  BoxConstraints enforce(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: minWidth.clamp(constraints.minWidth, constraints.maxWidth),
      maxWidth: maxWidth.clamp(constraints.minWidth, constraints.maxWidth),
      minHeight: minHeight.clamp(constraints.minHeight, constraints.maxHeight),
      maxHeight: maxHeight.clamp(constraints.minHeight, constraints.maxHeight),
    );
  }

  Size constrain(Size size) {
    final safeMaxWidth = maxWidth.clamp(0, Constraints.infinity);
    final safeMaxHeight = maxHeight.clamp(0, Constraints.infinity);
    final safeMinWidth = minWidth.clamp(0, safeMaxWidth);
    final safeMinHeight = minHeight.clamp(0, safeMaxHeight);

    final constrainedWidth = size.width.clamp(safeMinWidth, safeMaxWidth);
    final constrainedHeight = size.height.clamp(safeMinHeight, safeMaxHeight);
    return Size(constrainedWidth, constrainedHeight);
  }

  BoxConstraints deflate(EdgeInsets edge) {
    final horizontal = edge.left + edge.right;
    final vertical = edge.top + edge.bottom;

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
  bool operator ==(Object other) =>
      other is BoxConstraints &&
      minWidth == other.minWidth &&
      maxWidth == other.maxWidth &&
      minHeight == other.minHeight &&
      maxHeight == other.maxHeight;

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, minHeight, maxHeight);

  @override
  String toString() =>
      'BoxConstraints(w: $minWidth-$maxWidth, h: $minHeight-$maxHeight)';
}
