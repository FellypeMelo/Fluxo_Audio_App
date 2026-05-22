import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluxo/services/openrouter_service.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('OpenRouterService Tests', () {
    late OpenRouterService service;
    late MockHttpClient mockClient;

    setUpAll(() async {
      // Mock dotenv
      dotenv.loadFromString(envString: 'OPENROUTER_API_KEY=test_key');
      registerFallbackValue(Uri.parse('https://example.com'));
    });

    setUp(() {
      mockClient = MockHttpClient();
      service = OpenRouterService(client: mockClient);
    });

    test('organizeTasks should return parsed tasks on success (200)', () async {
      final mockResponse = {
        'choices': [
          {
            'message': {
              'content': jsonEncode({
                'tasks': [
                  {'title': 'Task 1', 'priority': 'alta', 'category': 'trabalho', 'duration_min': 30}
                ]
              })
            }
          }
        ]
      };

      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await service.organizeTasks('some text');

      expect(result['tasks'], isNotEmpty);
      expect(result['tasks'][0]['title'], 'Task 1');
      verify(() => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body'))).called(1);
    });

    test('organizeTasks should handle Markdown JSON blocks', () async {
      final mockResponse = {
        'choices': [
          {
            'message': {
              'content': '```json\n{"tasks": [{"title": "MD Task"}]}\n```'
            }
          }
        ]
      };

      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await service.organizeTasks('some text');

      expect(result['tasks'][0]['title'], 'MD Task');
    });

    test('organizeTasks should throw exception on non-200 response', () async {
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(() => service.organizeTasks('text'), throwsException);
    });

    test('organizeTasks should rethrow network errors', () async {
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(Exception('Network error'));

      expect(() => service.organizeTasks('text'), throwsException);
    });
  });
}
