# Documentação Detalhada: `models/task_model.dart`

Este arquivo define a Entidade/Modelo principal de dados do aplicativo: `Task`. Ele rege a estrutura que as tarefas processadas pela IA vão assumir em memória e no banco de dados local.

## Explicação Linha a Linha

```dart
// Declara a classe de modelo Task.
class Task {
  // Identificador único da tarefa (String gerada via timestamp).
  final String id;
  // Título e descrição enxuta da tarefa extraída do áudio.
  final String title;
  // Nível de prioridade (ex: 'alta', 'media', 'baixa').
  final String priority;
  // Categoria de agrupamento (ex: 'pessoal', 'trabalho').
  final String category;
  // Tempo estimado para conclusão retornado pela IA, em minutos.
  final int durationMin;
  // Status atual ('pendente' ou 'concluida').
  final String status;
  // Data e hora de criação no dispositivo.
  final DateTime createdAt;
  // Data e hora opcional (nullable) preenchida apenas quando a tarefa for finalizada.
  final DateTime? completedAt;

  // Construtor principal exigindo (required) quase todos os campos.
  Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.category,
    required this.durationMin,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  // Método que converte o objeto Task (em memória RAM) para um Map dinâmico,
  // necessário para a serialização JSON e armazenamento no SharedPreferences.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'category': category,
      'duration_min': durationMin,
      'status': status,
      // Converte o objeto DateTime para string no formato internacional ISO 8601.
      'created_at': createdAt.toIso8601String(),
      // Converte o DateTime para string caso não seja nulo, caso contrário, retorna null.
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  // Construtor factory (fábrica) que faz o inverso: Pega um Map lido do JSON (SharedPreferences)
  // e infla/reconstrói o objeto Task na memória do Dart.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      category: json['category'],
      durationMin: json['duration_min'],
      status: json['status'],
      // Realiza o parse da string em formato ISO 8601 de volta para o objeto DateTime.
      createdAt: DateTime.parse(json['created_at']),
      // Checa se a chave 'completed_at' não é nula antes de tentar fazer o parse.
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }
  
  // O método copyWith é um padrão da Clean Architecture funcional que serve para clonar 
  // um objeto mantendo a imutabilidade, apenas sobrescrevendo os valores informados.
  Task copyWith({
    String? status,
    // Função getter para lidar com possibilidade explícita de anulação (nullable overwrite).
    DateTime? Function()? completedAt,
  }) {
    return Task(
      id: id,
      title: title,
      priority: priority,
      category: category,
      durationMin: durationMin,
      // Se status foi passado, usa o novo; senão, usa o atual (`this.status`).
      status: status ?? this.status,
      createdAt: createdAt,
      // Se a função `completedAt` foi invocada, atribui o seu retorno. Senão, preserva o atual.
      completedAt: completedAt != null ? completedAt() : this.completedAt,
    );
  }
}
```
