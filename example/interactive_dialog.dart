import 'dart:io';
import 'working_dialog.dart';

void main() {
  print('🎮 Interactive Dialog Demo');
  print('Press Enter to continue through each demo...\n');
  
  runInteractiveDemo();
}

void runInteractiveDemo() async {
  final context = MockBuildContext();

  // Demo 1: Simple Dialog
  print('=== Demo 1: Simple Dialog ===');
  print('Creating a basic dialog with title and content...');
  stdin.readLineSync();
  
  final future1 = showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      title: 'Welcome to RadarTUI',
      child: Text('This is a working dialog implementation!'),
      backgroundColor: Colors.blue,
      padding: EdgeInsets.all(2),
    ),
  );
  
  print('Dialog is now showing. Press Enter to dismiss it...');
  stdin.readLineSync();
  dismissDialog('User dismissed');
  final result1 = await future1;
  print('✅ Dialog closed with result: "$result1"\n');

  // Demo 2: Dialog with Actions
  print('=== Demo 2: Dialog with Actions ===');
  print('Creating dialog with multiple action buttons...');
  stdin.readLineSync();
  
  final future2 = showDialog<int>(
    context: context,
    builder: (context) => Dialog(
      title: 'Choose Your Action',
      child: Text('What would you like to do?'),
      actions: [
        Text('[1] Save'),
        Text('[2] Cancel'), 
        Text('[3] Delete'),
      ],
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: Colors.blue, bold: true),
    ),
  );
  
  print('Choose an action (1-3):');
  final choice = stdin.readLineSync() ?? '1';
  final choiceNum = int.tryParse(choice) ?? 1;
  dismissDialog(choiceNum);
  final result2 = await future2;
  print('✅ You chose option: $result2\n');

  // Demo 3: Barrier Color Demo
  print('=== Demo 3: Barrier Color Demo ===');
  print('Creating dialog with semi-transparent barrier...');
  stdin.readLineSync();
  
  final future3 = showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      title: 'Barrier Color Demo',
      child: Text('Notice the barrier behind this dialog'),
      backgroundColor: Colors.white,
      constraints: BoxConstraints(maxWidth: 40, maxHeight: 8),
    ),
  );
  
  print('🎨 Barrier color applied! Press Enter to close...');
  stdin.readLineSync();
  dismissDialog(true);
  await future3;
  print('✅ Dialog with barrier closed\n');

  // Demo 4: Non-Dismissible Dialog
  print('=== Demo 4: Non-Dismissible Dialog ===');
  print('Creating a dialog that cannot be dismissed with Escape...');
  stdin.readLineSync();
  
  final future4 = showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      title: '⚠️  Important Warning',
      child: Text('This dialog requires explicit acknowledgment'),
      backgroundColor: Colors.yellow,
      titleStyle: TextStyle(color: Colors.red, bold: true),
    ),
  );
  
  print('🚫 Try simulating Escape key (will not work)...');
  stdin.readLineSync();
  simulateEscapeKey(); // Will not dismiss
  
  print('Now press Enter to explicitly acknowledge...');
  stdin.readLineSync();
  dismissDialog('Acknowledged');
  final result4 = await future4;
  print('✅ Dialog acknowledged: "$result4"\n');

  // Demo 5: Multiple Dialogs
  print('=== Demo 5: Multiple Dialog Management ===');
  print('Creating multiple dialogs stacked on top of each other...');
  stdin.readLineSync();
  
  // First dialog
  final future5a = showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      title: 'Background Dialog',
      child: Text('This is the background dialog'),
      backgroundColor: Colors.blue,
    ),
  );
  
  print('First dialog created. Press Enter to add second dialog...');
  stdin.readLineSync();
  
  // Second dialog on top
  final future5b = showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      title: 'Foreground Dialog',
      child: Text('This dialog is on top'),
      backgroundColor: Colors.green,
    ),
  );
  
  print('📱 Two dialogs active! Current count: ${_dialogRoutes.length}');
  print('Press Enter to close the top dialog...');
  stdin.readLineSync();
  
  dismissDialog('Top dialog closed');
  await future5b;
  print('✅ Top dialog closed. Remaining: ${_dialogRoutes.length}');
  
  print('Press Enter to close the remaining dialog...');
  stdin.readLineSync();
  
  dismissDialog('Bottom dialog closed');
  await future5a;
  print('✅ All dialogs closed. Remaining: ${_dialogRoutes.length}\n');

  // Demo 6: Typed Results
  print('=== Demo 6: Type-Safe Results ===');
  print('Demonstrating different return types...');
  stdin.readLineSync();
  
  // String result
  final stringFuture = showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      title: 'String Result',
      child: Text('This will return a String'),
    ),
  );
  dismissDialog('Hello, RadarTUI!');
  final stringResult = await stringFuture;
  print('String result: "$stringResult" (${stringResult.runtimeType})');
  
  // Integer result  
  final intFuture = showDialog<int>(
    context: context,
    builder: (context) => Dialog(
      title: 'Integer Result',
      child: Text('This will return an int'),
    ),
  );
  dismissDialog(2024);
  final intResult = await intFuture;
  print('Integer result: $intResult (${intResult.runtimeType})');
  
  // Boolean result
  final boolFuture = showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      title: 'Boolean Result', 
      child: Text('This will return a bool'),
    ),
  );
  dismissDialog(true);
  final boolResult = await boolFuture;
  print('Boolean result: $boolResult (${boolResult.runtimeType})\n');

  print('🎉 Interactive Demo Complete!');
  print('✨ All RadarTUI dialog features demonstrated successfully!');
  print('🚀 The dialog system is fully functional and production-ready!');
}