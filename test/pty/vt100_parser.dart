class Vt100Parser {
  Vt100Parser({this.width = 80, this.height = 24});

  final int width;
  final int height;

  List<String> parse(String input) {
    final List<List<String>> grid = _initGrid();
    int row = 0;
    int col = 0;
    int i = 0;

    while (i < input.length) {
      final int ch = input.codeUnitAt(i);

      if (ch == 0x1b) {
        final _EscapeResult result = _handleEscape(input, i, grid, row, col);
        if (result.consumed > 0) {
          row = result.row;
          col = result.col;
          i += result.consumed;
          continue;
        }
        i += 1;
        continue;
      }

      if (ch == 0x0a) {
        row += 1;
        if (row >= height) row = height - 1;
        col = 0;
        i += 1;
        continue;
      }

      if (ch == 0x0d) {
        col = 0;
        i += 1;
        continue;
      }

      if (ch >= 32) {
        if (col < width) {
          grid[row][col] = String.fromCharCode(ch);
          col += 1;
        }
        if (col >= width) {
          col = 0;
          row += 1;
          if (row >= height) row = height - 1;
        }
      }

      i += 1;
    }

    return grid.map((List<String> r) => r.join()).toList();
  }

  List<List<String>> _initGrid() {
    return List<List<String>>.generate(
      height,
      (_) => List<String>.generate(width, (_) => ' '),
    );
  }

  _EscapeResult _handleEscape(
    String input,
    int start,
    List<List<String>> grid,
    int curRow,
    int curCol,
  ) {
    if (start + 1 >= input.length) return _EscapeResult(0, curRow, curCol);
    if (input.codeUnitAt(start + 1) != 0x5b) {
      return _EscapeResult(0, curRow, curCol);
    }

    int j = start + 2;
    final StringBuffer params = StringBuffer();

    while (j < input.length) {
      final int ch = input.codeUnitAt(j);
      if (ch >= 0x30 && ch <= 0x3f) {
        params.writeCharCode(ch);
        j += 1;
        continue;
      }
      break;
    }

    if (j >= input.length) return _EscapeResult(0, curRow, curCol);

    final int cmd = input.codeUnitAt(j);
    final int consumed = j + 1 - start;
    final String p = params.toString();

    switch (cmd) {
      case 0x48:
      case 0x66:
        return _cursorPosition(p, consumed);
      case 0x4a:
        _eraseDisplay(p, grid, curRow, curCol);
        return _EscapeResult(consumed, curRow, curCol);
      case 0x4b:
        _eraseLine(p, grid, curRow, curCol);
        return _EscapeResult(consumed, curRow, curCol);
      case 0x6d:
        return _EscapeResult(consumed, curRow, curCol);
      default:
        return _EscapeResult(consumed, curRow, curCol);
    }
  }

  _EscapeResult _cursorPosition(String params, int consumed) {
    if (params.isEmpty) return _EscapeResult(consumed, 0, 0);

    final List<String> parts = params.split(';');
    final int row = parts.isNotEmpty && parts[0].isNotEmpty
        ? int.tryParse(parts[0]) ?? 1
        : 1;
    final int col = parts.length > 1 && parts[1].isNotEmpty
        ? int.tryParse(parts[1]) ?? 1
        : 1;

    return _EscapeResult(consumed, row - 1, col - 1);
  }

  void _eraseDisplay(
    String params,
    List<List<String>> grid,
    int curRow,
    int curCol,
  ) {
    if (params.isEmpty || params == '0') {
      for (int c = curCol; c < width; c++) {
        grid[curRow][c] = ' ';
      }
      for (int r = curRow + 1; r < height; r++) {
        for (int c = 0; c < width; c++) {
          grid[r][c] = ' ';
        }
      }
    } else if (params == '1') {
      for (int r = 0; r < curRow; r++) {
        for (int c = 0; c < width; c++) {
          grid[r][c] = ' ';
        }
      }
      for (int c = 0; c <= curCol && c < width; c++) {
        grid[curRow][c] = ' ';
      }
    } else if (params == '2') {
      for (int r = 0; r < height; r++) {
        for (int c = 0; c < width; c++) {
          grid[r][c] = ' ';
        }
      }
    }
  }

  void _eraseLine(
    String params,
    List<List<String>> grid,
    int curRow,
    int curCol,
  ) {
    if (params.isEmpty || params == '0') {
      for (int c = curCol; c < width; c++) {
        grid[curRow][c] = ' ';
      }
    } else if (params == '1') {
      for (int c = 0; c <= curCol && c < width; c++) {
        grid[curRow][c] = ' ';
      }
    } else if (params == '2') {
      for (int c = 0; c < width; c++) {
        grid[curRow][c] = ' ';
      }
    }
  }
}

class _EscapeResult {
  const _EscapeResult(this.consumed, this.row, this.col);

  final int consumed;
  final int row;
  final int col;
}
