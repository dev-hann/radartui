import 'dart:io';

import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/input/input.dart';
import 'package:radartui/logger/file_logger.dart';
import 'package:radartui/logger/logger.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

export 'canvas/canvas.dart';
export 'canvas/rect.dart';
export 'widget/widget.dart';
export 'logger/logger.dart';

class Radartui {
  static final canvas = Canvas();

  static Future runApp(
    Widget app, {
    Logger? logger,
    Function(Key key)? onKey,
  }) async {
    logger ??= FileLogger();

    await logger.run(
      callback: () async {
        canvas.init();
        app.onMount();
        Input.instance.init();
        Input.instance.stream.listen((key) {
          onKey?.call(key);
        });
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
          await Future.delayed(Duration(milliseconds: 100));
        }
      },
    );
  }

  static void exitApp() {
    canvas.dispose();
    exit(0);
  }
}
