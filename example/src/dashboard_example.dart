import 'dart:async';
import 'dart:math';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class DashboardExample extends StatefulWidget {
  final Function() onBack;
  const DashboardExample({required this.onBack});

  @override
  State<DashboardExample> createState() => _DashboardExampleState();
}

class _DashboardExampleState extends State<DashboardExample> {
  Timer? _timer;
  StreamSubscription? _keySubscription;

  double _cpuUsage = 0;
  double _memoryUsage = 0;
  double _diskUsage = 0;
  int _networkIn = 0;
  int _networkOut = 0;
  int _uptime = 0;
  final List<double> _cpuHistory = [];
  String _systemStatus = 'Optimal';
  Color _statusColor = Color.green;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
      if (key.key == 'Escape') {
        widget.onBack();
        return;
      }
      if (key.key == 'p' || key.key == 'P') {
        setState(() {
          _paused = !_paused;
          if (_paused) {
            _timer?.cancel();
          } else {
            _startMonitoring();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _keySubscription?.cancel();
    super.dispose();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _uptime++;

        _cpuUsage = 20 + Random().nextDouble() * 60;
        _memoryUsage = 40 + Random().nextDouble() * 40;
        _diskUsage = 55 + Random().nextDouble() * 10;
        _networkIn = Random().nextInt(1000);
        _networkOut = Random().nextInt(800);

        _cpuHistory.add(_cpuUsage);
        if (_cpuHistory.length > 20) {
          _cpuHistory.removeAt(0);
        }

        if (_cpuUsage > 80 || _memoryUsage > 85) {
          _systemStatus = 'Warning';
          _statusColor = Color.yellow;
        } else if (_cpuUsage > 90 || _memoryUsage > 95) {
          _systemStatus = 'Critical';
          _statusColor = Color.red;
        } else {
          _systemStatus = 'Optimal';
          _statusColor = Color.green;
        }
      });
    });
  }

  Widget _buildProgressBar(double value, Color color, int width) {
    final filled = (value * width / 100).round();
    final empty = width - filled;

    return Row(
      children: [
        ...List.generate(
          filled,
          (_) => Text('█', style: TextStyle(color: color)),
        ),
        ...List.generate(
          empty,
          (_) => Text('░', style: TextStyle(color: Color.brightBlack)),
        ),
      ],
    );
  }

  Widget _buildCpuGraph() {
    List<Widget> bars = [];
    for (int i = 0; i < _cpuHistory.length; i++) {
      final value = _cpuHistory[i];
      final height = (value / 25).round().clamp(0, 4);

      Color barColor = Color.green;
      if (value > 60) barColor = Color.yellow;
      if (value > 80) barColor = Color.red;

      bars.add(
        Column(
          children: [
            for (int j = 4; j > height; j--) Text(' '),
            for (int j = 0; j < height; j++)
              Text('▁', style: TextStyle(color: barColor)),
          ],
        ),
      );
    }

    return Row(children: bars);
  }

  String _formatUptime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          const Container(
            width: 70,
            color: Color.blue,
            child: Center(
              child: Text(
                '📊 RadarTUI System Dashboard 📊',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),

          SizedBox(height: 1),

          Container(
            width: 70,
            color: _statusColor,
            child: Row(
              children: [
                Text(
                  'System Status: ',
                  style: TextStyle(color: Color.black, bold: true),
                ),
                Text(
                  _systemStatus,
                  style: TextStyle(color: Color.black, bold: true),
                ),
                SizedBox(width: 10),
                Text(
                  'Uptime: ${_formatUptime(_uptime)}',
                  style: TextStyle(color: Color.black),
                ),
                SizedBox(width: 5),
                Text(
                  _paused ? '[PAUSED]' : '',
                  style: TextStyle(color: Color.black, bold: true),
                ),
              ],
            ),
          ),

          SizedBox(height: 1),

          Row(
            children: [
              Container(
                width: 35,
                height: 12,
                color: Color.brightBlack,
                padding: EdgeInsets.all(1),
                child: Column(
                  children: [
                    Text(
                      'Resource Usage',
                      style: TextStyle(color: Color.cyan, bold: true),
                    ),
                    SizedBox(height: 1),

                    Row(
                      children: [
                        Text('CPU: ', style: TextStyle(color: Color.white)),
                        Text(
                          '${_cpuUsage.toStringAsFixed(1)}%',
                          style: TextStyle(color: Color.yellow),
                        ),
                      ],
                    ),
                    _buildProgressBar(_cpuUsage, Color.yellow, 25),

                    SizedBox(height: 1),

                    Row(
                      children: [
                        Text('MEM: ', style: TextStyle(color: Color.white)),
                        Text(
                          '${_memoryUsage.toStringAsFixed(1)}%',
                          style: TextStyle(color: Color.green),
                        ),
                      ],
                    ),
                    _buildProgressBar(_memoryUsage, Color.green, 25),

                    SizedBox(height: 1),

                    Row(
                      children: [
                        Text('DISK:', style: TextStyle(color: Color.white)),
                        Text(
                          '${_diskUsage.toStringAsFixed(1)}%',
                          style: TextStyle(color: Color.blue),
                        ),
                      ],
                    ),
                    _buildProgressBar(_diskUsage, Color.blue, 25),
                  ],
                ),
              ),

              SizedBox(width: 2),

              Container(
                width: 32,
                height: 12,
                color: Color.black,
                padding: EdgeInsets.all(1),
                child: Column(
                  children: [
                    Text(
                      'Network & CPU Graph',
                      style: TextStyle(color: Color.magenta, bold: true),
                    ),
                    SizedBox(height: 1),

                    Row(
                      children: [
                        Text('IN: ', style: TextStyle(color: Color.green)),
                        Text(
                          '$_networkIn KB/s',
                          style: TextStyle(color: Color.white),
                        ),
                        SizedBox(width: 3),
                        Text('OUT: ', style: TextStyle(color: Color.red)),
                        Text(
                          '$_networkOut KB/s',
                          style: TextStyle(color: Color.white),
                        ),
                      ],
                    ),

                    SizedBox(height: 1),

                    Text('CPU History:', style: TextStyle(color: Color.yellow)),
                    _buildCpuGraph(),

                    SizedBox(height: 1),

                    Text(
                      '0%  25%  50%  75% 100%',
                      style: TextStyle(color: Color.brightBlack),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 1),

          Container(
            width: 70,
            color: Color.yellow,
            child: Text(
              'Press P to pause/resume  •  ESC to return  •  Refreshes every second',
              style: TextStyle(color: Color.black),
            ),
          ),
        ],
      ),
    );
  }
}
