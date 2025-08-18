#!/usr/bin/env dart

import 'dart:io';
import 'package:radartui/radartui.dart';

void main() async {
  print('🧪 Testing Dialog Focus Management');
  print('==================================');
  
  // Test focus management with navigation-style approach
  await testDialogFocusManagement();
  
  print('\n✅ All tests completed!');
  exit(0);
}

Future<void> testDialogFocusManagement() async {
  print('\n📝 Testing Navigation-Style Focus Management...');
  
  try {
    // Test basic focus scope functionality
    print('  🔄 Testing focus scope creation and switching...');
    final scope1 = FocusScope();
    final scope2 = FocusScope(); 
    final node1 = FocusNode();
    final node2 = FocusNode();
    final node3 = FocusNode();
    
    // Test scope activation
    FocusManager.instance.activateScope(scope1);
    scope1.addNode(node1);
    scope1.addNode(node2);
    
    print('  ✓ Scope 1 activated with 2 nodes');
    
    // Test scope stack push (simulating dialog open)
    FocusManager.instance.pushScope(scope2);
    scope2.addNode(node3);
    
    print('  ✓ Scope 2 pushed (dialog opened) with 1 node');
    
    // Test scope stack pop (simulating dialog close) 
    FocusManager.instance.popScope();
    
    print('  ✓ Scope popped (dialog closed), returned to scope 1');
    
    // Verify focus restoration
    if (FocusManager.instance.currentScope == scope1) {
      print('  ✅ Focus successfully restored to original scope');
    } else {
      throw Exception('Focus restoration failed!');
    }
    
    // Test re-registration of nodes
    node1.ensureRegistered();
    node2.ensureRegistered();
    
    if (scope1.nodes.contains(node1) && scope1.nodes.contains(node2)) {
      print('  ✅ Navigation-style re-registration working correctly');
    } else {
      throw Exception('Node re-registration failed!');
    }
    
    // Clean up
    node1.dispose();
    node2.dispose(); 
    node3.dispose();
    scope1.dispose();
    scope2.dispose();
    
    print('  ✅ All focus management tests passed');
    
  } catch (e) {
    print('  ❌ Focus management test failed: $e');
    rethrow;
  }
}