import 'package:radartui/radartui.dart';

void main() {
  // Create controllers to simulate the exact bug scenario
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  
  print('=== TextField Bug Reproduction Test ===');
  
  // Simulate typing in first field
  print('1. Typing "hello" in first field...');
  controller1.text = 'hello';
  print('   Field 1: "${controller1.text}" (${controller1.text.length} chars)');
  
  // Simulate focus switch (the problematic step)
  print('2. Simulating focus switch to second field...');
  
  // Simulate rapid typing in second field - the exact bug scenario
  print('3. Rapidly typing "1234" in second field...');
  
  // Simulate each keystroke
  print('   Keystroke 1: "1"');
  controller2.insertText('1');
  print('   Field 2: "${controller2.text}" (${controller2.text.length} chars) cursor: ${controller2.cursorPosition}');
  
  print('   Keystroke 2: "2"');
  controller2.insertText('2');
  print('   Field 2: "${controller2.text}" (${controller2.text.length} chars) cursor: ${controller2.cursorPosition}');
  
  print('   Keystroke 3: "3"');
  controller2.insertText('3');
  print('   Field 2: "${controller2.text}" (${controller2.text.length} chars) cursor: ${controller2.cursorPosition}');
  
  print('   Keystroke 4: "4"');
  controller2.insertText('4');
  print('   Field 2: "${controller2.text}" (${controller2.text.length} chars) cursor: ${controller2.cursorPosition}');
  
  // Check the result
  if (controller2.text == "1234" && controller2.cursorPosition == 4) {
    print('\n✅ SUCCESS: All characters present correctly');
    print('   Expected: "1234" (4 chars)');
    print('   Actual: "${controller2.text}" (${controller2.text.length} chars)');
  } else if (controller2.text == "123" && controller2.cursorPosition == 3) {
    print('\n❌ BUG REPRODUCED: Missing 4th character');
    print('   Expected: "1234" (4 chars)');
    print('   Actual: "${controller2.text}" (${controller2.text.length} chars)');
  } else {
    print('\n❓ UNEXPECTED: Different behavior');
    print('   Expected: "1234" (4 chars)');
    print('   Actual: "${controller2.text}" (${controller2.text.length} chars)');
  }
  
  // Test the controller directly to see if it's working correctly
  print('\n=== Direct Controller Test ===');
  final testController = TextEditingController();
  testController.insertText('1');
  testController.insertText('2');
  testController.insertText('3');
  testController.insertText('4');
  
  print('Direct controller test: "${testController.text}" (${testController.text.length} chars)');
  
  if (testController.text == "1234") {
    print('✅ TextEditingController itself works correctly');
    print('   Problem is likely in the rendering/UI layer');
  } else {
    print('❌ TextEditingController has issues');
  }
}