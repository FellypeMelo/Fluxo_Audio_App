import 'package:flutter_test/flutter_test.dart';
import 'package:fluxo/models/task_model.dart';

void main() {
  group('Task Model Tests', () {
    final now = DateTime.now();
    final task = Task(
      id: '1',
      title: 'Test Task',
      priority: 'alta',
      category: 'trabalho',
      durationMin: 30,
      status: 'pendente',
      createdAt: now,
    );

    test('should convert to JSON correctly', () {
      final json = task.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['priority'], 'alta');
      expect(json['category'], 'trabalho');
      expect(json['duration_min'], 30);
      expect(json['status'], 'pendente');
      expect(json['created_at'], now.toIso8601String());
      expect(json['completed_at'], isNull);
    });

    test('should create from JSON correctly', () {
      final json = {
        'id': '2',
        'title': 'Another Task',
        'priority': 'media',
        'category': 'pessoal',
        'duration_min': 15,
        'status': 'concluida',
        'created_at': now.toIso8601String(),
        'completed_at': now.toIso8601String(),
      };

      final fromJson = Task.fromJson(json);

      expect(fromJson.id, '2');
      expect(fromJson.title, 'Another Task');
      expect(fromJson.priority, 'media');
      expect(fromJson.category, 'pessoal');
      expect(fromJson.durationMin, 15);
      expect(fromJson.status, 'concluida');
      expect(fromJson.createdAt, now);
      expect(fromJson.completedAt, now);
    });

    test('copyWith should update status and completedAt', () {
      final completedAt = DateTime.now();
      final updatedTask = task.copyWith(
        status: 'concluida',
        completedAt: () => completedAt,
      );

      expect(updatedTask.id, task.id);
      expect(updatedTask.status, 'concluida');
      expect(updatedTask.completedAt, completedAt);
      expect(updatedTask.title, task.title); // Unchanged
    });

    test('copyWith should allow setting completedAt to null', () {
      final taskWithDate = task.copyWith(completedAt: () => DateTime.now());
      expect(taskWithDate.completedAt, isNotNull);
      
      final taskNullDate = taskWithDate.copyWith(completedAt: () => null);
      expect(taskNullDate.completedAt, isNull);
    });
  });
}
