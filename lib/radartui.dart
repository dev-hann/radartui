import 'dart:io';

import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/input/input.dart';
import 'package:radartui/logger/file_logger.dart';
import 'package:radartui/logger/logger.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/view/view.dart';
import 'package:radartui/widget/element.dart';
import 'package:radartui/widget/widget.dart';

export 'canvas/canvas.dart';
export 'canvas/rect.dart';
export 'widget/widget.dart';
export 'logger/logger.dart';

class Radartui {
  static final canvas = Canvas.instance;

  static Future runApp(
    Widget rootWidget, {
    Logger? logger,
    Function(Key key)? onKey,
  }) async {
    logger ??= FileLogger();

    await logger.run(
      callback: () async {
        canvas.init();
        Input.instance.init();

        // Element 트리 루트 생성
        final rootElement = rootWidget.createElement();
        rootElement.mount(); // 최상위이므로 parent는 null

        Input.instance.stream.listen((key) {
          onKey?.call(key);
          rootElement.onKey(key); // 키 입력도 위임
        });

        while (true) {
          canvas.clear();
          rootElement.render(canvas, Rect.fromCanvas(canvas));
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
