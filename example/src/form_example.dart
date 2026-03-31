import 'package:radartui/radartui.dart';

class FormExample extends StatefulWidget {
  const FormExample();

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  String _name = '';
  String _email = '';
  String _status = 'Fill out the form and press Submit';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _handleSubmit() {
    final nameValid = _validateName(_nameController.text) == null;
    final emailValid = _validateEmail(_emailController.text) == null;

    setState(() {
      if (nameValid && emailValid) {
        _name = _nameController.text;
        _email = _emailController.text;
        _status = 'Form submitted successfully!';
      } else {
        _status = 'Validation failed. Please check your inputs.';
      }
    });
  }

  void _handleReset() {
    _nameController.clear();
    _emailController.clear();
    setState(() {
      _name = '';
      _email = '';
      _status = 'Form reset. Fill out the form again.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 60,
            height: 3,
            color: Color.green,
            child: Center(
              child: Text(
                'Form Validation Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                const Text(
                  'Name Field:',
                  style: TextStyle(color: Color.cyan),
                ),
                const SizedBox(height: 1),
                TextField(
                  controller: _nameController,
                  placeholder: 'Enter your name (min 2 chars)',
                  style: const TextStyle(color: Color.white),
                ),
                if (_nameController.text.isNotEmpty &&
                    _validateName(_nameController.text) != null)
                  Text(
                    _validateName(_nameController.text)!,
                    style: const TextStyle(color: Color.red),
                  ),
                const SizedBox(height: 2),
                const Text(
                  'Email Field:',
                  style: TextStyle(color: Color.cyan),
                ),
                const SizedBox(height: 1),
                TextField(
                  controller: _emailController,
                  placeholder: 'Enter your email (must contain @)',
                  style: const TextStyle(color: Color.white),
                ),
                if (_emailController.text.isNotEmpty &&
                    _validateEmail(_emailController.text) != null)
                  Text(
                    _validateEmail(_emailController.text)!,
                    style: const TextStyle(color: Color.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Button(
                text: 'Submit',
                onPressed: _handleSubmit,
                style: const ButtonStyle(
                  backgroundColor: Color.green,
                  focusBackgroundColor: Color.brightGreen,
                ),
              ),
              const SizedBox(width: 2),
              Button(
                text: 'Reset',
                onPressed: _handleReset,
                style: const ButtonStyle(
                  backgroundColor: Color.red,
                  focusBackgroundColor: Color.brightRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.blue,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Status:',
                  style: TextStyle(color: Color.white, bold: true),
                ),
                Text(_status, style: const TextStyle(color: Color.white)),
                if (_name.isNotEmpty || _email.isNotEmpty) ...[
                  const SizedBox(height: 1),
                  Text('Name: $_name',
                      style: const TextStyle(color: Color.yellow)),
                  Text('Email: $_email',
                      style: const TextStyle(color: Color.yellow)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Tab: Navigate | Enter: Submit button | ESC: Return',
            style: TextStyle(color: Color.brightBlack, italic: true),
          ),
        ],
      ),
    );
  }
}
