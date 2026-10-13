import 'task.dart';

enum TaskFilter {
  all,
  active,
  completed;

  String get label {
    switch (this) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.active:
        return 'Active';
      case TaskFilter.completed:
        return 'Completed';
    }
  }

  bool matches(Task task) {
    switch (this) {
      case TaskFilter.all:
        return true;
      case TaskFilter.active:
        return !task.isCompleted;
      case TaskFilter.completed:
        return task.isCompleted;
    }
  }
}
