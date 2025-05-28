// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart'; // Import Get for potential controller setup
import 'package:expense_tracker/provider/expenses_provider.dart'; // Import your controller

void main() {
  // It's good practice to ensure GetX is reset before each test
  // if you are putting controllers that might persist across tests.
  // However, for this simple test and how ExpensesController is put in Expenses widget,
  // it might not be strictly necessary but doesn't hurt.
  setUp(() {
    // Clears all Get instances including controllers, services, etc.
    Get.reset(); 
  });
  
  testWidgets('Expenses widget smoke test', (WidgetTester tester) async {
    // You could explicitly put a controller here if needed for testing specific states,
    // or if the widget under test didn't put its own controller.
    // Example: Get.put(ExpensesController()); 
    // Since Expenses() widget itself calls Get.put(ExpensesController()),
    // this explicit Get.put() here might lead to "already registered" error if not handled carefully (e.g. using Get.reset()).
    // For this case, relying on the widget's own Get.put() is fine as it's part of its initialization.

    // Build our app and trigger a frame.
    // MaterialApp is needed because Expenses widget and its children use Material components (Scaffold, AppBar etc.)
    await tester.pumpWidget(const MaterialApp(home: Expenses()));

    // Verify that the AppBar title is present.
    expect(find.text('Flutter ExpenseTracker'), findsOneWidget);

    // Verify that the "Add" button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verify that initially, with default expenses, the "No expenses found" message is NOT shown.
    // The default ExpensesController has two expenses.
    // (This assumes ExpenseList widget will show items if controller.expenses is not empty)
    expect(find.text('No expenses found. Start adding some!'), findsNothing);

  });
}
