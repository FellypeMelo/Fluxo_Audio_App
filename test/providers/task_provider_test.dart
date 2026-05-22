import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluxo/providers/task_provider.dart';
import 'package:fluxo/models/task_model.dart';

void main() {
  // SharedPreferences.setMockInitialValues needs to be called before tests.
  // SharedPreferences uses a plugin-specific way to mock values.
  
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      taskProvider = TaskProvider();
      // Wait for initial load
      await Future.delayed(Duration.zero);
    });

    test('Initial state should be empty', () {
      expect(taskProvider.tasks, isEmpty);
      expect(taskProvider.isDarkMode, isFalse);
      expect(taskProvider.username, 'Estudante');
    });

    test('addTask should add a task and persist it', () async {
      taskProvider.addTask('Test Task', 'alta', 'trabalho', 30);
      
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Test Task');
      expect(taskProvider.tasks.first.priority, 'alta');
      
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('fluxo_tasks');
      expect(savedData, isNotNull);
      expect(savedData, contains('Test Task'));
    });

    test('toggleTask should change status and persist', () async {
      taskProvider.addTask('Task to Toggle', 'media', 'pessoal', 10);
      final taskId = taskProvider.tasks.first.id;
      
      expect(taskProvider.tasks.first.status, 'pendente');
      
      taskProvider.toggleTask(taskId);
      expect(taskProvider.tasks.first.status, 'concluida');
      expect(taskProvider.tasks.first.completedAt, isNotNull);
      
      taskProvider.toggleTask(taskId);
      expect(taskProvider.tasks.first.status, 'pendente');
      expect(taskProvider.tasks.first.completedAt, isNull);
    });

    test('deleteTask should remove task and persist', () async {
      taskProvider.addTask('Task to Delete', 'baixa', 'estudo', 5);
      final taskId = taskProvider.tasks.first.id;
      
      taskProvider.deleteTask(taskId);
      expect(taskProvider.tasks, isEmpty);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('fluxo_tasks'), '[]');
    });

    test('setDarkMode should update and persist', () async {
      await taskProvider.setDarkMode(true);
      expect(taskProvider.isDarkMode, isTrue);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('fluxo_dark_mode'), isTrue);
    });

    test('setUsername should update and persist', () async {
      await taskProvider.setUsername('John Doe');
      expect(taskProvider.username, 'John Doe');
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('fluxo_username'), 'John Doe');
    });

    test('clearAllData should remove all tasks', () async {
      taskProvider.addTask('Task 1', 'alta', 'pessoal', 10);
      await taskProvider.clearAllData();
      
      expect(taskProvider.tasks, isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('fluxo_tasks'), isFalse);
    });

    test('loadFromPrefs should restore state', () async {
      final now = DateTime.now();
      final task = Task(
        id: '123',
        title: 'Persisted Task',
        priority: 'alta',
        category: 'trabalho',
        durationMin: 60,
        status: 'pendente',
        createdAt: now,
      );
      
      SharedPreferences.setMockInitialValues({
        'fluxo_tasks': jsonEncode([task.toJson()]),
        'fluxo_dark_mode': true,
        'fluxo_username': 'Saved User',
      });
      
      final newProvider = TaskProvider();
      await Future.delayed(Duration.zero); // wait for _loadFromPrefs
      
      expect(newProvider.tasks.length, 1);
      expect(newProvider.tasks.first.title, 'Persisted Task');
      expect(newProvider.isDarkMode, isTrue);
      expect(newProvider.username, 'Saved User');
    });
    group('TaskProvider Stats', () {
      test('Stats should calculate correctly', () {
        taskProvider.addTask('T1', 'alta', 'p', 10);
        taskProvider.addTask('T2', 'alta', 'p', 10);
        taskProvider.toggleTask(taskProvider.tasks.first.id);
        
        final total = taskProvider.tasks.length;
        final completed = taskProvider.tasks.where((t) => t.status == 'concluida').length;
        
        expect(total, 2);
        expect(completed, 1);
      });
    });
  });
}
