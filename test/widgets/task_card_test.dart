import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fluxo/widgets/task_card.dart';
import 'package:fluxo/models/task_model.dart';
import 'package:fluxo/constants/colors.dart';

void main() {
  final task = Task(
    id: '1',
    title: 'Test Task Card',
    priority: 'alta',
    category: 'trabalho',
    durationMin: 45,
    status: 'pendente',
    createdAt: DateTime.now(),
  );

  testWidgets('TaskCard renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TaskCard(
          task: task,
          onToggle: (_) {},
          onDelete: (_) {},
        ),
      ),
    ));

    expect(find.text('Test Task Card'), findsOneWidget);
    expect(find.text('ALTA'), findsOneWidget);
    expect(find.text('trabalho'), findsOneWidget);
    expect(find.text('45 min'), findsOneWidget);
    
    // Check for correct priority color (alta = error)
    final container = tester.widget<Container>(find.descendant(
      of: find.byType(Padding),
      matching: find.byType(Container),
    ).first);
    // Actually finding the specific priority container:
    final priorityText = find.text('ALTA');
    final priorityContainer = find.ancestor(of: priorityText, matching: find.byType(Container)).first;
    final boxDecoration = tester.widget<Container>(priorityContainer).decoration as BoxDecoration;
    expect(boxDecoration.color, AppColors.error.withValues(alpha: 0.1));
  });

  testWidgets('TaskCard handles toggle tap', (WidgetTester tester) async {
    String? toggledId;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TaskCard(
          task: task,
          onToggle: (id) => toggledId = id,
          onDelete: (_) {},
        ),
      ),
    ));

    // Tap the circle container in the leading part of ListTile using the Key
    await tester.tap(find.byKey(const Key('task_toggle_button')));
    expect(toggledId, '1');
  });
}
