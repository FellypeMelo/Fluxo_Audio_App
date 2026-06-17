# Documentação Detalhada: `widgets/task_card.dart`

Este widget engloba a renderização de um elemento de "Tarefa", e seu grande diferencial de UX é possuir um invólucro de gestos laterais (Swipe) via `flutter_slidable`.

## Explicação Linha a Linha

```dart
import 'package:flutter/material.dart';
// Slidable é a biblioteca que permite arrastar cards horizontalmente (Swipe to Delete / Swipe to Check).
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/task_model.dart';
import '../constants/colors.dart';

// Stateless porque as ações são emitidas por callbacks, e ele se redesenha de acordo com os dados do Provider pai.
class TaskCard extends StatelessWidget {
  final Task task;
  // Callback executado ao fazer o Swipe para finalizar tarefa.
  final Function(String) onToggle;
  // Callback executado ao fazer o Swipe para deletar.
  final Function(String) onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  // Função utilitária para definir a cor semântica do card baseada na string recebida pela Inteligência Artificial.
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'alta': return AppColors.error;
      case 'media': return AppColors.warning;
      case 'baixa': return AppColors.success;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Avalia o booleano de conclusão baseando-se na string para aplicar os efeitos visuais de risco na fonte.
    final isDone = task.status == 'concluida';
    final priorityColor = _getPriorityColor(task.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // Envolve a caixa da Tarefa no Widget do Slidable.
      child: Slidable(
        // Utiliza o ID gerado (timestamp) como chave de estado do widget em listas dinâmicas, 
        // essencial para o Flutter não "perder" a posição durante re-ordenamentos e deletes.
        key: ValueKey(task.id),
        
        // startActionPane: O que aparece se o usuário deslizar o card da Esquerda para a Direita ->
        startActionPane: ActionPane(
          // Define a animação da gaveta lateral (DrawerMotion é o estilo nativo de lista de e-mail).
          motion: const DrawerMotion(),
          children: [
            // Botão individual do deslize.
            SlidableAction(
              onPressed: (_) => onToggle(task.id), // Dispara o Callback.
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              // Troca o ícone baseando-se no fato da tarefa estar pendente ou concluída.
              icon: isDone ? Icons.undo : Icons.check,
              label: isDone ? 'Pendente' : 'Concluir',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        
        // endActionPane: O que aparece se o deslizar da Direita para a Esquerda <-
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(task.id), // Dispara o delete explícito.
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'Excluir',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        
        // O corpo visível real do Card.
        child: Container(
          // AUI Card (...)
        ),
      ),
    );
  }
}
```
