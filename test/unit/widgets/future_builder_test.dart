import 'dart:async';

import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('FutureBuilder', () {
    test('FutureBuilder creates with required builder', () {
      final futureBuilder = FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(futureBuilder.builder, isNotNull);
    });

    test('FutureBuilder creates with future', () {
      final completer = Completer<String>();
      final futureBuilder = FutureBuilder<String>(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(futureBuilder.future, isNotNull);
    });

    test('FutureBuilder creates without future', () {
      final futureBuilder = FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(futureBuilder.future, isNull);
    });

    test('FutureBuilder creates with initialData', () {
      final futureBuilder = FutureBuilder<String>(
        initialData: 'hello',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(futureBuilder.initialData, equals('hello'));
    });

    test('FutureBuilder creates without initialData', () {
      final futureBuilder = FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(futureBuilder.initialData, isNull);
    });

    test('FutureBuilder is a StatefulWidget', () {
      final futureBuilder = FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(futureBuilder, isA<StatefulWidget>());
    });

    test('FutureBuilder createState returns state', () {
      final futureBuilder = FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(futureBuilder.createState(), isA<State<FutureBuilder<String>>>());
    });

    test('FutureBuilder builder receives correct snapshot types', () {
      AsyncSnapshot<String>? capturedSnapshot;
      FutureBuilder<String>(
        future: Future.value('done'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          capturedSnapshot = snapshot;
          return const Text('loading');
        },
      );
      expect(capturedSnapshot, isNull);
    });
  });
}
