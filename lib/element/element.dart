import 'package:radartui/widget/widget.dart';

abstract class Element {
  Element(this.widget);
  final Widget widget;

  void mount(Element parent);

  void unmount(Element parent);

  void update(Element parent, Element newElement);
}

class LeafElement extends Element {
  LeafElement(super.widget);

  @override
  void mount(Element parent) {}

  @override
  void unmount(Element parent) {}

  @override
  void update(Element parent, Element newElement) {}
}
