import 'package:radartui/widget/widget.dart';
import 'package:radartui/widget/element.dart';

abstract class InheritedWidget extends StatelessWidget {
  const InheritedWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => child;

  bool updateShouldNotify(covariant InheritedWidget oldWidget);

  static T? of<T extends InheritedWidget>(BuildContext context) {
    Element? element = context as Element?;
    
    while (element != null) {
      if (element.widget is T) {
        return element.widget as T;
      }
      element = element.parent;
    }
    
    return null;
  }
}

class InheritedElement extends StatelessElement {
  InheritedElement(InheritedWidget super.widget);

  @override
  void update(Widget newWidget) {
    final oldWidget = widget as InheritedWidget;
    super.update(newWidget);
    final newInheritedWidget = widget as InheritedWidget;
    
    if (newInheritedWidget.updateShouldNotify(oldWidget)) {
      // In a real implementation, this would notify dependent widgets
      // For now, just rebuild
      rebuild();
    }
  }
}

// Example usage pattern
class Provider<T> extends InheritedWidget {
  const Provider({
    super.key,
    required this.value,
    required super.child,
  });

  final T value;

  @override
  bool updateShouldNotify(Provider<T> oldWidget) {
    return value != oldWidget.value;
  }

  static T? of<T>(BuildContext context) {
    final provider = InheritedWidget.of<Provider<T>>(context);
    return provider?.value;
  }
}