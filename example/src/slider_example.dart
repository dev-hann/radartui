import 'dart:async';
import 'package:radartui/radartui.dart';

class SliderExample extends StatefulWidget {
  const SliderExample();

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  int _volume = 50;
  int _brightness = 75;
  StreamSubscription? _keySubscription;

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
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
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
                '🎚️ Slider Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Slider(
            value: _volume,
            min: 0,
            max: 100,
            label: 'Volume',
            onChanged: (int value) {
              setState(() {
                _volume = value;
              });
            },
          ),
          const SizedBox(height: 1),
          Slider(
            value: _brightness,
            min: 0,
            max: 100,
            label: 'Brightness',
            onChanged: (int value) {
              setState(() {
                _brightness = value;
              });
            },
          ),
          const SizedBox(height: 2),
          Text(
            'Volume: $_volume%',
            style: const TextStyle(color: Color.cyan),
          ),
          Text(
            'Brightness: $_brightness%',
            style: const TextStyle(color: Color.cyan),
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
