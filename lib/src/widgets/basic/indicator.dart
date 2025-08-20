import 'dart:async';

import '../../../radartui.dart';

/// A widget that displays animated loading indicators
class LoadingIndicator extends StatefulWidget {
  final IndicatorType type;
  final Color? color;
  final Duration? speed;

  const LoadingIndicator({
    this.type = IndicatorType.spinner,
    this.color,
    this.speed,
  });

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  int _frameIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    final duration = widget.speed ?? const Duration(milliseconds: 200);
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        _frameIndex = (_frameIndex + 1) % _getCurrentFrames().length;
      });
    });
  }

  List<String> _getCurrentFrames() {
    switch (widget.type) {
      case IndicatorType.spinner:
        return ['|', '/', '-', '\\'];
      case IndicatorType.dots:
        return ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
      case IndicatorType.bounce:
        return ['⠁', '⠂', '⠄', '⠂'];
      case IndicatorType.pulse:
        return ['●', '○', '●', '○'];
      case IndicatorType.wave:
        return ['▁', '▃', '▄', '▅', '▆', '▇', '█', '▇', '▆', '▅', '▄', '▃'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final frames = _getCurrentFrames();
    final currentFrame = frames[_frameIndex];

    return Text(
      currentFrame,
      style: TextStyle(color: widget.color ?? Color.cyan, bold: true),
    );
  }
}

/// A progress indicator that shows completion percentage
class ProgressIndicator extends StatelessWidget {
  final int progress; // 0-100
  final Color? fillColor;
  final Color? backgroundColor;
  final bool showPercentage;

  const ProgressIndicator({
    required this.progress,
    this.fillColor,
    this.backgroundColor,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0, 100);

    // Calculate available width based on parent constraints
    // Assume a default reasonable width for terminal UI
    final availableWidth =
        showPercentage ? 16 : 20; // Reserve space for percentage text
    final filled = (clampedProgress * availableWidth / 100).round();
    final empty = availableWidth - filled;

    final fillChar = '█';
    final emptyChar = '░';
    final fillStyle = TextStyle(color: fillColor ?? Color.green);
    final emptyStyle = TextStyle(color: backgroundColor ?? Color.brightBlack);

    final progressBar = [
      const Text('[', style: TextStyle(color: Color.white)),
      for (int i = 0; i < filled; i++) Text(fillChar, style: fillStyle),
      for (int i = 0; i < empty; i++) Text(emptyChar, style: emptyStyle),
      const Text('] ', style: TextStyle(color: Color.white)),
    ];

    if (showPercentage) {
      progressBar.add(
        Text('$clampedProgress%', style: const TextStyle(color: Color.white)),
      );
    }

    return Row(children: progressBar);
  }
}

enum IndicatorType { spinner, dots, bounce, pulse, wave }
