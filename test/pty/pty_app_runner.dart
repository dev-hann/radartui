import 'dart:io';
import 'package:radartui/radartui.dart';

void runPtyApp(Widget widget, List<String> args) {
  final bool isPtyTest = args.contains('--pty-test');
  final AppBinding binding = AppBinding.ensureInitialized() as AppBinding;
  if (!isPtyTest) {
    binding.initializeServices();
  }

  binding.attachRootWidget(widget);

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(widget);
  }
}
