import 'package:radartui/canvas/color.dart';

class Style {
  const Style({
    this.bold = false,
    this.faint = false,
    this.italic = false,
    this.underLine = false,
    this.blink = false,
    this.inverted = false,
    this.invisible = false,
    this.strikethru = false,
    this.foreground = const Color.white(),
    this.background = const Color.black(),
  });
  final bool bold;
  final bool faint;
  final bool italic;
  final bool underLine;
  final bool blink;
  final bool inverted;
  final bool invisible;
  final bool strikethru;
  final Color foreground;
  final Color background;

  String toPrompt() {
    final styles = <int>[];
    if (bold) styles.add(1);
    if (faint) styles.add(2);
    if (italic) styles.add(3);
    if (underLine) styles.add(4);
    if (blink) styles.add(5);
    if (inverted) styles.add(7);
    if (invisible) styles.add(8);
    if (strikethru) styles.add(9);
    return '\x1b[${styles.join(";")}m';
  }
}
