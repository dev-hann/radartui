import 'dart:io';

import 'package:radartui/logger/logger.dart';

class FileLogger extends Logger {
  FileLogger({String path = "./radartui.log"}) : logFile = File(path);
  final File logFile;

  @override
  void log(Object object) {
    logFile.writeAsStringSync(
      "Radartui: ${object.toString()}\n",
      flush: true,
      mode: FileMode.append,
    );
  }
}
