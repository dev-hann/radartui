import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('DataTable rendering', () {
    testWidgets('DataTable renders columns and rows', (tester) async {
      tester.pumpWidget(
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
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(
          [' Name      Age', '   Alice  30', '   Bob    25']);
    });

    testWidgets('DataTable shows sort indicator', (tester) async {
      tester.pumpWidget(
        const DataTable(
          columns: [DataColumn(label: 'Name')],
          rows: [
            DataRow(cells: [DataCell('Alice')]),
          ],
          sortColumnIndex: 0,
          sortAscending: true,
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([' Name ▲', '  Alice']);
    });

    testWidgets('DataTable shows descending sort indicator', (tester) async {
      tester.pumpWidget(
        const DataTable(
          columns: [DataColumn(label: 'Name')],
          rows: [
            DataRow(cells: [DataCell('Alice')]),
          ],
          sortColumnIndex: 0,
          sortAscending: false,
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([' Name ▼', '  Alice']);
    });

    testWidgets('DataTable shows checkbox column when enabled', (tester) async {
      tester.pumpWidget(
        const DataTable(
          columns: [DataColumn(label: 'Name')],
          rows: [
            DataRow(cells: [DataCell('Alice')], selected: true),
          ],
          showCheckboxColumn: true,
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['     Name', ' [x]  Alice']);
    });

    testWidgets('DataTable shows unchecked checkbox', (tester) async {
      tester.pumpWidget(
        const DataTable(
          columns: [DataColumn(label: 'Name')],
          rows: [
            DataRow(cells: [DataCell('Alice')], selected: false),
          ],
          showCheckboxColumn: true,
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['     Name', ' [ ]  Alice']);
    });
  });

  group('DataTable interaction', () {
    testWidgets('DataTable navigates with arrow keys', (tester) async {
      tester.pumpWidget(
        const DataTable(
          columns: [DataColumn(label: 'Name')],
          rows: [
            DataRow(cells: [DataCell('Alice')]),
            DataRow(cells: [DataCell('Bob')]),
            DataRow(cells: [DataCell('Charlie')]),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowDown();
      await tester.pumpAndSettle();

      tester.assertContains('Bob');
    });

    testWidgets('DataTable triggers sort on Enter', (tester) async {
      int sortColumnIndex = -1;
      bool sortAscending = false;

      tester.pumpWidget(
        DataTable(
          columns: [
            DataColumn(
              label: 'Name',
              onSort: (index, ascending) {
                sortColumnIndex = index;
                sortAscending = ascending;
              },
            ),
          ],
          rows: const [
            DataRow(cells: [DataCell('Alice')]),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(sortColumnIndex, equals(0));
      expect(sortAscending, isTrue);
    });

    testWidgets('DataTable toggles selection with Space', (tester) async {
      bool selected = false;

      tester.pumpWidget(
        DataTable(
          columns: const [DataColumn(label: 'Name')],
          rows: [
            DataRow(
              cells: const [DataCell('Alice')],
              onSelectChanged: (value) {
                selected = value;
              },
            ),
          ],
          showCheckboxColumn: true,
        ),
      );

      await tester.pumpAndSettle();

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(selected, isTrue);
    });

    testWidgets('DataTable navigates columns with left/right arrows', (
      tester,
    ) async {
      int sortColumnIndex = -1;

      tester.pumpWidget(
        DataTable(
          columns: [
            DataColumn(
              label: 'Name',
              onSort: (index, _) {
                sortColumnIndex = index;
              },
            ),
            DataColumn(
              label: 'Age',
              onSort: (index, _) {
                sortColumnIndex = index;
              },
            ),
          ],
          rows: const [
            DataRow(cells: [DataCell('Alice'), DataCell('30')]),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowRight();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(sortColumnIndex, equals(1));
    });
  });
}
