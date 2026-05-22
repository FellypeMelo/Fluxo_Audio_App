import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fluxo/screens/capture_screen.dart';
import 'package:fluxo/providers/task_provider.dart';
import 'package:fluxo/services/openrouter_service.dart';
import '../test_utils/test_helpers.dart';

class MockOpenRouterService extends Mock implements OpenRouterService {}

void main() {
  late MockTaskProvider mockProvider;
  late MockOpenRouterService mockService;

  setUp(() {
    mockProvider = MockTaskProvider();
    mockService = MockOpenRouterService();
    
    when(() => mockProvider.isDarkMode).thenReturn(false);
  });

  testWidgets('CaptureScreen handles text input and submission', (WidgetTester tester) async {
    final mockResponse = {
      'tasks': [
        {'title': 'New Task', 'priority': 'media', 'category': 'pessoal', 'duration_min': 10}
      ]
    };

    when(() => mockService.organizeTasks(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return mockResponse;
    });
    
    await tester.pumpWidget(createTestWidget(
      child: CaptureScreen(service: mockService),
      taskProvider: mockProvider,
    ));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'Estudar Flutter');
    await tester.tap(find.text('Organizar com IA'));
    
    // Pump to trigger the loading state
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump to complete the future
    await tester.pump(const Duration(milliseconds: 100));
    // Pump one more time for the SnackBar/UI update
    await tester.pump();
    
    verify(() => mockService.organizeTasks('Estudar Flutter')).called(1);
    verify(() => mockProvider.addTask('New Task', 'media', 'pessoal', 10)).called(1);
    expect(find.text('Sucesso! 1 tarefas organizadas.'), findsOneWidget);
  });

  testWidgets('CaptureScreen handles API error', (WidgetTester tester) async {
    when(() => mockService.organizeTasks(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      throw Exception('API Error');
    });
    
    await tester.pumpWidget(createTestWidget(
      child: CaptureScreen(service: mockService),
      taskProvider: mockProvider,
    ));

    await tester.enterText(find.byType(TextField), 'Err');
    await tester.tap(find.text('Organizar com IA'));
    
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(); // For SnackBar
    
    expect(find.text('Erro: Verifique sua chave da API ou conexão.'), findsOneWidget);
  });
}
