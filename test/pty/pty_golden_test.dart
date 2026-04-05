import 'package:test/test.dart';

import 'pty_test_helper.dart';

void main() {
  group('PTY Golden Tests', () {
    testPtyWidget(
      'Text renders correctly',
      example: 'text_app.dart',
      golden: 'text_golden.txt',
    );

    testPtyWidget(
      'Button renders correctly',
      example: 'button_app.dart',
      golden: 'button_golden.txt',
    );

    testPtyWidget(
      'Center renders correctly',
      example: 'center_app.dart',
      golden: 'center_golden.txt',
    );

    testPtyWidget(
      'Column renders correctly',
      example: 'column_app.dart',
      golden: 'column_golden.txt',
    );

    testPtyWidget(
      'Row renders correctly',
      example: 'row_app.dart',
      golden: 'row_golden.txt',
    );

    testPtyWidget(
      'Align renders correctly',
      example: 'align_app.dart',
      golden: 'align_golden.txt',
    );

    testPtyWidget(
      'Card renders correctly',
      example: 'card_app.dart',
      golden: 'card_golden.txt',
    );

    testPtyWidget(
      'Checkbox renders correctly',
      example: 'checkbox_app.dart',
      golden: 'checkbox_golden.txt',
    );

    testPtyWidget(
      'Container renders correctly',
      example: 'container_app.dart',
      golden: 'container_golden.txt',
    );

    testPtyWidget(
      'DataTable renders correctly',
      example: 'data_table_app.dart',
      golden: 'data_table_golden.txt',
    );

    testPtyWidget(
      'Dialog renders correctly',
      example: 'dialog_app.dart',
      golden: 'dialog_golden.txt',
    );

    testPtyWidget(
      'Divider renders correctly',
      example: 'divider_app.dart',
      golden: 'divider_golden.txt',
    );

    testPtyWidget(
      'Expanded renders correctly',
      example: 'expanded_app.dart',
      golden: 'expanded_golden.txt',
    );

    testPtyWidget(
      'GridView renders correctly',
      example: 'grid_view_app.dart',
      golden: 'grid_view_golden.txt',
    );

    testPtyWidget(
      'Icon renders correctly',
      example: 'icon_app.dart',
      golden: 'icon_golden.txt',
    );

    testPtyWidget(
      'ListView renders correctly',
      example: 'list_view_app.dart',
      golden: 'list_view_golden.txt',
    );

    testPtyWidget(
      'Padding renders correctly',
      example: 'padding_app.dart',
      golden: 'padding_golden.txt',
    );

    testPtyWidget(
      'Positioned renders correctly',
      example: 'positioned_app.dart',
      golden: 'positioned_golden.txt',
    );

    testPtyWidget(
      'Radio renders correctly',
      example: 'radio_app.dart',
      golden: 'radio_golden.txt',
    );

    testPtyWidget(
      'RadioGroup renders correctly',
      example: 'radio_group_app.dart',
      golden: 'radio_group_golden.txt',
    );

    testPtyWidget(
      'RichText renders correctly',
      example: 'rich_text_app.dart',
      golden: 'rich_text_golden.txt',
    );

    testPtyWidget(
      'SingleChildScrollView renders correctly',
      example: 'single_child_scroll_view_app.dart',
      golden: 'single_child_scroll_view_golden.txt',
    );

    testPtyWidget(
      'SizedBox renders correctly',
      example: 'sized_box_app.dart',
      golden: 'sized_box_golden.txt',
    );

    testPtyWidget(
      'Spacer renders correctly',
      example: 'spacer_app.dart',
      golden: 'spacer_golden.txt',
    );

    testPtyWidget(
      'Stack renders correctly',
      example: 'stack_app.dart',
      golden: 'stack_golden.txt',
    );

    testPtyWidget(
      'StatusBar renders correctly',
      example: 'status_bar_app.dart',
      golden: 'status_bar_golden.txt',
    );

    testPtyWidget(
      'TextField renders correctly',
      example: 'textfield_app.dart',
      golden: 'textfield_golden.txt',
    );

    testPtyWidget(
      'Toggle renders correctly',
      example: 'toggle_app.dart',
      golden: 'toggle_golden.txt',
    );

    testPtyWidget(
      'TreeView renders correctly',
      example: 'tree_view_app.dart',
      golden: 'tree_view_golden.txt',
    );

    testPtyWidget(
      'Form renders correctly',
      example: 'form_app.dart',
      golden: 'form_golden.txt',
    );

    testPtyWidget(
      'Dashboard renders correctly',
      example: 'dashboard_app.dart',
      golden: 'dashboard_golden.txt',
    );
  });
}
