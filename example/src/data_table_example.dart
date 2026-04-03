import 'dart:async';
import 'package:radartui/radartui.dart';

class DataTableExample extends StatefulWidget {
  const DataTableExample();

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  StreamSubscription? _keySubscription;
  final List<_Person> _people = [
    _Person('Alice', 30, 'Engineering'),
    _Person('Bob', 25, 'Marketing'),
    _Person('Charlie', 35, 'Engineering'),
    _Person('Diana', 28, 'Sales'),
    _Person('Eve', 32, 'Marketing'),
    _Person('Frank', 40, 'Engineering'),
  ];

  @override
  void initState() {
    super.initState();
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  List<DataRow> _buildRows() {
    return _people.map((person) {
      return DataRow(
        cells: [
          DataCell(person.name),
          DataCell(person.age.toString()),
          DataCell(person.department),
        ],
        selected: person.selected,
        onSelectChanged: (selected) {
          setState(() {
            person.selected = selected;
          });
        },
      );
    }).toList();
  }

  void _handleSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      _people.sort((a, b) {
        int result;
        switch (columnIndex) {
          case 0:
            result = a.name.compareTo(b.name);
            break;
          case 1:
            result = a.age.compareTo(b.age);
            break;
          case 2:
            result = a.department.compareTo(b.department);
            break;
          default:
            result = 0;
        }
        return ascending ? result : -result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          const Container(
            width: 70,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                'DataTable Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Container(
            width: 70,
            padding: const EdgeInsets.all(1),
            child: DataTable(
              columns: [
                DataColumn(
                  label: 'Name',
                  onSort: _handleSort,
                ),
                DataColumn(
                  label: 'Age',
                  numeric: true,
                  onSort: _handleSort,
                ),
                DataColumn(
                  label: 'Department',
                  onSort: _handleSort,
                ),
              ],
              rows: _buildRows(),
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              showCheckboxColumn: true,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Arrow keys: navigate | Enter: sort | Space: select | ESC: back',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}

class _Person {
  _Person(this.name, this.age, this.department);

  final String name;
  final int age;
  final String department;
  bool selected = false;
}
