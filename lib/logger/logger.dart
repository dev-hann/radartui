import 'dart:async';
import 'dart:io';

// TODO: make it abstract to extendable dependency
class Logger {
  static final logFile = File('./radartui.log');

  static _write(Object object) {
    logFile.writeAsStringSync(
      "Radartui: ${object.toString()}\n",
      flush: true,
      mode: FileMode.append,
    );
  }

  static Future run({required Future Function() callback}) async {
    return runZonedGuarded(
      () {
        return callback();
      },
      (e, s) {
        _write(e);
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          _write(line);
        },
      ),
    );
  }
}
