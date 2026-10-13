import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_todo_app/models/task.dart';
import 'package:flutter_todo_app/models/task_filter.dart';

void main() {
  final active = Task(
    id: '1',
    title: 'Active task',
    createdAt: DateTime(2026),
  );
  final completed = Task(
    id: '2',
    title: 'Completed task',
    isCompleted: true,
    createdAt: DateTime(2026),
  );

  group('TaskFilter.matches', () {
    test('all matches every task', () {
      expect(TaskFilter.all.matches(active), true);
      expect(TaskFilter.all.matches(completed), true);
    });

    test('active matches only incomplete tasks', () {
      expect(TaskFilter.active.matches(active), true);
      expect(TaskFilter.active.matches(completed), false);
    });

    test('completed matches only completed tasks', () {
      expect(TaskFilter.completed.matches(active), false);
      expect(TaskFilter.completed.matches(completed), true);
    });
  });

  test('each filter has a label', () {
    expect(TaskFilter.all.label, 'All');
    expect(TaskFilter.active.label, 'Active');
    expect(TaskFilter.completed.label, 'Completed');
  });
}
