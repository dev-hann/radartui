import 'dart:async';
import 'package:radartui/radartui.dart';

class FormExample extends StatefulWidget {
  const FormExample();

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  String _formStatus = '';
  StreamSubscription? _keySubscription;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    if (value.length < 3) return 'Min 3 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Must contain @';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Min 6 characters';
    return null;
  }

  void _handleSubmit() {
    final String? nameError = _validateName(_nameController.text);
    final String? emailError = _validateEmail(_emailController.text);
    final String? passError = _validatePassword(_passController.text);
    setState(() {
      if (nameError == null && emailError == null && passError == null) {
        _formStatus = 'Form is valid! Submission successful.';
      } else {
        _formStatus = 'Validation failed. Fix the errors above.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '📝 Form Validation Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 50,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: _validateName,
                  placeholder: 'Username (min 3 chars)',
                  style: const TextStyle(color: Color.white),
                ),
                const SizedBox(height: 1),
                TextFormField(
                  controller: _emailController,
                  validator: _validateEmail,
                  placeholder: 'Email (must contain @)',
                  style: const TextStyle(color: Color.white),
                ),
                const SizedBox(height: 1),
                TextFormField(
                  controller: _passController,
                  validator: _validatePassword,
                  placeholder: 'Password (min 6 chars)',
                  style: const TextStyle(color: Color.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Button(
            text: 'Submit',
            onPressed: _handleSubmit,
            style: const ButtonStyle(
              backgroundColor: Color.green,
              focusBackgroundColor: Color.brightGreen,
            ),
          ),
          const SizedBox(height: 2),
          if (_formStatus.isNotEmpty)
            Text(
              _formStatus,
              style: TextStyle(
                color:
                    _formStatus.contains('success') ? Color.green : Color.red,
                bold: true,
              ),
            ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
