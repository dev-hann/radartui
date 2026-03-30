import '../../../radartui.dart';

class ThemeData {
  const ThemeData({
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.selectedColor = Colors.blue,
    this.borderColor = Colors.white,
    this.dividerColor = Colors.white,
  });
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Color selectedColor;
  final Color borderColor;
  final Color dividerColor;

  static ThemeData get dark => const ThemeData(
        primaryColor: Colors.blue,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        selectedColor: Colors.blue,
        borderColor: Colors.white,
        dividerColor: Colors.white,
      );

  static ThemeData get light => const ThemeData(
        primaryColor: Colors.blue,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        selectedColor: Colors.blue,
        borderColor: Colors.black,
        dividerColor: Colors.black,
      );

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

class Theme extends InheritedWidget {
  const Theme({
    super.key,
    required this.data,
    required super.child,
  });
  final ThemeData data;

  static ThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<Theme>();
    if (widget != null) {
      return widget.data;
    }
    return ThemeData.dark;
  }

  static ThemeData maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<Theme>();
    return widget?.data ?? ThemeData.dark;
  }

  @override
  bool updateShouldNotify(Theme oldWidget) => data != oldWidget.data;
}
