import 'dart:io';

import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/widget.dart';

export 'canvas/canvas.dart';
export 'canvas/rect.dart';
export 'widget/widget.dart';

class Radartui {
  static final canvas = Canvas();

  static void runApp(Widget app, {required Function(String key) onKey}) {
    canvas.init();

    while (true) {
      canvas.clear();
      app.render(
        canvas,
        Rect(
          x: 0,
          y: 0,
          width: canvas.windowSize.width,
          height: canvas.windowSize.height,
        ),
      );
      final inputData = stdin.readByteSync();
      final input = String.fromCharCode(inputData);
      onKey(input);
    }
  }

  static void exitApp() {
    canvas.dispose();
    exit(0);
  }
}
