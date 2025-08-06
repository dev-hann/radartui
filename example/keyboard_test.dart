
import 'dart:io';
import 'dart:async';

void main() async {
  stdout.writeln('Starting keyboard input test...');
  stdout.writeln('stdin.hasTerminal: ${stdin.hasTerminal}');

  if (!stdin.hasTerminal) {
    stdout.writeln('Not running in a terminal. Cannot test raw input.');
    return;
  }

  try {
    stdin.lineMode = false;
    stdin.echoMode = false;
    stdout.writeln('stdin lineMode and echoMode set to false.');
  } on StdinException catch (e) {
    stderr.writeln('Error setting terminal mode: \$e');
    stdout.writeln('Failed to set terminal mode. Raw input might not work.');
    return;
  }

  stdout.writeln('Press any key. Press Ctrl+C to exit.');

  stdin.listen(
    (List<int> data) {
      stdout.writeln('Received bytes: ${data.map((e) => e.toRadixString(16)).join(' ')}');
      stdout.writeln('Received char: "${String.fromCharCodes(data)}"');
    },
    onError: (e) {
      stderr.writeln('Error on stdin stream: \$e');
    },
    onDone: () {
      stdout.writeln('stdin stream closed.');
    },
    cancelOnError: true,
  );

  // Keep the program running to listen for input
  await Future.delayed(Duration(days: 365)); // Listen for a very long time
}
