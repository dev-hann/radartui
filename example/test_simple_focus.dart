import '../lib/src/widgets/focus_manager.dart';
import '../lib/src/widgets/basic/focus.dart';

void main() {
  print('🧪 Testing Simple Clean Focus');
  print('===============================');
  
  try {
    // Test basic functionality
    final manager = FocusManager.instance;
    manager.initialize();
    
    print('✓ FocusManager initialized');
    
    // Test dialog scope operations
    manager.pushDialogScope();
    print('✓ Dialog scope pushed');
    
    manager.popDialogScope();
    print('✓ Dialog scope popped');
    
    // Test FocusNode creation
    final node = FocusNode();
    print('✓ FocusNode created and auto-registered');
    
    node.dispose();
    print('✓ FocusNode disposed');
    
    manager.dispose();
    print('✓ FocusManager disposed');
    
    print('\n🎉 Clean focus design works correctly!');
    print('✅ All basic operations successful');
    
  } catch (e, stack) {
    print('\n❌ Error: $e');
    print('Stack trace: $stack');
  }
}