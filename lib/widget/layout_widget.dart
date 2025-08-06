import 'package:radartui/widget/widget.dart';
import 'package:radartui/enum/axis.dart';

abstract class SingleChildLayoutWidget extends StatelessWidget {
  const SingleChildLayoutWidget({
    super.key,
    required this.child,
  });

  final Widget child;
}

abstract class MultiChildLayoutWidget extends StatelessWidget {
  const MultiChildLayoutWidget({
    super.key,
    required this.children,
  });

  final List<Widget> children;
}

abstract class FlexWidget extends MultiChildLayoutWidget {
  const FlexWidget({
    super.key,
    required super.children,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
}

enum MainAxisAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

enum CrossAxisAlignment {
  start,
  end,
  center,
  stretch,
}

enum MainAxisSize {
  min,
  max,
}