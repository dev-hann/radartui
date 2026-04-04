import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final bool isPtyTest = args.contains('--pty-test');
  final AppBinding binding = AppBinding.ensureInitialized() as AppBinding;
  binding.initializeServices();

  const widget = DataTable(
    columns: [
      DataColumn(label: 'Name'),
      DataColumn(label: 'Age'),
    ],
    rows: [
      DataRow(cells: [DataCell('Alice'), DataCell('30')]),
      DataRow(cells: [DataCell('Bob'), DataCell('25')]),
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
