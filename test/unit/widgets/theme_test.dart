import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('ThemeData', () {
    test('ThemeData creates with default values', () {
      const themeData = ThemeData();
      expect(themeData.primaryColor, equals(Colors.blue));
      expect(themeData.backgroundColor, equals(Colors.black));
      expect(themeData.textColor, equals(Colors.white));
      expect(themeData.selectedColor, equals(Colors.blue));
      expect(themeData.borderColor, equals(Colors.white));
      expect(themeData.dividerColor, equals(Colors.white));
    });

    test('ThemeData creates with custom values', () {
      const themeData = ThemeData(
        primaryColor: Colors.red,
        backgroundColor: Colors.green,
        textColor: Colors.yellow,
        selectedColor: Colors.cyan,
        borderColor: Colors.magenta,
        dividerColor: Colors.white,
      );
      expect(themeData.primaryColor, equals(Colors.red));
      expect(themeData.backgroundColor, equals(Colors.green));
      expect(themeData.textColor, equals(Colors.yellow));
      expect(themeData.selectedColor, equals(Colors.cyan));
      expect(themeData.borderColor, equals(Colors.magenta));
      expect(themeData.dividerColor, equals(Colors.white));
    });

    test('ThemeData.dark returns dark theme', () {
      final theme = ThemeData.dark;
      expect(theme.backgroundColor, equals(Colors.black));
      expect(theme.textColor, equals(Colors.white));
      expect(theme.primaryColor, equals(Colors.blue));
    });

    test('ThemeData.light returns light theme', () {
      final theme = ThemeData.light;
      expect(theme.backgroundColor, equals(Colors.white));
      expect(theme.textColor, equals(Colors.black));
      expect(theme.primaryColor, equals(Colors.blue));
    });

    test('ThemeData equality', () {
      const theme1 = ThemeData();
      const theme2 = ThemeData();
      expect(theme1, equals(theme2));
      expect(theme1.hashCode, equals(theme2.hashCode));
    });

    test('ThemeData inequality with different values', () {
      const theme1 = ThemeData();
      const theme2 = ThemeData(primaryColor: Colors.red);
      expect(theme1 == theme2, isFalse);
    });

    test('ThemeData copyWith overrides specified fields', () {
      const themeData = ThemeData();
      final copied = themeData.copyWith(primaryColor: Colors.red);
      expect(copied.primaryColor, equals(Colors.red));
      expect(copied.backgroundColor, equals(Colors.black));
      expect(copied.textColor, equals(Colors.white));
    });

    test('ThemeData copyWith preserves all when no args', () {
      const themeData = ThemeData();
      final copied = themeData.copyWith();
      expect(copied, equals(themeData));
    });

    test('ThemeData toString', () {
      const themeData = ThemeData();
      final str = themeData.toString();
      expect(str, contains('ThemeData'));
      expect(str, contains('primaryColor'));
    });
  });

  group('Theme', () {
    test('Theme creates with data and child', () {
      final theme = Theme(
        data: ThemeData.dark,
        child: const Text('test'),
      );
      expect(theme.data, equals(ThemeData.dark));
      expect(theme.child, isA<Text>());
    });

    test('Theme updateShouldNotify returns true when data changes', () {
      final oldWidget = Theme(
        data: ThemeData.dark,
        child: const Text('a'),
      );
      final newWidget = Theme(
        data: ThemeData.light,
        child: const Text('b'),
      );
      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    test('Theme updateShouldNotify returns false when data is same', () {
      final oldWidget = Theme(
        data: ThemeData.dark,
        child: const Text('a'),
      );
      final newWidget = Theme(
        data: ThemeData.dark,
        child: const Text('b'),
      );
      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });

    test('Theme is an InheritedWidget', () {
      final theme = Theme(
        data: ThemeData.dark,
        child: const Text('test'),
      );
      expect(theme, isA<InheritedWidget>());
    });
  });
}
