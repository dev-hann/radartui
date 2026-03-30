import '../../../radartui.dart';

class Icon extends StatelessWidget {
  const Icon({super.key, required this.icon, this.color});

  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(icon, style: TextStyle(color: color));
  }
}

class Icons {
  static const String arrowUp = '↑';
  static const String arrowDown = '↓';
  static const String arrowLeft = '←';
  static const String arrowRight = '→';

  static const String check = '✓';
  static const String cross = '✗';
  static const String plus = '+';
  static const String minus = '-';

  static const String folder = '📁';
  static const String file = '📄';

  static const String menu = '☰';
  static const String search = '🔍';
  static const String settings = '⚙';

  static const String info = 'ℹ';
  static const String warning = '⚠';
  static const String error = '✕';

  static const String arrowUpAscii = '^';
  static const String arrowDownAscii = 'v';
  static const String arrowLeftAscii = '<';
  static const String arrowRightAscii = '>';
  static const String checkAscii = '*';
  static const String crossAscii = 'x';
}
