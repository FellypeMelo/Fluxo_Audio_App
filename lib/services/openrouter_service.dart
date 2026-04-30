import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/prompts.dart';

class OpenRouterService {
  static const String _url = 'https://openrouter.ai/api/v1/chat/completions';
  
  static String get _apiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  Future<Map<String, dynamic>> organizeTasks(String userText) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'X-Title': 'Fluxo App',
        },
        body: jsonEncode({
          'model': 'nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free',
          'messages': [
            {'role': 'system', 'content': AppPrompts.systemPrompt},
            {'role': 'user', 'content': userText},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'];
        
        // Clean JSON if needed
        content = content.replaceAll('```json', '').replaceAll('```', '').trim();
        
        return jsonDecode(content);
      } else {
        throw Exception('Erro ao processar tarefas: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
