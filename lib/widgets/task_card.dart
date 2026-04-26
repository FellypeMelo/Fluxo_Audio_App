import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/task_model.dart';
import '../constants/colors.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(String) onToggle;
  final Function(String) onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'alta': return AppColors.error;
      case 'media': return AppColors.warning;
      case 'baixa': return AppColors.success;
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'estudo': return Icons.book_outlined;
      case 'trabalho': return Icons.work_outline;
      case 'saude': return Icons.favorite_outline;
      case 'pessoal': return Icons.person_outline;
      default: return Icons.list_alt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = task.status == 'concluida';
    final priorityColor = _getPriorityColor(task.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Slidable(
        key: ValueKey(task.id),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onToggle(task.id),
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              icon: isDone ? Icons.undo : Icons.check,
              label: isDone ? 'Pendente' : 'Concluir',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(task.id),
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'Excluir',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: InkWell(
              onTap: () => onToggle(task.id),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone ? AppColors.success : theme.colorScheme.outline,
                    width: 2,
                  ),
                  color: isDone ? AppColors.success : Colors.transparent,
                ),
                child: isDone 
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
            title: Text(
              task.title,
              style: theme.textTheme.titleMedium?.copyWith(
                decoration: isDone ? TextDecoration.lineThrough : null,
                color: isDone ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(_getCategoryIcon(task.category), size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    task.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (task.durationMin > 0) ...[
                    const SizedBox(width: 10),
                    Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${task.durationMin} min',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
