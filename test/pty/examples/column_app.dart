import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final bool isPtyTest = args.contains('--pty-test');
  final AppBinding binding = AppBinding.ensureInitialized() as AppBinding;
  binding.initializeServices();

  const widget = Column(
    children: [
      Text('Line 1'),
      Text('Line 2'),
      Text('Line 3'),
    ],
  );

  binding.attachRootWidget(widget);

  if (isPtyTest) {
    binding.renderFrame();
    stdout.flush();
    sleep(const Duration(milliseconds: 100));
    exit(0);
  } else {
    binding.runApp(widget);
  }
}
