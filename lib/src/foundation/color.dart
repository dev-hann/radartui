class Color {
  final int value;
  const Color(this.value);
  
  // Basic colors
  static const Color black = Color(0);
  static const Color red = Color(1);
  static const Color green = Color(2);
  static const Color yellow = Color(3);
  static const Color blue = Color(4);
  static const Color magenta = Color(5);
  static const Color cyan = Color(6);
  static const Color white = Color(7);
  
  // Bright colors
  static const Color brightBlack = Color(8);
  static const Color brightRed = Color(9);
  static const Color brightGreen = Color(10);
  static const Color brightYellow = Color(11);
  static const Color brightBlue = Color(12);
  static const Color brightMagenta = Color(13);
  static const Color brightCyan = Color(14);
  static const Color brightWhite = Color(15);
  
  // Special colors
  static const Color transparent = Color(-1);
  
  @override
  String toString() => 'Color($value)';
}

class TextStyle {
  final Color? color;
  final Color? backgroundColor;
  final bool bold;
  final bool italic;
  final bool underline;
  
  const TextStyle({
    this.color,
    this.backgroundColor,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });
  
  @override
  bool operator ==(Object other) =>
      other is TextStyle &&
      color == other.color &&
      backgroundColor == other.backgroundColor &&
      bold == other.bold &&
      italic == other.italic &&
      underline == other.underline;

  @override
  int get hashCode => Object.hash(
    color, 
    backgroundColor, 
    bold, 
    italic, 
    underline
  );
  
  @override
  String toString() => 'TextStyle(color: $color, bg: $backgroundColor, bold: $bold)';
}