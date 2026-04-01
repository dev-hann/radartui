import 'package:radartui/src/animation/curves.dart';
import 'package:test/test.dart';

void main() {
  group('Curves', () {
    test('linear curve returns input unchanged', () {
      expect(Curves.linear.transform(0.0), equals(0.0));
      expect(Curves.linear.transform(0.5), equals(0.5));
      expect(Curves.linear.transform(1.0), equals(1.0));
    });

    test('easeIn curve accelerates', () {
      expect(Curves.easeIn.transform(0.0), equals(0.0));
      expect(Curves.easeIn.transform(0.5), closeTo(0.25, 0.001));
      expect(Curves.easeIn.transform(1.0), equals(1.0));
    });

    test('easeOut curve decelerates', () {
      expect(Curves.easeOut.transform(0.0), equals(0.0));
      expect(Curves.easeOut.transform(0.5), closeTo(0.75, 0.001));
      expect(Curves.easeOut.transform(1.0), equals(1.0));
    });
  });
}
