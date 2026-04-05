import 'dart:io';

/// Application-wide logger that writes messages to a log file.
class AppLogger {
  static const String _logFilePath = 'radartui.log';
  static File? _logFile;
  static IOSink? _sink;

  /// Opens the log file and starts a new logging session.
  static void initialize() {
    _logFile = File(_logFilePath);
    _sink = _logFile!.openWrite(mode: FileMode.append);
    _sink!.writeln('\n--- Log Session Started: ${DateTime.now()} ---');
  }

  /// Writes a timestamped [message] to the log file.
  static void log(String message) {
    _sink?.writeln('[${DateTime.now()}] $message');
  }

  /// Closes the log file and ends the current logging session.
  static void dispose() {
    _sink?.writeln('--- Log Session Ended: ${DateTime.now()} ---');
    _sink?.close();
  }
}
