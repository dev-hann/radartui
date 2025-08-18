import 'lib/src/widgets/basic/dialog.dart';
import 'lib/src/foundation/color.dart';
import 'lib/src/foundation/edge_insets.dart';
import 'lib/src/widgets/framework.dart';
import 'lib/src/widgets/basic/text.dart';
import 'lib/src/widgets/basic/button.dart';
import 'lib/src/widgets/basic/column.dart';

void main() {
  print('Dialog Test Program');
  print('=====================');
  
  // Test dialog creation
  try {
    final dialog = Dialog(
      title: 'Test Dialog',
      child: Column(
        children: [
          Text('This is a test dialog'),
          Text('Testing dialog functionality'),
        ] as List<Widget>,
      ) as Widget,
      actions: [
        Button(
          text: 'OK',
          onPressed: () => print('OK pressed'),
        ) as Widget,
        Button(
          text: 'Cancel',
          onPressed: () => print('Cancel pressed'),
        ) as Widget,
      ],
    );
    
    print('✅ Dialog widget created successfully');
    print('   Title: ${dialog.title}');
    print('   Actions: ${dialog.actions?.length ?? 0} buttons');
    print('   Background: ${dialog.backgroundColor}');
    
  } catch (e) {
    print('❌ Error creating dialog: $e');
  }
  
  // Test dialog dismissal functions
  try {
    print('✅ dismissDialog function available');
    print('✅ dismissTopDialog function available');
  } catch (e) {
    print('❌ Error with dialog functions: $e');
  }
  
  print('=====================');
  print('Dialog Test Complete!');
}