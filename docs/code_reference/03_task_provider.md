# Documentação Detalhada: `providers/task_provider.dart`

Este arquivo centraliza toda a lógica de estado do app e sua persistência. Utiliza a biblioteca `Provider` com `ChangeNotifier` para criar um fluxo de dados unidirecional reativo.

## Explicação Linha a Linha

```dart
// Importa biblioteca de conversão (JSON Encode/Decode).
import 'dart:convert';
// Importa material design para acessar ChangeNotifier (motor de reatividade do Flutter).
import 'package:flutter/material.dart';
// Importa a biblioteca de persistência de chave/valor local.
import 'package:shared_preferences/shared_preferences.dart';
// Importa o modelo Task.
import '../models/task_model.dart';

// Cria o provedor com mixin ChangeNotifier. Quando os dados mudam, ele avisa a UI para redesenhar.
class TaskProvider with ChangeNotifier {
  // Lista privada de tarefas armazenadas em memória.
  List<Task> _tasks = [];
  // Variável privada que guarda o estado do tema (claro/escuro).
  bool _isDarkMode = false;
  // Nome do usuário.
  String _username = 'Estudante';

  // Getters públicos (apenas leitura) para não permitir modificação externa direta nas variáveis privadas.
  List<Task> get tasks => _tasks;
  bool get isDarkMode => _isDarkMode;
  String get username => _username;

  // Construtor. É disparado no momento em que o app abre.
  TaskProvider() {
    // Carrega assincronamente os dados armazenados localmente.
    _loadFromPrefs();
  }

  // Função privada e assíncrona para ler as preferências.
  Future<void> _loadFromPrefs() async {
    // Instancia a conexão com o banco local.
    final prefs = await SharedPreferences.getInstance();
    
    // Lê a String JSON inteira (vetor de tarefas).
    final tasksJson = prefs.getString('fluxo_tasks');
    if (tasksJson != null) {
      // Converte a string JSON em uma lista de mapas (List<dynamic>).
      final List<dynamic> decoded = jsonDecode(tasksJson);
      // Mapeia a lista decodificada para objetos reais do tipo Task e armazena na memória RAM.
      _tasks = decoded.map((item) => Task.fromJson(item)).toList();
    }

    // Carrega o estado do tema escuro (falso por padrão).
    _isDarkMode = prefs.getBool('fluxo_dark_mode') ?? false;
    // Carrega o nome do usuário.
    _username = prefs.getString('fluxo_username') ?? 'Estudante';
    
    // Notifica todos os widgets que estão "ouvindo" esse provedor para redesenhar a tela com os novos dados.
    notifyListeners();
  }

  // Função privada para persistir alterações no armazenamento local.
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // Transforma a lista de objetos Task em JSON (List<Map>), e depois codifica numa String plana.
    final tasksJson = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    // Grava a string plana sob a chave 'fluxo_tasks'.
    await prefs.setString('fluxo_tasks', tasksJson);
  }

  // Função pública chamada para adicionar uma nova tarefa manualmente ou via retorno da IA.
  void addTask(String title, String priority, String category, int duration) {
    // Instancia uma nova Task.
    final newTask = Task(
      // Gera um ID "pseudo-único" usando o timestamp atual em milissegundos.
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
      category: category,
      durationMin: duration,
      status: 'pendente',
      createdAt: DateTime.now(),
    );
    // Adiciona ao estado da memória.
    _tasks.add(newTask);
    // Salva imediatamente no banco local para não perder o dado caso o app feche.
    _saveTasks();
    // Dispara rebuild da UI.
    notifyListeners();
  }

  // Inverte o estado de uma tarefa (Pendente <=> Concluída).
  void toggleTask(String id) {
    // Acha a tarefa na lista usando uma busca sequencial.
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      // Verifica o status atual e define a inversão.
      final newStatus = task.status == 'pendente' ? 'concluida' : 'pendente';
      
      // Substitui o item na lista por um CLONE do item (copyWith), garantindo integridade de estado.
      _tasks[index] = task.copyWith(
        status: newStatus,
        // Função lambda passada para completedAt para lidar explicitamente com a re-anulação (null).
        completedAt: () => newStatus == 'concluida' ? DateTime.now() : null,
      );
      // Salva em disco e notifica a UI.
      _saveTasks();
      notifyListeners();
    }
  }

  // Deleta uma tarefa passando o ID específico.
  void deleteTask(String id) {
    // Função removeWhere itera por todas as tasks e apaga as que dão true na condicional.
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  // Altera e persiste a escolha do modo escuro.
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fluxo_dark_mode', value);
    notifyListeners();
  }

  // Altera e persiste o nome do usuário para personalização na tela de Settings.
  Future<void> setUsername(String value) async {
    _username = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fluxo_username', value);
    notifyListeners();
  }

  // Realiza hard-reset (apaga tudo). Usado na aba Configurações (GDPR Right to Forget compliance local).
  Future<void> clearAllData() async {
    // Esvazia na RAM.
    _tasks = [];
    final prefs = await SharedPreferences.getInstance();
    // Esvazia no banco local.
    await prefs.remove('fluxo_tasks');
    notifyListeners();
  }
}
```
