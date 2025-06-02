import 'dart:async';

abstract class Logger {
  const Logger();
  void log(Object object);
  Future run({required Future Function() callback}) async {
    return runZonedGuarded(
      () {
        return callback();
      },
      (e, s) {
        log(e);
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          log(line);
        },
      ),
    );
  }
}
