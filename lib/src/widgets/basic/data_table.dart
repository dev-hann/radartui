import 'dart:math' as math;

import '../../../radartui.dart';

/// Configuration for a single column in a [DataTable].
class DataColumn {
  /// Creates a [DataColumn] with the given [label].
  const DataColumn({required this.label, this.numeric = false, this.onSort});

  /// The header label for this column.
  final String label;

  /// Whether this column contains numeric data (right-aligned).
  final bool numeric;

  /// An optional callback when the column header is activated for sorting.
  final void Function(int columnIndex, bool ascending)? onSort;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataColumn &&
        other.label == label &&
        other.numeric == numeric;
  }

  @override
  int get hashCode => Object.hash(label, numeric);
}

/// A single cell value within a [DataRow].
class DataCell {
  /// Creates a [DataCell] with the given string [value].
  const DataCell(this.value);

  /// The text content of the cell.
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataCell && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// A single row of [DataCell]s in a [DataTable].
class DataRow {
  /// Creates a [DataRow] with the given [cells].
  const DataRow({
    required this.cells,
    this.onSelectChanged,
    this.selected = false,
  });

  /// The cell values for this row.
  final List<DataCell> cells;

  /// Called when the row selection state changes.
  final void Function(bool selected)? onSelectChanged;

  /// Whether this row is currently selected.
  final bool selected;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataRow &&
        other.selected == selected &&
        _listEquals(other.cells, cells);
  }

  @override
  int get hashCode => Object.hash(cells, selected);

  static bool _listEquals(List<DataCell> a, List<DataCell> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return List.generate(a.length, (i) => a[i] == b[i]).every((equal) => equal);
  }
}

/// A table widget that displays data in rows and columns with configurable
/// headers, cell alignment, and optional row selection.
class DataTable extends StatefulWidget {
  /// Creates a [DataTable] with the given [columns] and [rows].
  const DataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.showCheckboxColumn = false,
  });

  /// The column definitions for the table header.
  final List<DataColumn> columns;

  /// The data rows to display.
  final List<DataRow> rows;

  /// The index of the column currently used for sorting, or `null`.
  final int? sortColumnIndex;

  /// Whether the sort is ascending.
  final bool sortAscending;

  /// Whether to show a checkbox column for row selection.
  final bool showCheckboxColumn;

  @override
  State<DataTable> createState() => _DataTableState();
}

class _DataTableState extends State<DataTable> with FocusableState<DataTable> {
  int _focusedRowIndex = 0;
  int _focusedColumnIndex = 0;
  late ScrollController _scrollController;
  List<int> _cachedColumnWidths = const [];
  int? _cachedViewportHeight;

  int get _viewportHeight {
    if (_cachedViewportHeight != null) return _cachedViewportHeight!;
    final mediaQuery = context.findAncestorWidgetOfExactType<MediaQuery>();
    _cachedViewportHeight = (mediaQuery?.data.size.height ?? 24) - 1;
    return _cachedViewportHeight!;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(DataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columns != widget.columns || oldWidget.rows != widget.rows) {
      _cachedColumnWidths = const [];
    }
    _cachedViewportHeight = null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowUp) {
      _moveSelection(-1);
    } else if (event.code == KeyCode.arrowDown) {
      _moveSelection(1);
    } else if (event.code == KeyCode.arrowLeft) {
      setState(() {
        _focusedColumnIndex = (_focusedColumnIndex - 1).clamp(
          0,
          widget.columns.length - 1,
        );
      });
    } else if (event.code == KeyCode.arrowRight) {
      setState(() {
        _focusedColumnIndex = (_focusedColumnIndex + 1).clamp(
          0,
          widget.columns.length - 1,
        );
      });
    } else if (event.code == KeyCode.enter) {
      _triggerSort();
    } else if (event.code == KeyCode.space ||
        (event.code == KeyCode.char && event.char == ' ')) {
      _toggleSelection();
    }
  }

  void _moveSelection(int direction) {
    setState(() {
      _focusedRowIndex = (_focusedRowIndex + direction).clamp(
        0,
        widget.rows.length - 1,
      );
      _scrollController.ensureVisible(_focusedRowIndex, _viewportHeight);
    });
  }

  void _triggerSort() {
    if (_focusedColumnIndex < widget.columns.length) {
      final column = widget.columns[_focusedColumnIndex];
      final ascending = widget.sortColumnIndex != _focusedColumnIndex
          ? true
          : !widget.sortAscending;
      column.onSort?.call(_focusedColumnIndex, ascending);
    }
  }

  void _toggleSelection() {
    if (!widget.showCheckboxColumn) return;
    if (_focusedRowIndex >= 0 && _focusedRowIndex < widget.rows.length) {
      final row = widget.rows[_focusedRowIndex];
      row.onSelectChanged?.call(!row.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final columnWidths = _getColumnWidths();
    final headerRow = _buildHeaderRow(columnWidths);

    final visibleRows = [];
    final scrollOffset = _scrollController.offset.clamp(0, widget.rows.length);
    final visibleCount = _viewportHeight.clamp(1, widget.rows.length);
    final endIndex = (scrollOffset + visibleCount).clamp(0, widget.rows.length);

    for (int i = scrollOffset; i < endIndex; i++) {
      visibleRows.add(_buildDataRow(i, columnWidths));
    }

    return Column(children: [headerRow, ...visibleRows]);
  }

  List<int> _getColumnWidths() {
    if (_cachedColumnWidths.isNotEmpty) return _cachedColumnWidths;
    _cachedColumnWidths = _calculateColumnWidths();
    return _cachedColumnWidths;
  }

  List<int> _calculateColumnWidths() {
    final widths = <int>[];
    for (int i = 0; i < widget.columns.length; i++) {
      widths.add(_maxColumnWidth(i));
    }
    return widths;
  }

  int _maxColumnWidth(int columnIndex) {
    int maxWidth = stringWidth(widget.columns[columnIndex].label);
    for (final row in widget.rows) {
      if (columnIndex < row.cells.length) {
        maxWidth =
            math.max(maxWidth, stringWidth(row.cells[columnIndex].value));
      }
    }
    return maxWidth;
  }

  Widget _buildHeaderRow(List<int> columnWidths) {
    final parts = [];

    if (widget.showCheckboxColumn) {
      parts.add('   ');
    }

    for (int i = 0; i < widget.columns.length; i++) {
      final column = widget.columns[i];
      final width = columnWidths[i];
      String label = column.label;

      if (widget.sortColumnIndex == i) {
        final sortIndicator = widget.sortAscending ? '▲' : '▼';
        label = '$label $sortIndicator';
      }

      label = label.padRight(width + 2);

      parts.add(' $label ');
    }

    return Text(parts.join(' '));
  }

  Widget _buildDataRow(int rowIndex, List<int> columnWidths) {
    final row = widget.rows[rowIndex];
    final parts = _buildCellParts(row, columnWidths);
    final rowText = parts.join('  ');
    return _styledRowText(rowText, rowIndex);
  }

  List<String> _buildCellParts(DataRow row, List<int> columnWidths) {
    final parts = <String>[];

    if (widget.showCheckboxColumn) {
      parts.add(row.selected ? '[x]' : '[ ]');
    }

    for (int i = 0; i < widget.columns.length; i++) {
      final width = columnWidths[i];
      final cellValue = i < row.cells.length ? row.cells[i].value : '';
      final paddedValue = widget.columns[i].numeric
          ? cellValue.padLeft(width)
          : cellValue.padRight(width);
      parts.add(paddedValue);
    }

    return parts;
  }

  Widget _styledRowText(String rowText, int rowIndex) {
    if (hasFocus && rowIndex == _focusedRowIndex) {
      return Text(
        rowText,
        style: const TextStyle(
          color: Color.black,
          backgroundColor: Color.white,
        ),
      );
    }
    return Text(rowText);
  }
}
