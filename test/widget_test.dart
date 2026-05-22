import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluxo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    dotenv.loadFromString(envString: 'OPENROUTER_API_KEY=test');
  });

  testWidgets('App should launch and show MainScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const FluxoRoot());
    await tester.pumpAndSettle();

    expect(find.text('Minhas Tarefas'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    expect(find.text('Hoje'), findsOneWidget);
  });
}
