import '../../../radartui.dart';

class DropdownMenuItem<T> {
  const DropdownMenuItem({required this.value, required this.child});
  final T value;
  final Widget child;
}

class DropdownButton<T> extends StatefulWidget {
  const DropdownButton({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    this.hint,
    this.enabled = true,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final String? hint;
  final bool enabled;

  @override
  State<DropdownButton<T>> createState() => _DropdownButtonState<T>();
}

class _DropdownButtonState<T> extends State<DropdownButton<T>> {
  bool _isExpanded = false;
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
    FocusManager.instance.registerNode(_focusNode);
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChange);
    _hasFocus = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(DropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.value != null) {
      final index = widget.items.indexWhere(
        (item) => item.value == widget.value,
      );
      if (index >= 0) {
        _selectedIndex = index;
      }
    }
  }

  @override
  void dispose() {
    FocusManager.instance.unregisterNode(_focusNode);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
      if (!_hasFocus && _isExpanded) {
        _isExpanded = false;
      }
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.enabled) return;

    if (_isExpanded) {
      if (event.code == KeyCode.arrowUp) {
        setState(() {
          if (_selectedIndex > 0) {
            _selectedIndex--;
          }
        });
      } else if (event.code == KeyCode.arrowDown) {
        setState(() {
          if (_selectedIndex < widget.items.length - 1) {
            _selectedIndex++;
          }
        });
      } else if (event.code == KeyCode.enter ||
          (event.code == KeyCode.char && event.char == ' ')) {
        _selectItem();
      } else if (event.code == KeyCode.escape) {
        setState(() {
          _isExpanded = false;
        });
      }
    } else {
      if (event.code == KeyCode.enter ||
          (event.code == KeyCode.char && event.char == ' ')) {
        setState(() {
          _isExpanded = true;
        });
      }
    }
  }

  void _selectItem() {
    if (_selectedIndex >= 0 && _selectedIndex < widget.items.length) {
      widget.onChanged(widget.items[_selectedIndex].value);
      setState(() {
        _isExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpanded) {
      final children = <Widget>[];
      for (var i = 0; i < widget.items.length; i++) {
        final isSelected = i == _selectedIndex;
        children.add(
          Container(
            color: isSelected ? Color.blue : Color.black,
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: widget.items[i].child,
          ),
        );
      }
      return Column(children: children);
    }

    final displayText = _getDisplayText();
    final indicator = _isExpanded ? '▲' : '▼';

    return Container(
      color: _hasFocus ? Color.blue : Color.black,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        '$displayText $indicator',
        style: TextStyle(
          color: widget.enabled ? Color.white : Color.brightBlack,
        ),
      ),
    );
  }

  String _getDisplayText() {
    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      if (item.value == widget.value) {
        if (item.child is Text) {
          return (item.child as Text).data;
        }
      }
    }
    if (widget.hint != null) {
      return widget.hint!;
    }
    return widget.items.isNotEmpty ? 'Select...' : '';
  }
}
