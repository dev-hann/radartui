import '../../../radartui.dart';

class FormScope extends InheritedWidget {
  const FormScope({
    super.key,
    required this.formState,
    required super.child,
  });
  final FormState formState;

  static FormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormScope>();
  }

  @override
  bool updateShouldNotify(FormScope oldWidget) =>
      formState != oldWidget.formState;
}

class Form extends StatefulWidget {
  const Form({
    super.key,
    required this.child,
    this.onSubmitted,
    this.autovalidate = false,
  });
  final Widget child;
  final VoidCallback? onSubmitted;
  final bool autovalidate;

  @override
  State<Form> createState() => FormState();
}

class FormState extends State<Form> {
  final Set<FormFieldState> _fields = {};
  bool _isValid = true;

  bool get isValid => _isValid;

  void register(FormFieldState field) {
    _fields.add(field);
  }

  void unregister(FormFieldState field) {
    _fields.remove(field);
  }

  bool validate() {
    _isValid = true;
    for (final field in _fields) {
      if (!field.validate()) {
        _isValid = false;
      }
    }
    setState(() {});
    return _isValid;
  }

  void save() {
    for (final field in _fields) {
      field.save();
    }
  }

  void reset() {
    for (final field in _fields) {
      field.reset();
    }
    _isValid = true;
    setState(() {});
  }

  void submit() {
    if (validate()) {
      save();
      widget.onSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScope(
      formState: this,
      child: widget.child,
    );
  }
}

class FormField<T> extends StatefulWidget {
  const FormField({
    super.key,
    required this.initialValue,
    this.validator,
    this.onSaved,
    required this.builder,
  });
  final T initialValue;
  final String? Function(T?)? validator;
  final void Function(T)? onSaved;
  final Widget Function(FormFieldState<T>) builder;

  @override
  State<FormField<T>> createState() => FormFieldState<T>();
}

class FormFieldState<T> extends State<FormField<T>> {
  late T _value;
  String? _errorText;

  T get value => _value;
  String? get errorText => _errorText;
  bool get hasError => _errorText != null;
  bool get isValid => _errorText == null;

  void setValue(T value) {
    _value = value;
    setState(() {});
  }

  bool validate() {
    if (widget.validator != null) {
      _errorText = widget.validator!(_value);
    }
    setState(() {});
    return _errorText == null;
  }

  void save() {
    widget.onSaved?.call(_value);
  }

  void reset() {
    _value = widget.initialValue;
    _errorText = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final formScope = FormScope.of(context);
      if (formScope != null) {
        formScope.formState.register(this);
      }
    });
  }

  @override
  void dispose() {
    final formScope = FormScope.of(context);
    if (formScope != null) {
      formScope.formState.unregister(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}

class TextFormField extends StatefulWidget {
  const TextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.placeholder,
    this.style,
    this.maxLength,
  });
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onSaved;
  final String? placeholder;
  final TextStyle? style;
  final int? maxLength;

  @override
  State<TextFormField> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends State<TextFormField> {
  late TextEditingController _controller;
  bool _isControllerOwned = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      if (widget.initialValue != null) {
        _controller.text = widget.initialValue!;
      }
      _isControllerOwned = true;
    }
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_isControllerOwned) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  bool validate() {
    if (widget.validator != null) {
      _errorText = widget.validator!(_controller.text);
    }
    setState(() {});
    return _errorText == null;
  }

  void save() {
    widget.onSaved?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          placeholder: widget.placeholder,
          style: widget.style,
          maxLength: widget.maxLength,
        ),
        if (_errorText != null)
          Text(_errorText!, style: const TextStyle(color: Color.red)),
      ],
    );
  }
}
