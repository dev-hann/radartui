import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final bool isPtyTest = args.contains('--pty-test');
  final AppBinding binding = AppBinding.ensureInitialized() as AppBinding;
  binding.initializeServices();

  const widget = Stack(
    children: [
      Positioned(left: 0, top: 0, child: Text('BG')),
      Positioned(left: 5, top: 1, child: Text('FG')),
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
