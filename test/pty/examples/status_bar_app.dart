import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final bool isPtyTest = args.contains('--pty-test');
  final AppBinding binding = AppBinding.ensureInitialized() as AppBinding;
  if (!isPtyTest) {
    binding.initializeServices();
  }

  const widget = StatusBar(
    left: Text('NORMAL'),
    center: Text('radartui'),
    right: Text('100%'),
    backgroundColor: Color.blue,
  );

  binding.attachRootWidget(widget);

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(widget);
  }
}
