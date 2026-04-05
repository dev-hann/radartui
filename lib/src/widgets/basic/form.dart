import '../../../radartui.dart';

/// An inherited widget that provides [FormState] to descendant widgets.
class FormScope extends InheritedWidget {
  /// Creates a [FormScope] that exposes [formState] to descendants.
  const FormScope({super.key, required this.formState, required super.child});

  /// The [FormState] provided to the tree below.
  final FormState formState;

  /// Retrieves the nearest [FormScope] from the widget tree.
  static FormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormScope>();
  }

  @override
  bool updateShouldNotify(FormScope oldWidget) =>
      formState != oldWidget.formState;
}

/// A container for form fields that manages validation and submission.
///
/// Wrap [FormField] widgets in a [Form] to enable collective validation,
/// reset, and submission handling via [onSubmitted].
class Form extends StatefulWidget {
  /// Creates a [Form] that wraps [child] and manages its fields.
  const Form({
    super.key,
    required this.child,
    this.onSubmitted,
    this.autovalidate = false,
  });

  /// The widget tree containing [FormField] widgets to manage.
  final Widget child;

  /// Called when the form is submitted and all fields are valid.
  final VoidCallback? onSubmitted;

  /// Whether to automatically validate fields on every change.
  final bool autovalidate;

  @override
  State<Form> createState() => FormState();
}

/// The mutable state for a [Form], managing field registration and validation.
class FormState extends State<Form> {
  final Set<FormFieldState> _fields = {};
  bool _isValid = true;

  /// Whether all registered fields currently pass validation.
  bool get isValid => _isValid;

  /// Registers a [FormFieldState] with this form.
  void register(FormFieldState field) {
    _fields.add(field);
  }

  /// Unregisters a [FormFieldState] from this form.
  void unregister(FormFieldState field) {
    _fields.remove(field);
  }

  /// Validates all registered fields and returns `true` if all pass.
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

  /// Calls [FormField.onSaved] on every registered field.
  void save() {
    for (final field in _fields) {
      field.save();
    }
  }

  /// Resets all fields to their initial values and clears errors.
  void reset() {
    for (final field in _fields) {
      field.reset();
    }
    _isValid = true;
    setState(() {});
  }

  /// Validates all fields and calls [onSubmitted] if all pass.
  void submit() {
    if (validate()) {
      save();
      widget.onSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScope(formState: this, child: widget.child);
  }
}

/// A single form field that manages its own value, validation, and saving.
///
/// Supply a [builder] callback that returns the visual widget tree, using
/// [FormFieldState] to access the current value and error state.
class FormField<T> extends StatefulWidget {
  /// Creates a [FormField] with the given [initialValue] and optional [validator].
  const FormField({
    super.key,
    required this.initialValue,
    this.validator,
    this.onSaved,
    required this.builder,
  });

  /// The starting value of the field.
  final T initialValue;

  /// An optional validation function that returns an error string or `null`.
  final String? Function(T?)? validator;

  /// Called when the parent [Form] is saved.
  final void Function(T)? onSaved;

  /// Builds the visual representation using the current field state.
  final Widget Function(FormFieldState<T>) builder;

  @override
  State<FormField<T>> createState() => FormFieldState<T>();
}

/// The mutable state for a [FormField], tracking value and validation errors.
class FormFieldState<T> extends State<FormField<T>> {
  late T _value;
  String? _errorText;

  /// The current value of the field.
  T get value => _value;

  /// The current validation error message, or `null` if valid.
  String? get errorText => _errorText;

  /// Whether the field currently has a validation error.
  bool get hasError => _errorText != null;

  /// Whether the field currently passes validation.
  bool get isValid => _errorText == null;

  /// Updates the field value and triggers a rebuild.
  void setValue(T value) {
    _value = value;
    setState(() {});
  }

  /// Runs the [validator] and returns `true` if the field is valid.
  bool validate() {
    if (widget.validator != null) {
      _errorText = widget.validator!(_value);
    }
    setState(() {});
    return _errorText == null;
  }

  /// Calls [onSaved] with the current value.
  void save() {
    widget.onSaved?.call(_value);
  }

  /// Resets the field to [initialValue] and clears any error.
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

/// A convenience widget that combines a [TextField] with form field validation.
///
/// Integrates with the parent [Form] for validation and saving of text input.
class TextFormField extends StatefulWidget {
  /// Creates a [TextFormField] with optional [controller] and [validator].
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

  /// An optional external text controller.
  final TextEditingController? controller;

  /// The initial text value when no controller is provided.
  final String? initialValue;

  /// An optional validation function for the text content.
  final String? Function(String?)? validator;

  /// Called when the parent [Form] is saved with the current text.
  final void Function(String)? onSaved;

  /// Placeholder text displayed when the field is empty.
  final String? placeholder;

  /// The text style applied to the input.
  final TextStyle? style;

  /// The maximum number of characters allowed.
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
