import 'package:radartui/enum/key_type.dart';

class Key {
  Key(this.type, this.label);
  final KeyType type;
  final String label;
  @override
  String toString() => 'Key($type, $label)';
}
