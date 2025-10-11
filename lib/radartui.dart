export 'src/foundation.dart';
export 'src/rendering.dart';
export 'src/widgets.dart';
export 'src/services.dart';
export 'src/scheduler.dart';

import 'src/scheduler.dart';
import 'src/widgets.dart';

void runApp(Widget app) => SchedulerBinding.instance.runApp(app);
void shutdown() => SchedulerBinding.instance.shutdown();
