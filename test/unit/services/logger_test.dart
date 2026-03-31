import 'dart:io';

import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('AppLogger', () {
    tearDown(() async {
      try {
        await Future<void>.delayed(Duration(milliseconds: 50));
        final f = File('radartui.log');
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    });

    test('initialize creates log file and dispose flushes', () async {
      AppLogger.initialize();
      AppLogger.log('Test message');
      AppLogger.dispose();
      await Future<void>.delayed(Duration(milliseconds: 100));

      final logFile = File('radartui.log');
      expect(logFile.existsSync(), isTrue);

      final content = logFile.readAsStringSync();
      expect(content, contains('Test message'));
      expect(content, contains('Log Session Started'));
      expect(content, contains('Log Session Ended'));
    });

    test('multiple log messages are persisted', () async {
      AppLogger.initialize();
      AppLogger.log('First');
      AppLogger.log('Second');
      AppLogger.log('Third');
      AppLogger.dispose();
      await Future<void>.delayed(Duration(milliseconds: 100));

      final logFile = File('radartui.log');
      expect(logFile.existsSync(), isTrue);

      final content = logFile.readAsStringSync();
      expect(content, contains('First'));
      expect(content, contains('Second'));
      expect(content, contains('Third'));
    });
  });
}
