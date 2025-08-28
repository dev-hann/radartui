import 'dart:async';
import 'dart:math';
import '../../lib/radartui.dart';

class DashboardExample extends StatefulWidget {
  const DashboardExample();

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
  String _systemStatus = 'Optimal';
  Color _statusColor = Color.green;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen(
      _handleKeyEvent,
    );
  }

  void _handleKeyEvent(KeyEvent key) {
    if (key.code == KeyCode.escape) {
      Navigator.of(context).pop();
      return;
    }
    if (key.code == KeyCode.char && (key.char == 'p' || key.char == 'P')) {
      setState(() {
        _paused = !_paused;
        if (_paused) {
          _timer?.cancel();
        } else {
          _startMonitoring();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _keySubscription?.cancel();
    super.dispose();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _uptime++;

        _cpuUsage = 20 + Random().nextDouble() * 60;
        _memoryUsage = 40 + Random().nextDouble() * 40;
        _diskUsage = 55 + Random().nextDouble() * 10;
        _networkIn = Random().nextInt(1000);
        _networkOut = Random().nextInt(800);

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
          (_) => const Text('░', style: TextStyle(color: Color.brightBlack)),
        ),
      ],
    );
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
                'RadarTUI System Dashboard',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),

          const SizedBox(height: 1),

          Container(
            width: 70,
            color: _statusColor,
            child: Row(
              children: [
                const Text(
                  'System Status: ',
                  style: TextStyle(color: Color.black, bold: true),
                ),
                Text(
                  _systemStatus,
                  style: const TextStyle(color: Color.black, bold: true),
                ),
                const SizedBox(width: 10),
                Text(
                  'Uptime: ${_formatUptime(_uptime)}',
                  style: const TextStyle(color: Color.black),
                ),
                const SizedBox(width: 5),
                Text(
                  _paused ? '[PAUSED]' : '',
                  style: const TextStyle(color: Color.black, bold: true),
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          Row(
            children: [
              Container(
                width: 35,
                height: 12,
                color: Color.brightBlack,
                padding: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    const Text(
                      'Resource Usage',
                      style: TextStyle(color: Color.cyan, bold: true),
                    ),
                    const SizedBox(height: 1),

                    Row(
                      children: [
                        const Text('CPU: ', style: TextStyle(color: Color.white)),
                        Text(
                          '${_cpuUsage.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Color.yellow),
                        ),
                      ],
                    ),
                    _buildProgressBar(_cpuUsage, Color.yellow, 25),

                    const SizedBox(height: 1),

                    Row(
                      children: [
                        const Text('MEM: ', style: TextStyle(color: Color.white)),
                        Text(
                          '${_memoryUsage.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Color.green),
                        ),
                      ],
                    ),
                    _buildProgressBar(_memoryUsage, Color.green, 25),

                    const SizedBox(height: 1),

                    Row(
                      children: [
                        const Text('DISK:', style: TextStyle(color: Color.white)),
                        Text(
                          '${_diskUsage.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Color.blue),
                        ),
                      ],
                    ),
                    _buildProgressBar(_diskUsage, Color.blue, 25),
                  ],
                ),
              ),

              const SizedBox(width: 2),

              Container(
                width: 32,
                height: 12,
                color: Color.black,
                padding: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    const Text(
                      'Network & CPU Graph',
                      style: TextStyle(color: Color.magenta, bold: true),
                    ),
                    const SizedBox(height: 1),

                    Row(
                      children: [
                        const Text('IN: ', style: TextStyle(color: Color.green)),
                        Text(
                          '$_networkIn KB/s',
                          style: const TextStyle(color: Color.white),
                        ),
                        const SizedBox(width: 3),
                        const Text('OUT: ', style: TextStyle(color: Color.red)),
                        Text(
                          '$_networkOut KB/s',
                          style: const TextStyle(color: Color.white),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 1),

          const Container(
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
