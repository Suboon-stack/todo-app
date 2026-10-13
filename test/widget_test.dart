import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows empty state and add button', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
    expect(find.textContaining('No tasks yet'), findsOneWidget);
  });

  testWidgets('can add a task and see it in the list', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Buy milk');
    await tester.tap(find.text('Add Task').last);
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('1 of 1 remaining'), findsOneWidget);
  });
}
