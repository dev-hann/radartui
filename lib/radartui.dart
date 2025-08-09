export 'src/foundation/axis.dart';
export 'src/foundation/color.dart';
export 'src/foundation/edge_insets.dart';
export 'src/foundation/offset.dart';
export 'src/foundation/size.dart';
export 'src/foundation/constants.dart';

export 'src/widgets/framework.dart';
export 'src/widgets/basic.dart';
export 'src/services/key_parser.dart';
export 'src/services/logger.dart';

import 'package:radartui/src/scheduler/binding.dart';
import 'package:radartui/src/widgets/framework.dart';

void runApp(Widget app) => SchedulerBinding.instance.runApp(app);
