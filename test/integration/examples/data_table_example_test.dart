import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('DataTableExample', () {
    testWidgets('renders data table with columns', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      tester.assertContains('DataTable Example');
      tester.assertContains('Name');
      tester.assertContains('Age');
      tester.assertContains('Department');
    });

    testWidgets('shows table data', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      tester.assertContains('Alice');
      tester.assertContains('Bob');
      tester.assertContains('Charlie');
      tester.assertContains('Engineering');
      tester.assertContains('Marketing');
    });

    testWidgets('displays navigation hints', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      tester.assertContains('Arrow keys: navigate');
      tester.assertContains('Enter: sort');
      tester.assertContains('Space: select');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      expect(find.byType<DataTableExample>().exists, isTrue);
    });
  });
}
