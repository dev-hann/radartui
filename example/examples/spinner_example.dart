import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class SpinnerExample extends StatefulWidget {
  final VoidCallback onBack;
  const SpinnerExample({required this.onBack});

  @override
  State<SpinnerExample> createState() => _SpinnerExampleState();
}

class _SpinnerExampleState extends State<SpinnerExample> {
  int _spinnerIndex = 0;
  int _progress = 0;
  bool _isLoading = true;
  String _status = 'Initializing...';
  Timer? _timer;
  StreamSubscription? _keySubscription;
  
  final List<String> _spinnerFrames = ['|', '/', '-', '\\\\'];
  final List<String> _statusMessages = [
    'Initializing...',
    'Loading components...',
    'Connecting to services...',
    'Preparing interface...',
    'Almost done...',
    'Complete!'
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'Escape') {
        widget.onBack();
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
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _spinnerIndex = (_spinnerIndex + 1) % _spinnerFrames.length;
        
        if (_progress < 100) {
          _progress += 2;
          _status = _statusMessages[(_progress / 20).floor().clamp(0, _statusMessages.length - 1)];
        } else {
          _isLoading = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _restart() {
    setState(() {
      _spinnerIndex = 0;
      _progress = 0;
      _isLoading = true;
      _status = 'Initializing...';
    });
    _timer?.cancel();
    _startAnimation();
  }

  Widget _buildProgressBar() {
    final filled = (_progress / 5).floor();
    final empty = 20 - filled;
    
    return Row(children: [
      const Text('[', style: TextStyle(color: Color.white)),
      ...List.generate(filled, (_) => const Text('█', style: TextStyle(color: Color.green))),
      ...List.generate(empty, (_) => const Text('░', style: TextStyle(color: Color.brightBlack))),
      Text('] $_progress%', style: const TextStyle(color: Color.white)),
    ]);
  }

  Widget _buildSpinner() {
    return Text(
      _spinnerFrames[_spinnerIndex],
      style: TextStyle(
        color: _isLoading ? Color.cyan : Color.green,
        bold: true,
      ),
    );
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
                style: TextStyle(
                  color: Color.white,
                  bold: true,
                ),
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
                Row(children: [
                  _buildSpinner(),
                  const SizedBox(width: 2),
                  Text(
                    _status,
                    style: TextStyle(
                      color: _isLoading ? Color.yellow : Color.green,
                      bold: true,
                    ),
                  ),
                ]),
                
                const SizedBox(height: 1),
                
                _buildProgressBar(),
                
                const SizedBox(height: 1),
                
                if (!_isLoading) ...[
                  const Text(
                    '✓ Loading Complete!',
                    style: TextStyle(
                      color: Color.brightGreen,
                      bold: true,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Press any key to restart',
                    style: TextStyle(
                      color: Color.brightYellow,
                      italic: true,
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Please wait...',
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
                Text('• Animated spinner', style: TextStyle(color: Color.white)),
                Text('• Progress bar', style: TextStyle(color: Color.white)),
                Text('• Status updates', style: TextStyle(color: Color.white)),
                Text('• Interactive restart | ESC: Return', style: TextStyle(color: Color.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}