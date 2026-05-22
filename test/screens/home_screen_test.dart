import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fluxo/screens/home_screen.dart';
import 'package:fluxo/providers/task_provider.dart';
import 'package:fluxo/models/task_model.dart';
import '../test_utils/test_helpers.dart';

class MockTaskProvider extends Mock implements TaskProvider {}

void main() {
  late MockTaskProvider mockProvider;

  setUp(() {
    mockProvider = MockTaskProvider();
    when(() => mockProvider.isDarkMode).thenReturn(false);
  });

  testWidgets('HomeScreen should show empty state when no tasks', (WidgetTester tester) async {
    when(() => mockProvider.tasks).thenReturn([]);

    await tester.pumpWidget(createTestWidget(
      child: const HomeScreen(),
      taskProvider: mockProvider,
    ));

    expect(find.text('Nenhuma tarefa pendente.'), findsOneWidget);
    expect(find.text('Tudo limpo por aqui!'), findsOneWidget);
  });

  testWidgets('HomeScreen should render list of tasks', (WidgetTester tester) async {
    final tasks = [
      Task(
        id: '1',
        title: 'Task High',
        priority: 'alta',
        category: 'trabalho',
        durationMin: 30,
        status: 'pendente',
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Task Low',
        priority: 'baixa',
        category: 'pessoal',
        durationMin: 10,
        status: 'pendente',
        createdAt: DateTime.now(),
      ),
    ];

    when(() => mockProvider.tasks).thenReturn(tasks);

    await tester.pumpWidget(createTestWidget(
      child: const HomeScreen(),
      taskProvider: mockProvider,
    ));

    expect(find.text('Task High'), findsOneWidget);
    expect(find.text('Task Low'), findsOneWidget);
    expect(find.text('Você tem 2 tarefas para hoje.'), findsOneWidget);
  });

  testWidgets('HomeScreen should sort tasks by priority', (WidgetTester tester) async {
     final tasks = [
      Task(
        id: '1',
        title: 'Low Task',
        priority: 'baixa',
        category: 'pessoal',
        durationMin: 10,
        status: 'pendente',
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'High Task',
        priority: 'alta',
        category: 'trabalho',
        durationMin: 30,
        status: 'pendente',
        createdAt: DateTime.now(),
      ),
    ];

    when(() => mockProvider.tasks).thenReturn(tasks);

    await tester.pumpWidget(createTestWidget(
      child: const HomeScreen(),
      taskProvider: mockProvider,
    ));

    // Verify order in ListView
    final titleFinders = find.byType(ListTile);
    expect(tester.widget<ListTile>(titleFinders.at(0)).title, isA<Text>().having((t) => t.data, 'text', 'High Task'));
    expect(tester.widget<ListTile>(titleFinders.at(1)).title, isA<Text>().having((t) => t.data, 'text', 'Low Task'));
  });
}
