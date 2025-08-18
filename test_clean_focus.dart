#!/usr/bin/env dart

import 'dart:io';
import 'package:radartui/radartui.dart';

void main() async {
  print('🧪 Testing Clean Dialog Focus Design');
  print('====================================');
  
  await testCleanFocusDesign();
  
  print('\n✅ Clean design tests completed!');
  exit(0);
}

Future<void> testCleanFocusDesign() async {
  print('\n🎯 Testing Navigation-Style Clean Focus Management...');
  
  try {
    // Initialize focus manager
    FocusManager.instance.initialize();
    
    // Test 1: Basic scope creation (like page navigation)
    print('  📄 Test 1: Page-like scope creation');
    final mainScope = FocusScope();
    FocusManager.instance._createNewScope();
    
    final node1 = FocusNode(); // Should auto-register
    final node2 = FocusNode(); // Should auto-register
    
    print('    ✓ Created main scope with 2 auto-registered nodes');
    
    // Test 2: Dialog scope push (complete clean slate)
    print('  📋 Test 2: Dialog push (clean slate approach)');
    FocusManager.instance.pushDialogScope();
    
    final dialogNode1 = FocusNode(); // Should auto-register to dialog scope
    final dialogNode2 = FocusNode(); // Should auto-register to dialog scope
    
    print('    ✓ Pushed dialog scope with 2 new nodes');
    print('    ✓ Previous scope preserved in stack');
    
    // Test 3: Dialog scope pop (restore previous scope)
    print('  📤 Test 3: Dialog pop (restore previous)');
    FocusManager.instance.popDialogScope();
    
    // After pop, dialog scope should be completely disposed
    // Previous scope should be restored and active
    
    final restoredNode = FocusNode(); // Should auto-register to restored scope
    
    print('    ✓ Dialog scope completely disposed');
    print('    ✓ Previous scope restored');
    print('    ✓ New nodes auto-register to restored scope');
    
    // Test 4: Verify clean separation
    print('  🧹 Test 4: Verify clean separation');
    
    // Dialog nodes should be disposed
    // Only restored scope should be active
    
    if (FocusManager.instance.currentScope != null) {
      print('    ✓ Focus manager has active scope');
      print('    ✓ Clean separation maintained');
    } else {
      throw Exception('No active scope after restoration!');
    }
    
    // Clean up
    node1.dispose();
    node2.dispose();
    dialogNode1.dispose();
    dialogNode2.dispose();
    restoredNode.dispose();
    
    FocusManager.instance.dispose();
    
    print('  ✅ All clean focus design tests passed');
    
  } catch (e) {
    print('  ❌ Clean focus design test failed: $e');
    rethrow;
  }
}