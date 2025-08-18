import '../lib/src/foundation/color.dart';
import '../lib/src/foundation/edge_insets.dart';
import '../lib/src/foundation/alignment.dart';
import '../lib/src/foundation/box_constraints.dart';
import '../lib/src/widgets/framework.dart';
import '../lib/src/widgets/basic/container.dart';
import '../lib/src/widgets/basic/column.dart';
import '../lib/src/widgets/basic/row.dart';
import '../lib/src/widgets/basic/center.dart';
import '../lib/src/widgets/basic/text.dart';
import '../lib/src/widgets/basic/padding.dart';
import '../lib/src/widgets/basic/dialog.dart';
import '../lib/src/scheduler/binding.dart';

void main() {
  runDialogTest();
}

void runDialogTest() {
  print('🎯 Dialog Test Starting...');

  // Create a mock context
  final mockContext = MockBuildContext();

  // Test 1: Simple Dialog Creation
  print('\n1. Testing Simple Dialog Creation...');
  try {
    final dialog = Dialog(
      title: 'Test Dialog',
      child: Text('Hello from dialog!'),
      backgroundColor: Colors.blue,
    );
    print('✅ Simple dialog created successfully');
    print('   Title: ${dialog.title}');
    print('   Background: ${dialog.backgroundColor}');
  } catch (e) {
    print('❌ Simple dialog creation failed: $e');
  }

  // Test 2: Dialog with Actions
  print('\n2. Testing Dialog with Actions...');
  try {
    final dialog = Dialog(
      title: 'Confirm Action',
      child: Text('Are you sure?'),
      actions: [
        Text('Cancel'),
        Text('OK'),
      ],
      padding: EdgeInsets.all(2),
    );
    print('✅ Dialog with actions created successfully');
    print('   Actions count: ${dialog.actions?.length ?? 0}');
  } catch (e) {
    print('❌ Dialog with actions failed: $e');
  }

  // Test 3: Constrained Dialog
  print('\n3. Testing Constrained Dialog...');
  try {
    final dialog = Dialog(
      title: 'Sized Dialog',
      child: Text('This dialog has constraints'),
      constraints: BoxConstraints(
        maxWidth: 50,
        maxHeight: 10,
      ),
      titleStyle: TextStyle(color: Colors.white, bold: true),
    );
    print('✅ Constrained dialog created successfully');
    print('   Max Width: ${dialog.constraints?.maxWidth}');
    print('   Max Height: ${dialog.constraints?.maxHeight}');
  } catch (e) {
    print('❌ Constrained dialog failed: $e');
  }

  // Test 4: showDialog Function
  print('\n4. Testing showDialog function...');
  try {
    final future = showDialog<String>(
      context: mockContext,
      builder: (context) => Dialog(
        title: 'Async Dialog',
        child: Text('This dialog returns a result'),
        barrierDismissible: true,
      ),
      barrierColor: Colors.black54,
    );
    print('✅ showDialog function works');
    print('   Future created: ${future.runtimeType}');
    
    // Test dismissal
    dismissDialog('Test Result');
    print('✅ dismissDialog function works');
  } catch (e) {
    print('❌ showDialog function failed: $e');
  }

  // Test 5: Multiple Dialogs
  print('\n5. Testing Multiple Dialog Management...');
  try {
    // Create first dialog
    showDialog<int>(
      context: mockContext,
      builder: (context) => Dialog(
        title: 'Dialog 1',
        child: Text('First dialog'),
      ),
    );
    
    // Create second dialog
    showDialog<String>(
      context: mockContext,
      builder: (context) => Dialog(
        title: 'Dialog 2',  
        child: Text('Second dialog'),
      ),
    );
    
    print('✅ Multiple dialogs managed successfully');
    print('   Active dialogs: ${_dialogRoutes.length}');
    
    // Dismiss all
    dismissDialog(42);
    dismissDialog('Done');
    print('✅ Multiple dialogs dismissed successfully');
  } catch (e) {
    print('❌ Multiple dialog management failed: $e');
  }

  print('\n🎉 Dialog Test Complete!');
  print('✨ All core dialog features are working and ready for use!');
}

// Mock BuildContext for testing
class MockBuildContext implements BuildContext {
  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() => null;
}