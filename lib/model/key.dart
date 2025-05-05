import 'package:radartui/enum/key_type.dart';

class Key {
  Key(
    this.type,
    this.label, {
    this.ctrl = false,
    this.alt = false,
    this.shift = false,
    this.meta = false,
  });

  final KeyType type;
  final String label;

  final bool ctrl;
  final bool alt;
  final bool shift;
  final bool meta;

  @override
  String toString() =>
      'Key($type, $label, '
      'ctrl=$ctrl, alt=$alt, shift=$shift, meta=$meta)';
}
