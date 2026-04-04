import 'package:test/test.dart';

import 'pty_test_helper.dart';

void main() {
  group('PTY Golden Tests', () {
    testPtyWidget(
      'Text renders correctly',
      example: 'text_app.dart',
      golden: 'text_golden.txt',
    );

    testPtyWidget(
      'Button renders correctly',
      example: 'button_app.dart',
      golden: 'button_golden.txt',
    );

    testPtyWidget(
      'Center renders correctly',
      example: 'center_app.dart',
      golden: 'center_golden.txt',
    );

    testPtyWidget(
      'Column renders correctly',
      example: 'column_app.dart',
      golden: 'column_golden.txt',
    );

    testPtyWidget(
      'Row renders correctly',
      example: 'row_app.dart',
      golden: 'row_golden.txt',
    );
  });
}
