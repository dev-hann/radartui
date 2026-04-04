import 'dart:io';

import 'package:test/test.dart';

Matcher matchesGoldenFile(String goldenPath) => _GoldenMatcher(goldenPath);

class _GoldenMatcher extends Matcher {
  _GoldenMatcher(this.goldenPath);

  final String goldenPath;

  static bool updateGoldens = false;

  @override
  bool matches(Object? item, Map matchState) {
    final List<String> grid = item as List<String>;
    final File file = File(goldenPath);

    if (updateGoldens || !file.existsSync()) {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(_gridToString(grid));
      matchState['autoUpdated'] = true;
      return true;
    }

    final String expected = file.readAsStringSync();
    final String actual = _gridToString(grid);
    matchState['expected'] = expected;
    matchState['actual'] = actual;
    return expected == actual;
  }

  @override
  Description describe(Description description) =>
      description.add('matches golden file "$goldenPath"');

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState['autoUpdated'] == true) {
      return mismatchDescription.add('golden file was auto-created/updated');
    }

    final String expected = matchState['expected'] as String;
    final String actual = matchState['actual'] as String;
    return mismatchDescription.add(_diff(expected, actual));
  }
}

String _gridToString(List<String> grid) {
  final List<String> trimmed = _trimTrailingEmptyLines(grid);
  return trimmed.map((String line) => line.trimRight()).join('\n');
}

List<String> _trimTrailingEmptyLines(List<String> grid) {
  int last = grid.length - 1;
  while (last >= 0 && grid[last].trimRight().isEmpty) {
    last--;
  }
  return grid.sublist(0, last + 1);
}

String _diff(String expected, String actual) {
  final List<String> expectedLines = expected.split('\n');
  final List<String> actualLines = actual.split('\n');
  final int maxLines = expectedLines.length > actualLines.length
      ? expectedLines.length
      : actualLines.length;
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < maxLines; i++) {
    final String expLine = i < expectedLines.length ? expectedLines[i] : '';
    final String actLine = i < actualLines.length ? actualLines[i] : '';

    if (expLine != actLine) {
      buffer.writeln('--- line ${i + 1}: "$expLine"');
      buffer.writeln('+++ line ${i + 1}: "$actLine"');
    }
  }

  return buffer.toString().trimRight();
}
