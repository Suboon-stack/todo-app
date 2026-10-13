import 'package:flutter/material.dart';

import '../models/task_filter.dart';

/// Friendly placeholder shown when there are no tasks to display.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.filter});

  final TaskFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final (icon, title, subtitle) = switch (filter) {
      TaskFilter.all => (
          Icons.rocket_launch_rounded,
          'No tasks yet',
          'Tap the + button to create your first task.',
        ),
      TaskFilter.active => (
          Icons.task_alt_rounded,
          'All caught up!',
          'You have no active tasks right now.',
        ),
      TaskFilter.completed => (
          Icons.pending_actions_rounded,
          'Nothing completed',
          'Finish a task and it will show up here.',
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary.withValues(alpha: 0.1),
              ),
              child: Icon(icon, size: 46, color: scheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
