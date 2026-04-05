import 'dart:async';
import 'dart:io';
import 'package:radartui/radartui.dart';

class DashboardExample extends StatefulWidget {
  const DashboardExample();

  @override
  State<DashboardExample> createState() => _DashboardExampleState();
}

class _DashboardExampleState extends State<DashboardExample> {
  StreamSubscription? _keySubscription;
  Timer? _refreshTimer;

  String _hostname = '';
  String _osName = '';
  String _kernel = '';
  String _uptime = '';
  int _processCount = 0;
  int _cpuCoreCount = 0;

  double _cpuUsage = 0.0;
  double _memPercent = 0.0;
  String _memUsed = '';
  String _memTotal = '';
  double _diskPercent = 0.0;
  String _diskUsed = '';
  String _diskTotal = '';

  final List<double> _cpuHistory = [];

  int _prevCpuTotal = 0;
  int _prevCpuIdle = 0;

  @override
  void initState() {
    super.initState();
    _loadStaticInfo();
    _loadDynamicInfo();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _loadDynamicInfo();
      setState(() {});
    });
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
  }

  void _loadStaticInfo() {
    try {
      _hostname = Platform.localHostname;
    } catch (_) {
      _hostname = 'unknown';
    }
    try {
      final String uname =
          Process.runSync('uname', ['-sr']).stdout.toString().trim();
      _osName = uname;
    } catch (_) {
      _osName = Platform.operatingSystem;
    }
    try {
      _kernel = Process.runSync('uname', ['-r']).stdout.toString().trim();
    } catch (_) {
      _kernel = 'unknown';
    }
    _cpuCoreCount = Platform.numberOfProcessors;
  }

  void _loadDynamicInfo() {
    _loadUptime();
    _loadCpuUsage();
    _loadMemory();
    _loadDisk();
    _loadProcessCount();
  }

  void _loadUptime() {
    try {
      final String content = File('/proc/uptime').readAsStringSync().trim();
      final double seconds = double.parse(content.split(' ').first);
      _uptime = _formatUptime(seconds);
    } catch (_) {
      _uptime = 'unknown';
    }
  }

  String _formatUptime(double seconds) {
    final int totalSeconds = seconds.toInt();
    final int days = totalSeconds ~/ 86400;
    final int hours = (totalSeconds % 86400) ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    if (days > 0) return '${days}d ${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  void _loadCpuUsage() {
    try {
      final String content = File('/proc/stat').readAsStringSync();
      final RegExpMatch? match = RegExp(r'cpu\s+(.+)').firstMatch(content);
      if (match == null) return;
      final List<int> values =
          match.group(1)!.trim().split(RegExp(r'\s+')).map(int.parse).toList();
      final int idle = values[3];
      final int total = values.reduce((int a, int b) => a + b);
      if (_prevCpuTotal > 0) {
        final int diffTotal = total - _prevCpuTotal;
        final int diffIdle = idle - _prevCpuIdle;
        if (diffTotal > 0) {
          _cpuUsage = (1.0 - diffIdle / diffTotal) * 100.0;
        }
      }
      _prevCpuTotal = total;
      _prevCpuIdle = idle;
      _cpuHistory.add(_cpuUsage);
      if (_cpuHistory.length > 20) _cpuHistory.removeAt(0);
    } catch (_) {}
  }

  void _loadMemory() {
    try {
      final String content = File('/proc/meminfo').readAsStringSync();
      final int memTotalKb = _parseMemField(content, 'MemTotal');
      final int memAvailableKb = _parseMemField(content, 'MemAvailable');
      final int memUsedKb = memTotalKb - memAvailableKb;
      _memTotal = _formatBytes(memTotalKb * 1024);
      _memUsed = _formatBytes(memUsedKb * 1024);
      _memPercent = memTotalKb > 0 ? (memUsedKb / memTotalKb) * 100.0 : 0.0;
    } catch (_) {
      _memTotal = 'unknown';
      _memUsed = 'unknown';
      _memPercent = 0.0;
    }
  }

  int _parseMemField(String content, String field) {
    final RegExpMatch? match = RegExp('$field:\\s+(\\d+)').firstMatch(content);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  String _formatBytes(int bytes) {
    const int gb = 1024 * 1024 * 1024;
    const int mb = 1024 * 1024;
    if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(1)}G';
    return '${(bytes / mb).toStringAsFixed(0)}M';
  }

  void _loadDisk() {
    try {
      final String result =
          Process.runSync('df', ['-h', '/']).stdout.toString().trim();
      final List<String> lines = result.split('\n');
      if (lines.length >= 2) {
        final List<String> parts = lines[1].trim().split(RegExp(r'\s+'));
        if (parts.length >= 6) {
          _diskTotal = parts[1];
          _diskUsed = parts[2];
          final String percentStr = parts[4].replaceAll('%', '');
          _diskPercent = double.tryParse(percentStr) ?? 0.0;
        }
      }
    } catch (_) {
      _diskTotal = 'unknown';
      _diskUsed = 'unknown';
      _diskPercent = 0.0;
    }
  }

  void _loadProcessCount() {
    try {
      final String result =
          Process.runSync('ps', ['aux']).stdout.toString().trim();
      _processCount = result.split('\n').length - 1;
    } catch (_) {
      _processCount = 0;
    }
  }

  Color _usageColor(double percent) {
    if (percent > 80) return Color.red;
    if (percent > 50) return Color.yellow;
    return Color.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1,
          color: Color.blue,
          child: Center(
            child: Text(
              'System Dashboard - $_hostname',
              style: const TextStyle(color: Color.white, bold: true),
            ),
          ),
        ),
        _buildSystemInfoCard(),
        _buildCpuCard(),
        _buildMemDiskRow(),
        StatusBar(
          left: const Text(
            'ESC: Back',
            style: TextStyle(color: Color.white),
          ),
          center: Text(
            'CPU: ${_cpuUsage.toStringAsFixed(1)}% | RAM: ${_memPercent.toStringAsFixed(1)}%',
            style: const TextStyle(color: Color.white, bold: true),
          ),
          right: Text(
            'Up: $_uptime',
            style: const TextStyle(color: Color.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemInfoCard() {
    return Card(
      color: Color.brightBlack,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'OS: ',
                style: TextStyle(color: Color.white),
              ),
              Text(
                _osName,
                style: const TextStyle(color: Color.brightWhite),
              ),
              const Text(
                '  Kern: ',
                style: TextStyle(color: Color.white),
              ),
              Text(
                _kernel,
                style: const TextStyle(color: Color.brightWhite),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Cores: ',
                style: TextStyle(color: Color.white),
              ),
              Text(
                '$_cpuCoreCount',
                style: const TextStyle(color: Color.brightWhite),
              ),
              const Text(
                '  Procs: ',
                style: TextStyle(color: Color.white),
              ),
              Text(
                '$_processCount',
                style: const TextStyle(color: Color.brightWhite),
              ),
              const Text(
                '  Up: ',
                style: TextStyle(color: Color.white),
              ),
              Text(
                _uptime,
                style: const TextStyle(color: Color.brightWhite),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCpuCard() {
    final Color usageColor = _usageColor(_cpuUsage);
    return Card(
      color: Color.brightBlack,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CPU: ${_cpuUsage.toStringAsFixed(1)}%',
            style: TextStyle(color: usageColor, bold: true),
          ),
          LinearProgressIndicator(
            value: _cpuUsage / 100.0,
            color: usageColor,
            backgroundColor: Color.black,
          ),
          if (_cpuHistory.length >= 2)
            Sparkline(
              data: _cpuHistory,
              color: Color.cyan,
            ),
        ],
      ),
    );
  }

  Widget _buildMemDiskRow() {
    return Row(
      children: [
        Expanded(child: _buildMemoryCard()),
        Expanded(child: _buildDiskCard()),
      ],
    );
  }

  Widget _buildMemoryCard() {
    final Color usageColor = _usageColor(_memPercent);
    return Card(
      color: Color.brightBlack,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Memory',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Text(
            '$_memUsed/$_memTotal',
            style: TextStyle(color: usageColor, bold: true),
          ),
          LinearProgressIndicator(
            value: _memPercent / 100.0,
            color: usageColor,
            backgroundColor: Color.black,
          ),
        ],
      ),
    );
  }

  Widget _buildDiskCard() {
    final Color usageColor = _usageColor(_diskPercent);
    return Card(
      color: Color.brightBlack,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Disk (/)',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Text(
            '$_diskUsed/$_diskTotal',
            style: TextStyle(color: usageColor, bold: true),
          ),
          LinearProgressIndicator(
            value: _diskPercent / 100.0,
            color: usageColor,
            backgroundColor: Color.black,
          ),
        ],
      ),
    );
  }
}
