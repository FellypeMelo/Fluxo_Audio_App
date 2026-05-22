import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fluxo/providers/task_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskProvider extends Mock implements TaskProvider {}

Widget createTestWidget({
  required Widget child,
  TaskProvider? taskProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider ?? TaskProvider(),
      ),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}
