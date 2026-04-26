import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isDarkMode = false;
  String _username = 'Estudante';

  List<Task> get tasks => _tasks;
  bool get isDarkMode => _isDarkMode;
  String get username => _username;

  TaskProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load tasks
    final tasksJson = prefs.getString('fluxo_tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      _tasks = decoded.map((item) => Task.fromJson(item)).toList();
    }

    // Load settings
    _isDarkMode = prefs.getBool('fluxo_dark_mode') ?? false;
    _username = prefs.getString('fluxo_username') ?? 'Estudante';
    
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString('fluxo_tasks', tasksJson);
  }

  void addTask(String title, String priority, String category, int duration) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
      category: category,
      durationMin: duration,
      status: 'pendente',
      createdAt: DateTime.now(),
    );
    _tasks.add(newTask);
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = task.status == 'pendente' ? 'concluida' : 'pendente';
      _tasks[index] = task.copyWith(
        status: newStatus,
        completedAt: newStatus == 'concluida' ? DateTime.now() : null,
      );
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fluxo_dark_mode', value);
    notifyListeners();
  }

  Future<void> setUsername(String value) async {
    _username = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fluxo_username', value);
    notifyListeners();
  }

  Future<void> clearAllData() async {
    _tasks = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fluxo_tasks');
    notifyListeners();
  }
}
