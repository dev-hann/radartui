## 📁 lib/src/services

This directory manages services that interact directly with the operating system or terminal. It is responsible for low-level I/O processing such as keyboard input, terminal output, and logging.

### Key Files

- **`key_parser.dart`**: Parses the raw keyboard input stream from the terminal into structured `KeyEvent` objects.
- **`logger.dart`**: Provides a file-based logging system for debugging, allowing logs to be recorded without interfering with the terminal UI.
- **`output_buffer.dart`**: A double buffer that manages the content to be drawn on the terminal screen. It efficiently updates only the changed parts by comparing the previous frame with the current frame.
- **`terminal.dart`**: Provides functions to directly control the terminal using ANSI escape sequences, such as cursor position control, color and style specification, and terminal size detection.