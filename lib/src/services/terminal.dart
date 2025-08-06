import 'dart:io';

class Terminal {
  int get width => stdout.hasTerminal ? stdout.terminalColumns : 80;
  int get height => stdout.hasTerminal ? stdout.terminalLines : 24;
  void clear() => stdout.write('\x1b[2J\x1b[H');
}
