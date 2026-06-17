# Documentação Detalhada: `screens/capture_screen.dart`

A tela de captura (`CaptureScreen`) é a interface central onde a captação de áudio e a digitação fluem para o processo da IA. É um StatefulWidget, ou seja, gere variáveis temporárias para exibição na tela.

## Explicação Linha a Linha

```dart
// Importa bibliotecas essenciais e o botão de microfone modularizado.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openrouter_service.dart';
import '../providers/task_provider.dart';
import '../widgets/mic_button.dart';

// O StatefulWidget permite que a tela sofra re-renderizações locais independentes do Provider.
class CaptureScreen extends StatefulWidget {
  final OpenRouterService? service;
  // Construtor aceita Injeção de Dependência Opcional do serviço para isolar testes da API.
  const CaptureScreen({super.key, this.service});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  // Controlador da caixa de texto, que permite ler o texto ou alterá-lo programaticamente.
  final TextEditingController _controller = TextEditingController();
  
  // Declara uma instância tardia (late) do serviço. Será iniciada no initState.
  late final OpenRouterService _openRouterService;
  
  // Variável local para travar os botões durante a comunicação na rede.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Instancia o serviço caso não tenha sido providenciado via injeção.
    _openRouterService = widget.service ?? OpenRouterService();
  }

  @override
  void dispose() {
    // É obrigatório descartar (dispose) o controlador do Flutter para não gerar vazamento de memória.
    _controller.dispose();
    super.dispose();
  }

  // Callback chamado pelo MicButton a cada vez que o motor de transcrição entende uma nova frase.
  void _handleTranscript(String text) {
    setState(() {
      // Se não havia texto, o texto inserido é a transcrição. Se já havia, faz um "append" com um espaço.
      _controller.text = _controller.text.isEmpty 
          ? text 
          : '${_controller.text} $text';
    });
  }

  // Acionado ao clicar no botão "Organizar com IA".
  Future<void> _handleOrganize() async {
    // Pega o que o usuário escreveu e retira espaços laterais vazios.
    final text = _controller.text.trim();
    if (text.isEmpty) {
      // Se estiver vazio, exibe alerta toast/snackbar na tela.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite ou fale algo antes de organizar.')),
      );
      return;
    }

    // Trava os botões com loading spinner.
    setState(() {
      _isLoading = true;
    });

    // Acessa o State Global (sem se registrar para ouvir as mudanças, por isso listen: false).
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    try {
      // Faz a chamada assíncrona bloqueante que vai na rede e invoca a LLM.
      final response = await _openRouterService.organizeTasks(text);
      // Pega o nó "tasks" do JSON retornado pela API.
      final List<dynamic> aiTasks = response['tasks'];

      // Percorre os arrays de tarefas formatadas que a LLM extraiu e adiciona no Provider Central.
      for (var taskData in aiTasks) {
        taskProvider.addTask(
          taskData['title'] ?? 'Nova Tarefa',
          taskData['priority'] ?? 'media',
          taskData['category'] ?? 'pessoal',
          taskData['duration_min'] ?? 0,
        );
      }

      // Limpa o input field após processamento exitoso.
      _controller.clear();
      // 'mounted' valida se a UI não foi destruída enquanto o await acontecia.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sucesso! ${aiTasks.length} tarefas organizadas.')),
        );
      }
    } catch (e) {
      // Se deu erro HTTP ou erro de parsing, exibe SnackBar vermelho para o user.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: Verifique sua chave da API ou conexão.')),
        );
      }
    } finally {
      // Finalmente, reseta a trava do botão de loading.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recupera a árvore de estilos visuais aplicada (modo claro/escuro).
    final theme = Theme.of(context);

    // O retorno omite a árvore de widgets padrão (TextFields, Columns).
    // Foco está nas regras de negócio e reatividade.
    return Scaffold( ... );
  }
}
```
