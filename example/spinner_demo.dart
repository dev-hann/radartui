import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

void main() {
  runApp(const SpinnerDemoApp());
}

class SpinnerDemoApp extends StatefulWidget {
  const SpinnerDemoApp();

  @override
  State<SpinnerDemoApp> createState() => _SpinnerDemoAppState();
}

class _SpinnerDemoAppState extends State<SpinnerDemoApp> {
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
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((_) {
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
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
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
      Text('[', style: TextStyle(color: Color.white)),
      ...List.generate(filled, (_) => Text('█', style: TextStyle(color: Color.green))),
      ...List.generate(empty, (_) => Text('░', style: TextStyle(color: Color.brightBlack))),
      Text('] \$_progress%', style: TextStyle(color: Color.white)),
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
      padding: EdgeInsets.all(3),
      child: Column(
        children: [
          // Title
          Container(
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
          
          SizedBox(height: 2),
          
          // Main loading area
          Container(
            width: 50,
            height: 8,
            color: Color.brightBlack,
            padding: EdgeInsets.all(2),
            child: Column(
              children: [
                // Status with spinner
                Row(children: [
                  _buildSpinner(),
                  SizedBox(width: 2),
                  Text(
                    _status,
                    style: TextStyle(
                      color: _isLoading ? Color.yellow : Color.green,
                      bold: true,
                    ),
                  ),
                ]),
                
                SizedBox(height: 1),
                
                // Progress bar
                _buildProgressBar(),
                
                SizedBox(height: 1),
                
                // Completion message
                if (!_isLoading) ...[
                  Text(
                    '✓ Loading Complete!',
                    style: TextStyle(
                      color: Color.brightGreen,
                      bold: true,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Press any key to restart',
                    style: TextStyle(
                      color: Color.brightYellow,
                      italic: true,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Please wait...',
                    style: TextStyle(color: Color.brightWhite),
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: 2),
          
          // Info panel
          Container(
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
                Text('• Interactive restart', style: TextStyle(color: Color.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}