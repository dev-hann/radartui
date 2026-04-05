import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(const _StaticDashboard(), args);
}

class _StaticDashboard extends StatelessWidget {
  const _StaticDashboard();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Header(),
        _SystemCard(),
        _CpuCard(),
        _MemDiskRow(),
        _Footer(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Container(
      height: 1,
      color: Color.blue,
      child: Center(
        child: Text(
          'System Dashboard - myhost',
          style: TextStyle(color: Color.white, bold: true),
        ),
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Color.brightBlack,
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('OS: ', style: TextStyle(color: Color.white)),
              Text('Linux 6.5.0', style: TextStyle(color: Color.brightWhite)),
              Text('  Kern: ', style: TextStyle(color: Color.white)),
              Text('6.5.0-44-generic',
                  style: TextStyle(color: Color.brightWhite)),
            ],
          ),
          Row(
            children: [
              Text('Cores: ', style: TextStyle(color: Color.white)),
              Text('8', style: TextStyle(color: Color.brightWhite)),
              Text('  Procs: ', style: TextStyle(color: Color.white)),
              Text('312', style: TextStyle(color: Color.brightWhite)),
              Text('  Up: ', style: TextStyle(color: Color.white)),
              Text('2h 30m', style: TextStyle(color: Color.brightWhite)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CpuCard extends StatelessWidget {
  const _CpuCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Color.brightBlack,
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CPU: 42.5%',
            style: TextStyle(color: Color.green, bold: true),
          ),
          LinearProgressIndicator(
            value: 0.425,
            color: Color.green,
            backgroundColor: Color.black,
          ),
          Sparkline(
            data: [10, 25, 45, 30, 60, 42, 55, 38, 50, 42],
            color: Color.cyan,
          ),
        ],
      ),
    );
  }
}

class _MemDiskRow extends StatelessWidget {
  const _MemDiskRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Card(
            color: Color.brightBlack,
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Memory', style: TextStyle(color: Color.cyan, bold: true)),
                Text('7.2G/16.0G',
                    style: TextStyle(color: Color.green, bold: true)),
                LinearProgressIndicator(
                  value: 0.45,
                  color: Color.green,
                  backgroundColor: Color.black,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: Color.brightBlack,
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Disk (/)',
                    style: TextStyle(color: Color.cyan, bold: true)),
                Text('234G/500G',
                    style: TextStyle(color: Color.green, bold: true)),
                LinearProgressIndicator(
                  value: 0.47,
                  color: Color.green,
                  backgroundColor: Color.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return const StatusBar(
      left: Text('ESC: Back', style: TextStyle(color: Color.white)),
      center: Text('CPU: 42.5% | RAM: 45.0%',
          style: TextStyle(color: Color.white, bold: true)),
      right: Text('Up: 2h 30m', style: TextStyle(color: Color.white)),
    );
  }
}
