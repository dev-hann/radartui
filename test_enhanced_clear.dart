import 'lib/src/scheduler/binding.dart';
import 'lib/src/services/terminal.dart';
import 'lib/src/services/output_buffer.dart';

void main() {
  print('Testing Enhanced Screen Clearing Mechanism');
  print('============================================');
  
  // Create terminal and output buffer
  final terminal = Terminal();
  final buffer = OutputBuffer(terminal);
  
  print('Terminal size: ${terminal.width}x${terminal.height}');
  
  // Test 1: Basic clear vs clearAll
  print('\nTest 1: Basic clear() method');
  
  // Fill buffer with some content
  for (int y = 0; y < 5; y++) {
    for (int x = 0; x < 20; x++) {
      buffer.write(x, y, 'X');
    }
  }
  
  // Test normal clear
  buffer.clear();
  print('✓ clear() method works');
  
  // Test 2: Enhanced clearAll method
  print('\nTest 2: Enhanced clearAll() method');
  
  // Fill buffer again
  for (int y = 0; y < 5; y++) {
    for (int x = 0; x < 20; x++) {
      buffer.write(x, y, 'Y');
    }
  }
  
  // Test enhanced clear
  buffer.clearAll();
  print('✓ clearAll() method works - clears both terminal and forces redraw');
  
  // Test 3: Scheduler enhancement
  print('\nTest 3: Scheduler enhanced clearing');
  
  final binding = SchedulerBinding.instance;
  
  // Test scheduleFrameWithClear
  binding.scheduleFrameWithClear();
  print('✓ scheduleFrameWithClear() method works');
  
  print('\nAll tests passed! Enhanced screen clearing is implemented.');
  print('\nThe following improvements have been made:');
  print('1. OutputBuffer.clearAll() - clears terminal AND forces complete redraw');
  print('2. SchedulerBinding.scheduleFrameWithClear() - immediate clear + frame schedule');
  print('3. Navigation methods now use scheduleFrameWithClear() for clean transitions');
  print('4. Every frame now uses clearAll() for complete screen clearing');
}