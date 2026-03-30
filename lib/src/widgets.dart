/// Widgets layer providing declarative UI components.
///
/// This includes:
/// - [Widget], [StatelessWidget], [StatefulWidget] base classes
/// - [State], [Element] for widget lifecycle management
/// - Basic widgets: [Text], [Container], [Button], [TextField], etc.
/// - Layout widgets: [Row], [Column], [Stack], [ListView], etc.
/// - Navigation: [Navigator], [Route], [PageRoute]
/// - Focus management: [FocusNode], [FocusScope], [FocusManager]
library widgets;

export 'widgets/basic.dart';
export 'widgets/focus_manager.dart';
export 'widgets/framework.dart';
export 'widgets/navigation.dart';
export 'widgets/navigator_observer.dart';
