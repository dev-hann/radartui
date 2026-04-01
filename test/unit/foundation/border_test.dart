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
  });
}
