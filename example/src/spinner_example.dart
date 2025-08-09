import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class SpinnerExample extends StatefulWidget {
  const SpinnerExample();

  @override
  State<SpinnerExample> createState() => _SpinnerExampleState();
}

class _SpinnerExampleState extends State<SpinnerExample> {
  int _progress = 0;
  bool _isLoading = true;
  String _status = 'Initializing...';
  Timer? _timer;
  StreamSubscription? _keySubscription;
  IndicatorType _currentIndicator = IndicatorType.spinner;

  final List<String> _statusMessages = [
    'Initializing...',
    'Loading components...',
    'Connecting to services...',
    'Preparing interface...',
    'Almost done...',
    'Complete!',
  ];

  final List<IndicatorType> _indicatorTypes = [
    IndicatorType.spinner,
    IndicatorType.dots,
    IndicatorType.bounce,
    IndicatorType.pulse,
    IndicatorType.wave,
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
      if (key.key == 'Escape') {
        Navigator.of(context).pop();
        return;
      }
      if (key.key == 's' || key.key == 'S') {
        _switchIndicator();
        return;
      }
      _restart();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _keySubscription?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_progress < 100) {
          _progress += 2;
          _status =
              _statusMessages[(_progress / 20).floor().clamp(
                0,
                _statusMessages.length - 1,
              )];
        } else {
          _isLoading = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _switchIndicator() {
    setState(() {
      final currentIndex = _indicatorTypes.indexOf(_currentIndicator);
      _currentIndicator = _indicatorTypes[(currentIndex + 1) % _indicatorTypes.length];
    });
  }

  void _restart() {
    setState(() {
      _progress = 0;
      _isLoading = true;
      _status = 'Initializing...';
    });
    _timer?.cancel();
    _startAnimation();
  }

  String _getIndicatorName() {
    switch (_currentIndicator) {
      case IndicatorType.spinner:
        return 'Spinner';
      case IndicatorType.dots:
        return 'Dots';
      case IndicatorType.bounce:
        return 'Bounce';
      case IndicatorType.pulse:
        return 'Pulse';
      case IndicatorType.wave:
        return 'Wave';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          const Container(
            width: 50,
            color: Color.magenta,
            child: Center(
              child: Text(
                '⏳ RadarTUI Loading Demo ⏳',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),

          const SizedBox(height: 2),

          Container(
            width: 50,
            height: 8,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                Row(
                  children: [
                    LoadingIndicator(
                      type: _currentIndicator,
                      color: _isLoading ? Color.cyan : Color.green,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      _status,
                      style: TextStyle(
                        color: _isLoading ? Color.yellow : Color.green,
                        bold: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 1),

                ProgressIndicator(
                  progress: _progress,
                  fillColor: Color.green,
                  backgroundColor: Color.brightBlack,
                ),

                const SizedBox(height: 1),

                Text(
                  'Current: ${_getIndicatorName()}',
                  style: const TextStyle(color: Color.cyan, italic: true),
                ),

                const SizedBox(height: 1),

                if (!_isLoading) ...[
                  const Text(
                    '✓ Loading Complete!',
                    style: TextStyle(color: Color.brightGreen, bold: true),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Any key: restart | S: switch indicator',
                    style: TextStyle(color: Color.brightYellow, italic: true),
                  ),
                ] else ...[
                  const Text(
                    'Please wait... (S: switch indicator)',
                    style: TextStyle(color: Color.brightWhite),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 2),

          const Container(
            width: 50,
            color: Color.blue,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Demo Features:',
                  style: TextStyle(color: Color.white, bold: true),
                ),
                Text(
                  '• Multiple indicator types',
                  style: TextStyle(color: Color.white),
                ),
                Text('• Animated progress bar', style: TextStyle(color: Color.white)),
                Text('• Status updates', style: TextStyle(color: Color.white)),
                Text(
                  '• S: Switch indicators | ESC: Return',
                  style: TextStyle(color: Color.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
