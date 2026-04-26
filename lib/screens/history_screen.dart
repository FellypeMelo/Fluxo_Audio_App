import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/stats_card.dart';
import '../models/task_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    
    // Group all tasks by day (from the last 7 days)
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    final recentTasks = taskProvider.tasks.where((t) => 
      t.createdAt.isAfter(sevenDaysAgo)
    ).toList();

    final completedCount = recentTasks.where((t) => t.status == 'concluida').length;
    
    // Grouping logic
    final Map<String, List<Task>> groupedTasks = {};
    for (var task in recentTasks) {
      final dateKey = DateFormat('EEEE, d MMM', 'pt_BR').format(task.createdAt);
      if (!groupedTasks.containsKey(dateKey)) {
        groupedTasks[dateKey] = [];
      }
      groupedTasks[dateKey]!.add(task);
    }

    final sortedDates = groupedTasks.keys.toList()
      ..sort((a, b) {
        // Find first task in each group to compare original dates
        final dateA = groupedTasks[a]![0].createdAt;
        final dateB = groupedTasks[b]![0].createdAt;
        return dateB.compareTo(dateA);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Histórico', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StatsCard(
                total: recentTasks.length,
                completed: completedCount,
              ),
            ),
          ),
          if (recentTasks.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('Nenhuma tarefa nos últimos 7 dias.')),
            )
          else
            for (var date in sortedDates) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    date.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = groupedTasks[date]![index];
                      return TaskCard(
                        task: task,
                        onToggle: (id) => taskProvider.toggleTask(id),
                        onDelete: (id) => taskProvider.deleteTask(id),
                      );
                    },
                    childCount: groupedTasks[date]!.length,
                  ),
                ),
              ),
            ],
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}
