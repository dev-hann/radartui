import 'dart:async';
import 'package:radartui/radartui.dart';

class DataTableExample extends StatefulWidget {
  const DataTableExample();

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '📊 DataTable Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          DataTable(
            columns: [
              DataColumn(label: 'Name'),
              DataColumn(label: 'Role'),
              DataColumn(label: 'Score', numeric: true),
            ],
            rows: [
              DataRow(cells: [
                DataCell('Alice'),
                DataCell('Admin'),
                DataCell('95'),
              ]),
              DataRow(cells: [
                DataCell('Bob'),
                DataCell('User'),
                DataCell('82'),
              ]),
              DataRow(cells: [
                DataCell('Carol'),
                DataCell('User'),
                DataCell('91'),
              ]),
              DataRow(cells: [
                DataCell('Dave'),
                DataCell('Moderator'),
                DataCell('77'),
              ]),
              DataRow(cells: [
                DataCell('Eve'),
                DataCell('Admin'),
                DataCell('88'),
              ]),
            ],
          ),
          SizedBox(height: 2),
          Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
