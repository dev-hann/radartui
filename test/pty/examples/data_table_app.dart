import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const DataTable(
      columns: [
        DataColumn(label: 'Name'),
        DataColumn(label: 'Age'),
      ],
      rows: [
        DataRow(cells: [DataCell('Alice'), DataCell('30')]),
        DataRow(cells: [DataCell('Bob'), DataCell('25')]),
      ],
    ),
    args,
  );
}
