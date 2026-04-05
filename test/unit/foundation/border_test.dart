import 'package:radartui/src/foundation/border.dart';
import 'package:test/test.dart';

void main() {
  group('Border', () {
    test('Border.all creates border with default characters', () {
      const border = Border.all;
      expect(border.top, equals('─'));
      expect(border.left, equals('│'));
      expect(border.right, equals('│'));
      expect(border.bottom, equals('─'));
    });

    test('Border.symmetric creates border with custom characters', () {
      final border = Border.symmetric(horizontal: '═', vertical: '║');
      expect(border.top, equals('═'));
      expect(border.left, equals('║'));
      expect(border.right, equals('║'));
      expect(border.bottom, equals('═'));
    });

    test('Border.only creates border with only specified sides', () {
      final border = Border.only(top: '═', bottom: '─');
      expect(border.top, equals('═'));
      expect(border.left, equals(''));
      expect(border.right, equals(''));
      expect(border.bottom, equals('─'));
    });

    test('Border.none creates no border', () {
      const border = Border.none;
      expect(border.top, equals(''));
      expect(border.left, equals(''));
      expect(border.right, equals(''));
      expect(border.bottom, equals(''));
    });

    test('Border equality - identical values are equal', () {
      const a = Border(top: '─', left: '│', right: '│', bottom: '─');
      const b = Border(top: '─', left: '│', right: '│', bottom: '─');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Border equality - different values are not equal', () {
      const a = Border(top: '─', left: '│', right: '│', bottom: '─');
      const b = Border(top: '═', left: '║', right: '║', bottom: '═');
      expect(a, isNot(equals(b)));
    });

    test('Border.all equals identical Border', () {
      const a = Border.all;
      const b = Border(top: '─', left: '│', right: '│', bottom: '─');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Border.none equals empty Border', () {
      const a = Border.none;
      const b = Border(top: '', left: '', right: '', bottom: '');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Border equality - partial sides differ', () {
      final a = Border.only(top: '─');
      final b = Border.only(bottom: '─');
      expect(a, isNot(equals(b)));
    });
  });
}
