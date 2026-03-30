import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('DataColumn', () {
    test('creates with required label', () {
      final column = DataColumn(label: 'Name');
      expect(column.label, equals('Name'));
      expect(column.numeric, isFalse);
      expect(column.onSort, isNull);
    });

    test('creates with numeric flag', () {
      final column = DataColumn(label: 'Age', numeric: true);
      expect(column.numeric, isTrue);
    });

    test('creates with onSort callback', () {
      int? sortIndex;
      bool? sortAscending;
      final column = DataColumn(
        label: 'Name',
        onSort: (index, ascending) {
          sortIndex = index;
          sortAscending = ascending;
        },
      );
      column.onSort?.call(0, true);
      expect(sortIndex, equals(0));
      expect(sortAscending, isTrue);
    });
  });

  group('DataCell', () {
    test('creates with string value', () {
      final cell = DataCell('John');
      expect(cell.value, equals('John'));
    });

    test('creates with empty string', () {
      final cell = DataCell('');
      expect(cell.value, equals(''));
    });
  });

  group('DataRow', () {
    test('creates with cells', () {
      final row = DataRow(cells: [DataCell('John'), DataCell('25')]);
      expect(row.cells.length, equals(2));
      expect(row.cells[0].value, equals('John'));
      expect(row.cells[1].value, equals('25'));
    });

    test('creates with selected false by default', () {
      final row = DataRow(cells: []);
      expect(row.selected, isFalse);
    });

    test('creates with selected true', () {
      final row = DataRow(cells: [], selected: true);
      expect(row.selected, isTrue);
    });

    test('creates with onSelectChanged callback', () {
      bool? wasSelected;
      final row = DataRow(
        cells: [],
        onSelectChanged: (selected) {
          wasSelected = selected;
        },
      );
      row.onSelectChanged?.call(true);
      expect(wasSelected, isTrue);
    });
  });

  group('DataTable', () {
    test('creates with columns and rows', () {
      final table = DataTable(
        columns: [
          DataColumn(label: 'Name'),
          DataColumn(label: 'Age'),
        ],
        rows: [
          DataRow(cells: [DataCell('John'), DataCell('25')]),
        ],
      );
      expect(table.columns.length, equals(2));
      expect(table.rows.length, equals(1));
    });

    test('creates with sortColumnIndex', () {
      final table = DataTable(
        columns: [DataColumn(label: 'Name')],
        rows: [],
        sortColumnIndex: 0,
      );
      expect(table.sortColumnIndex, equals(0));
    });

    test('creates with sortAscending false', () {
      final table = DataTable(
        columns: [DataColumn(label: 'Name')],
        rows: [],
        sortAscending: false,
      );
      expect(table.sortAscending, isFalse);
    });

    test('creates with showCheckboxColumn true', () {
      final table = DataTable(
        columns: [DataColumn(label: 'Name')],
        rows: [],
        showCheckboxColumn: true,
      );
      expect(table.showCheckboxColumn, isTrue);
    });

    test('default values are correct', () {
      final table = DataTable(columns: [], rows: []);
      expect(table.sortColumnIndex, isNull);
      expect(table.sortAscending, isTrue);
      expect(table.showCheckboxColumn, isFalse);
    });
  });
}
