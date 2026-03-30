/// Services layer providing terminal I/O and utilities.
///
/// This includes:
/// - [Terminal] for terminal control (cursor, clear, etc.)
/// - [OutputBuffer] for double-buffered rendering
/// - [KeyParser] for parsing keyboard input
/// - [RawKeyboard] for keyboard event handling
/// - [AppLogger] for debug logging
library services;

export 'services/key_parser.dart';
export 'services/keyboard_backend.dart';
export 'services/logger.dart';
export 'services/output_buffer.dart';
export 'services/raw_keyboard.dart';
export 'services/real_terminal_backend.dart';
export 'services/terminal.dart';
export 'services/terminal_backend.dart';
