import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_filter.dart';
import '../services/task_repository.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_filter_bar.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

/// Home screen: shows the list of tasks with filtering and CRUD actions.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskRepository _repository = TaskRepository();

  List<Task> _tasks = <Task>[];
  TaskFilter _filter = TaskFilter.all;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _repository.loadTasks();
    if (!mounted) return;
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _persist() => _repository.saveTasks(_tasks);

  List<Task> get _visibleTasks =>
      _tasks.where(_filter.matches).toList(growable: false);

  Future<void> _openTaskForm({Task? task}) async {
    final result = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => TaskFormScreen(task: task),
    );
    if (result == null || !mounted) return;

    setState(() {
      final index = _tasks.indexWhere((item) => item.id == result.id);
      if (index == -1) {
        _tasks.insert(0, result);
      } else {
        _tasks[index] = result;
      }
    });
    await _persist();
  }

  Future<void> _toggleTask(Task task, bool isCompleted) async {
    setState(() {
      final index = _tasks.indexWhere((item) => item.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(isCompleted: isCompleted);
      }
    });
    await _persist();
  }

  Future<void> _deleteTask(Task task) async {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;

    setState(() => _tasks.removeAt(index));
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visibleTasks = _visibleTasks;
    final completed = _tasks.where((task) => task.isCompleted).length;
    final remaining = _tasks.length - completed;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              child: Column(
                children: [
                  Text(
                    _today().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'My Tasks',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$remaining of ${_tasks.length} remaining',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ProgressBar(done: completed, total: _tasks.length),
                ],
              ),
            ),
            TaskFilterBar(
              selected: _filter,
              onChanged: (filter) => setState(() => _filter = filter),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : visibleTasks.isEmpty
                      ? EmptyState(filter: _filter)
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 120),
                          itemCount: visibleTasks.length,
                          itemBuilder: (context, index) {
                            final task = visibleTasks[index];
                            return Dismissible(
                              key: ValueKey(task.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 7,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.error,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Icon(
                                  Icons.delete_rounded,
                                  color: scheme.onError,
                                ),
                              ),
                              onDismissed: (_) => _deleteTask(task),
                              child: TaskTile(
                                task: task,
                                onToggle: (value) => _toggleTask(task, value),
                                onEdit: () => _openTaskForm(task: task),
                                onDelete: () => _deleteTask(task),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: _GradientFab(
        onPressed: () => _openTaskForm(),
      ),
    );
  }

  String _today() {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, '
        '${months[now.month - 1]} ${now.day}';
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = total == 0 ? 0.0 : done / total;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${(ratio * 100).round()}%',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: scheme.primary,
          ),
        ),
      ],
    );
  }
}

class _GradientFab extends StatelessWidget {
  const _GradientFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, const Color(0xFF9C6BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Add Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
