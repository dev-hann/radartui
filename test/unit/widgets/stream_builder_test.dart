import 'dart:async';

import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('StreamBuilder', () {
    test('StreamBuilder creates with required builder', () {
      final streamBuilder = StreamBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(streamBuilder.builder, isNotNull);
    });

    test('StreamBuilder creates with stream', () {
      final controller = StreamController<String>();
      final streamBuilder = StreamBuilder<String>(
        stream: controller.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(streamBuilder.stream, isNotNull);
      controller.close();
    });

    test('StreamBuilder creates without stream', () {
      final streamBuilder = StreamBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(streamBuilder.stream, isNull);
    });

    test('StreamBuilder creates with initialData', () {
      final streamBuilder = StreamBuilder<String>(
        initialData: 'hello',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(streamBuilder.initialData, equals('hello'));
    });

    test('StreamBuilder creates without initialData', () {
      final streamBuilder = StreamBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(streamBuilder.initialData, isNull);
    });

    test('StreamBuilder is a StatefulWidget', () {
      final streamBuilder = StreamBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(streamBuilder, isA<StatefulWidget>());
    });

    test('StreamBuilder createState returns state', () {
      final streamBuilder = StreamBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return const Text('loading');
        },
      );
      expect(streamBuilder.createState(), isA<State<StreamBuilder<String>>>());
    });
  });
}
