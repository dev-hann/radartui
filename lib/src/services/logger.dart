

import 'dart:io';

class AppLogger {
  static const String _logFilePath = 'radartui.log';
  static File? _logFile;
  static IOSink? _sink;

  static void initialize() {
    _logFile = File(_logFilePath);
    _sink = _logFile!.openWrite(mode: FileMode.append);
    _sink!.writeln('\n--- Log Session Started: ${DateTime.now()} ---');
  }

  static void log(String message) {
    _sink?.writeln('[${DateTime.now()}] $message');
  }

  static void dispose() {
    _sink?.writeln('--- Log Session Ended: ${DateTime.now()} ---');
    _sink?.close();
  }
}

