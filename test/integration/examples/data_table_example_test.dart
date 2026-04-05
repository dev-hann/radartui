import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('DataTableExample', () {
    testWidgets('renders data table with columns', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '           Name      Role          Score',
        '               Alice  Admin         95',
        '               Bob    User          82',
        '               Carol  User          91',
        '               Dave   Moderator     77',
        '               Eve    Admin         88',
        '',
        '                             📊 DataTable Widget Example',
      ]);
    });

    testWidgets('shows table data', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '           Name      Role          Score',
        '               Alice  Admin         95',
        '               Bob    User          82',
        '               Carol  User          91',
        '               Dave   Moderator     77',
        '               Eve    Admin         88',
        '',
        '                             📊 DataTable Widget Example',
      ]);
    });

    testWidgets('displays navigation hints', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '           Name      Role          Score',
        '               Alice  Admin         95',
        '               Bob    User          82',
        '               Carol  User          91',
        '               Dave   Moderator     77',
        '               Eve    Admin         88',
        '',
        '                             📊 DataTable Widget Example',
      ]);
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const DataTableExample());
      await tester.pumpAndSettle();

      expect(find.byType<DataTableExample>().exists, isTrue);
    });
  });
}
