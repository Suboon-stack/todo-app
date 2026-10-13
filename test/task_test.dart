import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_todo_app/models/task.dart';

void main() {
  group('Task', () {
    test('toJson produces all fields', () {
      final createdAt = DateTime(2026, 1, 2, 3, 4, 5);
      final task = Task(
        id: '1',
        title: 'Write tests',
        description: 'Cover the model',
        isCompleted: true,
        createdAt: createdAt,
      );

      expect(task.toJson(), {
        'id': '1',
        'title': 'Write tests',
        'description': 'Cover the model',
        'isCompleted': true,
        'createdAt': createdAt.toIso8601String(),
      });
    });

    test('fromJson round-trips a task', () {
      final task = Task(
        id: '42',
        title: 'Buy milk',
        description: 'Two litres',
        createdAt: DateTime(2026, 5, 6, 7, 8, 9),
      );

      expect(Task.fromJson(task.toJson()), task);
    });

    test('fromJson tolerates missing optional fields', () {
      final task = Task.fromJson({
        'id': '1',
        'title': 'Minimal',
        'createdAt': DateTime(2026).toIso8601String(),
      });

      expect(task.description, '');
      expect(task.isCompleted, false);
    });

    test('copyWith updates only the provided fields', () {
      final task = Task(
        id: '1',
        title: 'Original',
        createdAt: DateTime(2026),
      );

      final updated = task.copyWith(isCompleted: true);

      expect(updated.isCompleted, true);
      expect(updated.title, 'Original');
      expect(updated.id, '1');
    });
  });
}
