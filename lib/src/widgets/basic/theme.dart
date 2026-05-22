import '../../../radartui.dart';

/// Describes the visual appearance of the application.
///
/// Contains color and style tokens that [Theme] widgets distribute to
/// descendants via [Theme.of].
class ThemeData {
  /// Creates a [ThemeData] with customizable color tokens.
  const ThemeData({
    this.primaryColor = Color.blue,
    this.backgroundColor = Color.black,
    this.textColor = Color.white,
    this.selectedColor = Color.blue,
    this.borderColor = Color.white,
    this.dividerColor = Color.white,
  });

  /// The primary accent color used for interactive elements.
  final Color primaryColor;

  /// The default background color.
  final Color backgroundColor;

  /// The default text color.
  final Color textColor;

  /// The color applied to selected items.
  final Color selectedColor;

  /// The color used for borders.
  final Color borderColor;

  /// The color used for dividers.
  final Color dividerColor;

  /// A pre-built dark theme.
  static ThemeData get dark => const ThemeData(
        primaryColor: Color.blue,
        backgroundColor: Color.black,
        textColor: Color.white,
        selectedColor: Color.blue,
        borderColor: Color.white,
        dividerColor: Color.white,
      );

  /// A pre-built light theme.
  static ThemeData get light => const ThemeData(
        primaryColor: Color.blue,
        backgroundColor: Color.white,
        textColor: Color.black,
        selectedColor: Color.blue,
        borderColor: Color.black,
        dividerColor: Color.black,
      );

  /// Creates a copy of this theme with the given fields replaced.
  ThemeData copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
    Color? selectedColor,
    Color? borderColor,
    Color? dividerColor,
  }) {
    return ThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      selectedColor: selectedColor ?? this.selectedColor,
      borderColor: borderColor ?? this.borderColor,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeData &&
          runtimeType == other.runtimeType &&
          primaryColor == other.primaryColor &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor &&
          selectedColor == other.selectedColor &&
          borderColor == other.borderColor &&
          dividerColor == other.dividerColor;

  @override
  int get hashCode => Object.hash(
        primaryColor,
        backgroundColor,
        textColor,
        selectedColor,
        borderColor,
        dividerColor,
      );

  @override
  String toString() =>
      'ThemeData(primaryColor: $primaryColor, backgroundColor: $backgroundColor, textColor: $textColor)';
}

/// An inherited widget that provides [ThemeData] to descendant widgets.
///
/// Retrieve the current theme with [Theme.of].
class Theme extends InheritedWidget {
  /// Creates a [Theme] widget that provides [data] to its subtree.
  const Theme({super.key, required this.data, required super.child});

  /// The theme data provided to descendants.
  final ThemeData data;

  /// Retrieves the nearest [ThemeData] from the widget tree, defaulting to dark.
  static ThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<Theme>();
    if (widget != null) {
      return widget.data;
    }
    return ThemeData.dark;
  }

  /// Retrieves the nearest [ThemeData], or `null` if none is found.
  static ThemeData maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<Theme>();
    return widget?.data ?? ThemeData.dark;
  }

  @override
  bool updateShouldNotify(Theme oldWidget) => data != oldWidget.data;
}
