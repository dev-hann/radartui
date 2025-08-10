import '../framework.dart';
import '../focus_manager.dart';
import 'focus.dart';
import 'text.dart';
import 'column.dart';
import '../../services/key_parser.dart';

class ListView extends StatefulWidget {
  final List<String> items;
  final String? selectedPrefix;
  final String? unselectedPrefix;
  final String? focusedBorder;
  final String? unfocusedBorder;
  final int initialSelectedIndex;
  final void Function(int index, String item)? onItemSelected;
  final FocusNode? focusNode;

  const ListView({
    required this.items,
    this.focusNode,
    this.selectedPrefix = '> ',
    this.unselectedPrefix = '  ',
    this.focusedBorder = '[ ]',
    this.unfocusedBorder = '   ',
    this.initialSelectedIndex = 0,
    this.onItemSelected,
  });

  @override
  State<ListView> createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  int selectedIndex = 0;
  late FocusNode _focusNode;

  @override
  void initState() {
    selectedIndex = widget.initialSelectedIndex.clamp(
      0,
      widget.items.length - 1,
    );
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChanged);
    super.initState();
  }

  @override
  void dispose() {
    // The widget owns the focus node, so it should not dispose it here.
    // The owner of the node is responsible for disposing it.
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(ListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      // Clean up listeners from the old node
      _focusNode.removeListener(_onFocusChanged);
      _focusNode.onKeyEvent = null;

      // Set up the new node
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.onKeyEvent = _handleKeyEvent;
      _focusNode.addListener(_onFocusChanged);
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    switch (event.key) {
      case 'ArrowUp':
      case 'k':
        _moveSelection(-1);
        break;
      case 'ArrowDown':
      case 'j':
        _moveSelection(1);
        break;
      case 'Enter':
      case ' ':
        if (selectedIndex >= 0 && selectedIndex < widget.items.length) {
          widget.onItemSelected?.call(
            selectedIndex,
            widget.items[selectedIndex],
          );
        }
        break;
    }
  }

  void _moveSelection(int direction) {
    setState(() {
      selectedIndex = (selectedIndex + direction).clamp(
        0,
        widget.items.length - 1,
      );
    });
  }

  void _onFocusChanged() {
    setState(() {}); // Re-render on focus change.
  }

  @override
  Widget build(BuildContext context) {
    // Ensure FocusNode is properly registered after Navigator pop
    _focusNode.ensureRegistered();

    // Check focus status, but force to true if scope has recently changed
    bool hasFocus = _focusNode.hasFocus;
    final currentScope = FocusManager.instance.currentScope;

    // Detect and forcibly restore focus if lost after Navigator pop
    if (!hasFocus && currentScope != null && selectedIndex == 0) {
      final currentFocus = currentScope.currentFocus;

      // If there's a current focus but this ListView's node lost focus (e.g., after Navigator pop)
      if (currentFocus != null && currentFocus != _focusNode) {
        hasFocus = true;
        // Request actual focus
        _focusNode.requestFocus();
      }
    }

    final borderPrefix =
        hasFocus ? widget.focusedBorder : widget.unfocusedBorder;

    final children = <Widget>[];

    if (borderPrefix != null) {
      children.add(Text(borderPrefix));
    }

    for (final entry in widget.items.asMap().entries) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == selectedIndex && hasFocus;
      final prefix =
          isSelected ? widget.selectedPrefix : widget.unselectedPrefix;

      children.add(Text('$prefix$item'));
    }

    if (borderPrefix != null) {
      children.add(Text(borderPrefix));
    }

    return Column(children: children);
  }
}
