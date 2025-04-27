import 'package:radartui/model/key.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:radartui/widget/focus_node.dart';
import 'package:radartui/widget/widget.dart';

mixin FocusableMixin on Widget {
  final focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(onKey);
    FocusManager.instance.registerFocusNode(focusNode);
    FocusManager.instance.requestFocus(focusNode);
    super.initState();
  }

  void onKey(Key key);

  @override
  void dispose() {
    focusNode.removeListener(onKey);
    FocusManager.instance.unregisterFocusNode(focusNode);
    super.dispose();
  }
}
