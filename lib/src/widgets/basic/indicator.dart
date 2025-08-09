import 'package:radartui/src/foundation/color.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/widgets/basic/text.dart';
import 'package:radartui/src/widgets/basic/row.dart';

/// A widget that displays animated loading indicators
class LoadingIndicator extends StatelessWidget {
  final IndicatorType type;
  final Color? color;
  final int animationFrame;

  const LoadingIndicator({
    this.type = IndicatorType.spinner,
    this.color,
    this.animationFrame = 0,
  });

  List<String> _getCurrentFrames() {
    switch (type) {
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
    final currentFrame = frames[animationFrame % frames.length];

    return Text(
      currentFrame,
      style: TextStyle(
        color: color ?? Color.cyan,
        bold: true,
      ),
    );
  }
}


/// A progress indicator that shows completion percentage
class ProgressIndicator extends StatelessWidget {
  final int progress; // 0-100
  final int width;
  final Color? fillColor;
  final Color? backgroundColor;
  final bool showPercentage;

  const ProgressIndicator({
    required this.progress,
    this.width = 20,
    this.fillColor,
    this.backgroundColor,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0, 100);
    final filled = (clampedProgress * width / 100).round();
    final empty = width - filled;

    final fillChar = '█';
    final emptyChar = '░';
    final fillStyle = TextStyle(color: fillColor ?? Color.green);
    final emptyStyle = TextStyle(color: backgroundColor ?? Color.brightBlack);

    final progressBar = [
      const Text('[', style: TextStyle(color: Color.white)),
      for (int i = 0; i < filled; i++)
        Text(fillChar, style: fillStyle),
      for (int i = 0; i < empty; i++)
        Text(emptyChar, style: emptyStyle),
      Text('] ', style: const TextStyle(color: Color.white)),
    ];

    if (showPercentage) {
      progressBar.add(
        Text('$clampedProgress%', style: const TextStyle(color: Color.white)),
      );
    }

    return Row(children: progressBar);
  }
}

enum IndicatorType {
  spinner,
  dots,
  bounce,
  pulse,
  wave,
}