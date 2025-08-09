import '../framework.dart';
import 'focus.dart';
import 'text.dart';
import 'column.dart';
import '../../services/key_parser.dart';
import '../../scheduler/binding.dart';
import 'dart:async';

class ListView extends StatefulWidget {
  final List<String> items;
  final String? selectedPrefix;
  final String? unselectedPrefix;
  final String? focusedBorder;
  final String? unfocusedBorder;
  final int initialSelectedIndex;
  final void Function(int index, String item)? onItemSelected;
  final FocusNode? focusNode;
  final bool autofocus;

  const ListView({
    required this.items,
    this.selectedPrefix = '> ',
    this.unselectedPrefix = '  ',
    this.focusedBorder = '[ ]',
    this.unfocusedBorder = '   ',
    this.initialSelectedIndex = 0,
    this.onItemSelected,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<ListView> createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  int selectedIndex = 0;
  FocusNode? _focusNode;
  StreamSubscription<KeyEvent>? _keySubscription;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex.clamp(0, widget.items.length - 1);
    _focusNode = widget.focusNode ?? FocusNode();
    
    _setupKeyboardListener();
    _focusNode?.addListener(_onFocusChanged);
    
    // 짧은 지연 후 focus scope에 등록 (위젯 트리 구성 완료 후)
    Future.microtask(() => _registerWithFocusScope());
  }

  void _registerWithFocusScope() {
    // FocusManager를 통해 현재 scope에 등록
    final scope = FocusManager.currentScope;
    final focusNode = _focusNode;
    if (focusNode != null) {
      scope?.addNode(focusNode);
      
      if (widget.autofocus) {
        focusNode.requestFocus();
      }
    }
  }

  void _setupKeyboardListener() {
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((event) {
      // 포커스가 있을 때만 키보드 이벤트 처리
      if (_focusNode?.hasFocus == true && event is KeyEvent) {
        _handleKeyEvent(event);
      }
    });
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
          widget.onItemSelected?.call(selectedIndex, widget.items[selectedIndex]);
        }
        break;
    }
  }

  void _moveSelection(int direction) {
    setState(() {
      selectedIndex = (selectedIndex + direction).clamp(0, widget.items.length - 1);
    });
  }

  void _onFocusChanged() {
    setState(() {}); // 포커스 상태 변경 시 다시 그리기
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    _focusNode?.removeListener(_onFocusChanged);
    if (widget.focusNode == null) {
      _focusNode?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = _focusNode?.hasFocus ?? false;
    final borderPrefix = hasFocus ? widget.focusedBorder : widget.unfocusedBorder;
    
    final children = <Widget>[];
    
    if (borderPrefix != null) {
      children.add(Text(borderPrefix) as Widget);
    }
    
    for (final entry in widget.items.asMap().entries) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == selectedIndex && hasFocus;
      final prefix = isSelected ? widget.selectedPrefix : widget.unselectedPrefix;
      
      children.add(Text('$prefix$item') as Widget);
    }
    
    if (borderPrefix != null) {
      children.add(Text(borderPrefix) as Widget);
    }
    
    return Column(children: children) as Widget;
  }
}