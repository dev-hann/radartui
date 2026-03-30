import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Icon widget', () {
    test('Icon creates with required icon', () {
      const icon = Icon(icon: '✓');
      expect(icon.icon, equals('✓'));
    });

    test('Icon creates with color', () {
      const icon = Icon(icon: '✓', color: Color.red);
      expect(icon.color, equals(Color.red));
    });

    test('Icon creates without color', () {
      const icon = Icon(icon: '✓');
      expect(icon.color, isNull);
    });

    test('Icon can have key', () {
      const key = ValueKey<String>('icon_key');
      const icon = Icon(icon: '✓', key: key);
      expect(icon.key, equals(key));
    });

    test('Icon creates with multi-character string', () {
      const icon = Icon(icon: '📁');
      expect(icon.icon, equals('📁'));
    });
  });

  group('Icons constants', () {
    test('Icons navigation arrows exist', () {
      expect(Icons.arrowUp, equals('↑'));
      expect(Icons.arrowDown, equals('↓'));
      expect(Icons.arrowLeft, equals('←'));
      expect(Icons.arrowRight, equals('→'));
    });

    test('Icons action icons exist', () {
      expect(Icons.check, equals('✓'));
      expect(Icons.cross, equals('✗'));
      expect(Icons.plus, equals('+'));
      expect(Icons.minus, equals('-'));
    });

    test('Icons file icons exist', () {
      expect(Icons.folder, equals('📁'));
      expect(Icons.file, equals('📄'));
    });

    test('Icons UI icons exist', () {
      expect(Icons.menu, equals('☰'));
      expect(Icons.search, equals('🔍'));
      expect(Icons.settings, equals('⚙'));
    });

    test('Icons status icons exist', () {
      expect(Icons.info, equals('ℹ'));
      expect(Icons.warning, equals('⚠'));
      expect(Icons.error, equals('✕'));
    });

    test('Icons ASCII alternatives exist', () {
      expect(Icons.arrowUpAscii, equals('^'));
      expect(Icons.arrowDownAscii, equals('v'));
      expect(Icons.arrowLeftAscii, equals('<'));
      expect(Icons.arrowRightAscii, equals('>'));
      expect(Icons.checkAscii, equals('*'));
      expect(Icons.crossAscii, equals('x'));
    });
  });
}
