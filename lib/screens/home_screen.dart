import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    
    final activeTasks = taskProvider.tasks
        .where((t) => t.status == 'pendente')
        .toList();

    // Sort by priority: alta -> media -> baixa
    final priorityMap = {'alta': 0, 'media': 1, 'baixa': 2};
    activeTasks.sort((a, b) => 
      (priorityMap[a.priority] ?? 3).compareTo(priorityMap[b.priority] ?? 3)
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minhas Tarefas',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeTasks.isEmpty 
                        ? 'Tudo limpo por aqui!' 
                        : 'Você tem ${activeTasks.length} ${activeTasks.length == 1 ? 'tarefa' : 'tarefas'} para hoje.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: activeTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 80, color: theme.colorScheme.outlineVariant),
                          const SizedBox(height: 16),
                          const Text('Nenhuma tarefa pendente.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: activeTasks.length,
                      itemBuilder: (context, index) {
                        final task = activeTasks[index];
                        return TaskCard(
                          task: task,
                          onToggle: (id) => taskProvider.toggleTask(id),
                          onDelete: (id) => taskProvider.deleteTask(id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
