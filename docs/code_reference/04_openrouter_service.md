# Documentação Detalhada: `services/openrouter_service.dart`

Este arquivo lida exclusivamente com o barramento de rede e a integração com o provedor de Inteligência Artificial (OpenRouter). Age como um "Driver Secundário" na Clean Architecture.

## Explicação Linha a Linha

```dart
// Importa biblioteca padrão para transformar Map em String e vice-versa.
import 'dart:convert';
// Importa o cliente http, usando alias `http` para evitar colisões de nome de métodos.
import 'package:http/http.dart' as http;
// Importa pacote para acessar variáveis ocultas num arquivo .env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Importa o prompt engenhado para comandar o modelo de IA.
import '../constants/prompts.dart';

// Serviço de comunicação com IA Gen.
class OpenRouterService {
  // Cliente HTTP injetado por injeção de dependência via construtor (útil para Mock/Testes unitários).
  final http.Client _client;
  
  // Endpoint de completions da OpenRouter (padrão OpenAI API compatibility).
  static const String _url = 'https://openrouter.ai/api/v1/chat/completions';
  
  // Construtor. Se não for passado nenhum client customizado (teste), usa o Client padrão nativo.
  OpenRouterService({http.Client? client}) : _client = client ?? http.Client();
  
  // Getter privado e estático para pegar a chave com segurança do ambiente compilado (.env).
  static String get _apiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  // Função assíncrona principal: Envia a string "caótica" do usuário e retorna um Mapa validado (JSON).
  Future<Map<String, dynamic>> organizeTasks(String userText) async {
    try {
      // Dispara a requisição POST para a URL predefinida.
      final response = await _client.post(
        Uri.parse(_url),
        headers: {
          // Passa a chave (Bearer Token).
          'Authorization': 'Bearer $_apiKey',
          // Informa o tipo de retorno/envio.
          'Content-Type': 'application/json',
          // Header opcional exigido por política comercial da OpenRouter para identificar o app.
          'X-Title': 'Fluxo App',
        },
        body: jsonEncode({
          // Utiliza um modelo gratuito otimizado com "reasoning" (raciocínio).
          'model': 'nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free',
          // Configura o payload com padrão ChatML (System e User messages).
          'messages': [
            {'role': 'system', 'content': AppPrompts.systemPrompt},
            {'role': 'user', 'content': userText},
          ],
        }),
      );

      // Checa se o servidor retornou código de HTTP 200 OK.
      if (response.statusCode == 200) {
        // Deserializa todo o response body que a API enviou.
        final data = jsonDecode(response.body);
        
        // Acessa precisamente o texto de resposta gerado pelo LLM.
        String content = data['choices'][0]['message']['content'];
        
        // Mecanismo de Sanitização e Fallback: Alguns LLMs, mesmo proibidos no prompt,
        // geram markdown tags ("```json" ou "```") ao redor do JSON. Esta linha limpa as tags agressivamente.
        content = content.replaceAll('```json', '').replaceAll('```', '').trim();
        
        // Transforma a string sanitizada final em um Dart Map (JSON Dictionary).
        return jsonDecode(content);
      } else {
        // Se a chamada não voltar como 200 OK, a função arremessa uma exceção explícita contendo o erro.
        throw Exception('Erro ao processar tarefas: ${response.statusCode}');
      }
    } catch (e) {
      // Se a conexão falhar (Timeout) ou o JSON não der parse, o throw repassa o erro para a UI tratar.
      rethrow;
    }
  }
}
```
