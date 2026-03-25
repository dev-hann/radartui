/// RadarTUI - A Flutter-style TUI framework for Dart.
///
/// This library provides a declarative widget-based approach to building
/// terminal user interfaces, inspired by Flutter's architecture.
///
/// ## Key Features
/// - Declarative UI with widget tree structure
/// - Rich widget library (Row, Column, Text, Button, TextField, etc.)
/// - Efficient diff-based rendering
/// - Flexible input handling
/// - Flutter-like state management
///
/// ## Quick Start
/// ```dart
/// import 'package:radartui/radartui.dart';
///
/// void main() {
///   runApp(const MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   const MyApp({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Center(
///       child: Text('Hello, RadarTUI!'),
///     );
///   }
/// }
/// ```
library radartui;

import 'src/binding.dart';
import 'src/services.dart';
import 'src/widgets.dart';

export 'src/binding.dart';
export 'src/foundation.dart';
export 'src/rendering.dart';
export 'src/services.dart';
export 'src/widgets.dart';

void runApp(Widget app) {
  AppLogger.initialize();
  final binding = AppBinding.ensureInitialized();
  binding.initializeServices();
  binding.runApp(app);
}

void shutdown() {
  WidgetsBinding.instance.shutdown();
}
