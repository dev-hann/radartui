import 'package:radartui/radartui.dart';

class ButtonExample extends StatefulWidget {
  @override
  State<ButtonExample> createState() => _ButtonExampleState();
}

class _ButtonExampleState extends State<ButtonExample> {
  String _message = 'Press a button!';
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Button Widget Example'),
        SizedBox(height: 2),
        Text(_message),
        Text('Counter: $_counter'),
        SizedBox(height: 2),
        Row(
          children: [
            Button(
              text: 'Click Me!',
              onPressed: () {
                setState(() {
                  _message = 'Button clicked!';
                  _counter++;
                });
              },
            ),
            SizedBox(width: 4),
            Button(
              text: 'Reset',
              onPressed: () {
                setState(() {
                  _message = 'Counter reset!';
                  _counter = 0;
                });
              },
              style: const ButtonStyle(
                backgroundColor: Color.red,
                focusBackgroundColor: Color.brightRed,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Button(
          text: 'Disabled Button',
          enabled: false,
          onPressed: () {
            // This should never be called
            setState(() {
              _message = 'This should not happen!';
            });
          },
        ),
        SizedBox(height: 2),
        Button(
          text: 'Custom Style',
          onPressed: () {
            setState(() {
              _message = 'Custom button pressed!';
            });
          },
          style: const ButtonStyle(
            backgroundColor: Color.green,
            focusBackgroundColor: Color.brightGreen,
            foregroundColor: Color.black,
            focusColor: Color.white,
            bold: true,
            padding: EdgeInsets.symmetric(h: 3, v: 1),
          ),
        ),
      ],
    );
  }
}