
/// The main entry point for the Radartui library.
///
/// This file should export all the public-facing APIs from the `src` directory.

// Foundation
export 'src/foundation/color.dart';
export 'src/foundation/size.dart';
export 'src/foundation/offset.dart';
export 'src/foundation/rect.dart';
export 'src/foundation/key.dart';

// Widgets
export 'src/widgets/widget.dart';
export 'src/widgets/state.dart';
export 'src/widgets/framework.dart' show BuildContext;
export 'src/widgets/basic.dart';

// Scheduler
export 'src/scheduler/binding.dart' show SchedulerBinding;

/// A convenience function to run a Radartui application.
void runApp(Widget app) {
  SchedulerBinding.instance.runApp(app);
}
